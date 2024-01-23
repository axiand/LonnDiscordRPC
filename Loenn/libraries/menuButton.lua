local logger = require("logging")
local menubar = require("ui.menubar").menubar
local loadedState = require("loaded_state")
local mods = require("mods")

local WindowStore = mods.requireFromPlugin("ui.windowWrap")
local rhw = mods.requireFromPlugin("libraries.RPCHandlerWrapper")

local menubarButtonData = {"lonn_drpc_menu", {
        {"lonn_drpc_menu_settings", function () WindowStore.lonnRPCSettingsWindow.open() end},
        {"lonn_drpc_menu_privacy", {
            {"lonn_drpc_menu_privacy_low", function () rhw.handler.setPrivacyLevel(0) end},
            {"lonn_drpc_menu_privacy_medium", function () rhw.handler.setPrivacyLevel(1) end},
            {"lonn_drpc_menu_privacy_high", function () rhw.handler.setPrivacyLevel(2) end},
        }}
    }
}

local fileMenu = $(menubar):find(menu -> menu[1] == "file")[2]
local selfMenu = $(fileMenu):find(menu -> menu[1] == "lonn_drpc_menu")

if not selfMenu then
    table.insert(fileMenu, menubarButtonData)
end