-- downloads and installs the required rpc binaries
-- currently this only supports windows, todo obviously support other oses
-- this solution sucks, we dont want downloading
-- but im also too stupid to figure out how loenns copying functions work
-- gonna need guidance from people smarter than me
local fs = require("utils.filesystem")
local locations = require("file_locations")
local mods = require("mods")
local logger = require("logging")

local wrap = mods.requireFromPlugin("libraries.RPCHandlerWrapper")

local rpcHandler = wrap.handler

local OS_NAME_MAP = {
    ["Windows"] = "discord-rpc-win",
    ["Linux"] = "discord-rpc-linux",
    ["OS X"] = "discord-rpc-osx",
}

local OS_EXT_MAP = {
    ["Windows"] = "dll",
    ["Linux"] = "so",
    ["OS X"] = "dylib",
}

local os = love.system.getOS()

-- it seems like ffi.load looks for platform-specific file exts
local function platformFileName()
    return "lib-discord-rpc." .. OS_EXT_MAP[os]
end

if OS_NAME_MAP[os] == nil then
    logger.info("No binary dist found for target " .. os)
    return
end

local GH_NAME = "axiand"
local GH_REPO = "LonnDiscordRPC"

local DLL_SOURCE_URL = "https://raw.githubusercontent.com/" .. GH_NAME .. "/" .. GH_REPO .. "/dist/dist/" .. OS_NAME_MAP[os]

local targetPathSplit = fs.splitpath(locations.getSourcePath())
table.remove(targetPathSplit, #targetPathSplit) -- remove last item because its the executable file

if fs.isFile(fs.joinpath(fs.joinpath(targetPathSplit), platformFileName())) then
    logger.info("RPC binary already exists, skipping setup")
else
    fs.downloadURL(DLL_SOURCE_URL, fs.joinpath(fs.joinpath(targetPathSplit), platformFileName()))
end

-- assuming everything went right, init the handler
rpcHandler.boot()