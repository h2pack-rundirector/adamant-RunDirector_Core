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

local Framework = mods['adamant-ModpackFramework']

local def = {
    NUM_PROFILES    = #config.Profiles,
    defaultProfiles = {},
    groupStyleDefault = Framework.GroupStyle.SEPARATOR,
    sidebarOrder = Framework.SidebarOrder.CATEGORY_FIRST,
    categoryOrder = {
        "God Pool",
        "Boon Bans",
        "Encounters"

    }
}

local PACK_ID = "run-director"

local function init()
    Framework.init({
        packId      = PACK_ID,
        windowTitle = "Run Director",
        config      = config,
        def         = def,
        modutil     = modutil,
    })
end

local loader = reload.auto_single()
modutil.once_loaded.game(function()
    rom.gui.add_imgui(Framework.getRenderer(PACK_ID))
    rom.gui.add_to_menu_bar(Framework.getMenuBar(PACK_ID))
    loader.load(init, init)
end)
