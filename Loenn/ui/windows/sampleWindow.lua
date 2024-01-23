--[[
    This window should not be used!!! It is only here for reference

    Things to note:
    Replace all instances of "samplewindow" with whatever the
    name of the window should be

    wContent is a nested tree of uiElements.* objects, I think

    All the basic elements shown here must remain intact.
]]--

local logger = require("logging")
local mods = require("mods")
local ui = require("ui")
local uiElements = require("ui.elements")

local widgetUtils = require("ui.widgets.utils")

local sampleWindow = {}

local sampleWindowGroup = uiElements.group({})

function sampleWindow.open(_)
    local wTitle = "Window..."

    local wContent = uiElements.column({
        uiElements.label("My Window")
    })

    local window = uiElements.window(wTitle, wContent)

    sampleWindowGroup.parent:addChild(window)

    widgetUtils.addWindowCloseButton(window)

    return window
end

function sampleWindow.getWindow()
    mods.requireFromPlugin("ui.windowWrap")["sampleWindow"] = sampleWindow

    return sampleWindowGroup
end

return sampleWindow