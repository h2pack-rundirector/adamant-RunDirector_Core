-- =============================================================================
-- adamant-ModpackRunDirectorCore: Modpack Coordinator
-- =============================================================================
-- Thin coordinator: wires globals, owns config and def, delegates everything
-- else to adamant-ModpackFramework.

local mods = rom.mods
mods['SGG_Modding-ENVY'].auto()

---@diagnostic disable: lowercase-global
rom = rom
_PLUGIN = _PLUGIN
game = rom.game
modutil = mods['SGG_Modding-ModUtil']
local chalk   = mods['SGG_Modding-Chalk']
local reload  = mods['SGG_Modding-ReLoad']

local config = chalk.auto('config.lua')

local def = {
    NUM_PROFILES    = #config.Profiles,
    defaultProfiles = {},
    moduleOrder = {
        "GodPool",
        "BoonBans",
        "BiomeControl",
    }
}

local PACK_ID = "run-director"
local frameworkParams = nil
local rebuildInProgress = false

local function rebuildFramework()
    if rebuildInProgress or not frameworkParams then
        return false
    end

    local Framework = rom.mods["adamant-ModpackFramework"]
    assert(Framework and type(Framework.init) == "function",
        "adamant-RunDirector_Core: adamant-ModpackFramework is not loaded")

    rebuildInProgress = true
    local ok, err = xpcall(function()
        Framework.init(frameworkParams)
    end, debug.traceback)
    rebuildInProgress = false

    if not ok then
        error(string.format("Framework rebuild failed for pack '%s': %s", PACK_ID, tostring(err)))
    end

    return true
end

mods.on_all_mods_loaded(function()
    local lib = rom.mods["adamant-ModpackLib"]
    assert(lib and lib.lifecycle and type(lib.lifecycle.registerCoordinator) == "function",
        "adamant-RunDirector_Core: adamant-ModpackLib is not loaded")
    lib.lifecycle.registerCoordinator(PACK_ID, config)
    lib.lifecycle.registerCoordinatorRebuild(PACK_ID, rebuildFramework)
end)

local function init()
    local Framework = rom.mods["adamant-ModpackFramework"]
    assert(Framework and type(Framework.init) == "function",
        "adamant-RunDirector_Core: adamant-ModpackFramework is not loaded")

    frameworkParams = {
        packId      = PACK_ID,
        windowTitle = "Run Director",
        config      = config,
        def         = def,
        hideHashMarker = true,
    }
    Framework.init(frameworkParams)
end

local loader = reload.auto_single()

local function registerGui()
    local Framework = rom.mods["adamant-ModpackFramework"]
    assert(Framework and type(Framework.getRenderer) == "function",
        "adamant-RunDirector_Core: adamant-ModpackFramework is not loaded")

    rom.gui.add_imgui(Framework.getRenderer(PACK_ID))
    rom.gui.add_always_draw_imgui(Framework.getAlwaysDrawRenderer(PACK_ID))
    rom.gui.add_to_menu_bar(Framework.getMenuBar(PACK_ID))
end

modutil.once_loaded.game(function()
    loader.load(registerGui, init)
end)
