-- Pretend I repeated the comment from ui/windowWrap.lua
-- almost verbatim here

local mods = require("mods")

local RPCHandlerWrapper = {
    handler = mods.requireFromPlugin("libraries.RPCHandler"),
    libhandl = mods.requireFromPlugin("libraries.discordRPC"),
}

-- expose lib to the client
RPCHandlerWrapper.handler.lib = RPCHandlerWrapper.libhandl

return RPCHandlerWrapper