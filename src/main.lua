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
        "God Pool",
        "Boon Bans",
        "Biome Control",
    }
}

local PACK_ID = "run-director"
local frameworkCallbackCache = {}

local function GetFramework()
    return rom.mods["adamant-ModpackFramework"]
end

local function GetFrameworkCallback(factoryName)
    local framework = GetFramework()
    local factory = framework and framework[factoryName]
    if type(factory) ~= "function" then
        frameworkCallbackCache[factoryName] = nil
        return nil
    end

    local cached = frameworkCallbackCache[factoryName]
    if not cached or cached.framework ~= framework or cached.factory ~= factory then
        cached = {
            framework = framework,
            factory = factory,
            callback = factory(PACK_ID),
        }
        frameworkCallbackCache[factoryName] = cached
    end
    return cached.callback
end

local function init()
    local Framework = GetFramework()
    assert(Framework and type(Framework.init) == "function",
        "adamant-RunDirector_Core: adamant-ModpackFramework is not loaded")

    Framework.init({
        packId      = PACK_ID,
        windowTitle = "Run Director",
        config      = config,
        def         = def,
        modutil     = modutil,
        hideHashMarker = true,
    })
end

local function renderWindow()
    local callback = GetFrameworkCallback("getRenderer")
    if callback then
        callback()
    end
end

local function alwaysDraw()
    local callback = GetFrameworkCallback("getAlwaysDrawRenderer")
    if callback then
        callback()
    end
end

local function addMenuBar()
    local callback = GetFrameworkCallback("getMenuBar")
    if callback then
        callback()
    end
end

local loader = reload.auto_single()
modutil.once_loaded.game(function()
    rom.gui.add_imgui(renderWindow)
    rom.gui.add_always_draw_imgui(alwaysDraw)
    rom.gui.add_to_menu_bar(addMenuBar)
    loader.load(nil, init)
end)
