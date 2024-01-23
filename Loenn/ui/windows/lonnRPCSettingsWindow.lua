local logger = require("logging")
local mods = require("mods")
local ui = require("ui")
local uiElements = require("ui.elements")

local widgetUtils = require("ui.widgets.utils")

local lonnRPCSettingsWindow = {}

local lonnRPCSettingsWindowGroup = uiElements.group({})

function lonnRPCSettingsWindow.open(_)
    local wTitle = "Window..."

    local wContent = uiElements.column({
        uiElements.label("Sorry, there's nothing here yet")
    })

    local window = uiElements.window(wTitle, wContent)

    lonnRPCSettingsWindowGroup.parent:addChild(window)

    widgetUtils.addWindowCloseButton(window)

    return window
end

function lonnRPCSettingsWindow.getWindow()
    mods.requireFromPlugin("ui.windowWrap")["lonnRPCSettingsWindow"] = lonnRPCSettingsWindow

    return lonnRPCSettingsWindowGroup
end

return lonnRPCSettingsWindow