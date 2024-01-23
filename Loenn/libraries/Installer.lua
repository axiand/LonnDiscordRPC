-- downloads and installs the required rpc binaries
-- currently this only supports windows, todo obviously support other oses
-- this solution sucks, we dont want downloading
-- but im also too stupid to figure out how loenns copying functions work
-- gonna need guidance from people smarter than me
local fs = require("utils.filesystem")
local locations = require("file_locations")
local mods = require("mods")

local os = love.system.getOS()

if os ~= "Windows" then return end

local DLL_SOURCE_URL = "https://cdn.discordapp.com/attachments/518177276030877737/1198638610203820072/attachment.dll?ex=65bfa232&is=65ad2d32&hm=5b5f6bd8b25788e81a26c4569093893eeb642eb946967cab92257bcec6ba1d39&"

local targetPathSplit = fs.splitpath(locations.getSourcePath())
table.remove(targetPathSplit, #targetPathSplit) -- remove last item because its the executable file

fs.downloadURL(DLL_SOURCE_URL, fs.joinpath(fs.joinpath(targetPathSplit), "discord-rpc.dll"))