local mods = require("mods")
local logger = require("logging")
local socket = require("socket")
local sceneHandler = require("scene_handler")
local ls = require("loaded_state")
local config = require("utils.config")

local discordRPC = mods.requireFromPlugin("libraries.discordRPC")
local pm = mods.requireFromPlugin("libraries.ProjectManager")
local settings = mods.getModSettings("LonnDiscordRPC")

local appId = "1198217977275879484"

local startedAt = os.time(os.date("*t"))

local RPCHandler = {}

--[[
    0: Show project name and bin name
    1: Only show loenn status
    2: Show nothing (disable rpc)
]]
RPCHandler.privacyLevel = settings.privacyLevel or 1

function RPCHandler.setPrivacyLevel(num)
    RPCHandler.privacyLevel = num
    settings.privacyLevel = num

    config.writeConfig(settings)
end

-- ref: https://github.com/pfirsich/lua-discordRPC/blob/master/main.lua

function discordRPC.errored(errorCode, message)
    logger.info(string.format("Discord: error (%d: %s)", errorCode, message))
end

function discordRPC.ready(userId, username)
    logger.info(string.format("Discord: ready (%s, %s)", userId, username))
end

function discordRPC.disconnected(errorCode, message)
    logger.info(string.format("Discord: disconnected (%d: %s)", errorCode, message))
end

RPCHandler.nextPresenceUpdate = 0

discordRPC.initialize(appId, true)

local function updatePresence()
    -- spam prevention
    if love.timer.getTime() < RPCHandler.nextPresenceUpdate then 
        return
    end

    -- before accessing pm data, let's check the state
    -- ls.filename is the path to the currently loaded map
    pm.checkState(ls.filename)

    -- get presence data
    local p_Details

    if RPCHandler.privacyLevel < 1 then
        p_Details = pm.mapName and "Working on " .. pm.mapName or "Working on a map"
        if not pm.probablyHasLoadedMap then -- handle this edge case
            p_Details = "No map loaded"
        end
    else
        p_Details = "Working on a map"
    end

    local p_State

    if RPCHandler.privacyLevel < 1 then
        p_State = pm.modName and "In mod " .. pm.modName or nil
    else
        p_State = nil
    end

    RPCHandler.presenceData = {
        details = p_Details,
        state = p_State,
        startTimestamp = startedAt,
    }

    --[[ only uncomment for dev purposes
    logger.info(RPCHandler.presenceData.details)
    logger.info(RPCHandler.presenceData.state)
    ]]
    
    --logger.info("Updating discord presence " .. RPCHandler.privacyLevel)
    if RPCHandler.privacyLevel < 2 then
        discordRPC.updatePresence(RPCHandler.presenceData)
    else
        discordRPC.clearPresence()
    end

    discordRPC.runCallbacks()

    RPCHandler.nextPresenceUpdate += 10.0
end

local device = {
    _type = "device",
    name = "LoennRPCDevice",
    _enabled = true,
}

-- called every update
function device.update()
    updatePresence()
end

-- thanks, celestecord
if sceneHandler._loennRPC_unloadSeq then sceneHandler._loennRPC_unloadSeq() end

local _sceneHandlerChangeScene = sceneHandler.changeScene
function sceneHandler.changeScene(name, ...)
    if name == "Editor" then
        local scene = sceneHandler.scenes[name]
        local item = $(scene.inputDevices):find(dev -> dev == device)

        if not scene._firstEnter and not item then
            -- insert our new device
            table.insert(scene.inputDevices, device)
        end
    end

    _sceneHandlerChangeScene(name, ...)
end

function _loennRPC_unloadSeq()
    sceneHandler.changeScene = _sceneHandlerChangeScene
end

mods.requireFromPlugin("libraries.RPCHandlerWrapper")["handler"] = RPCHandler

return RPCHandler