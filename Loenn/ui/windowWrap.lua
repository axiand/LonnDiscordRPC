--[[
    windowWrappers is populated by individual window modules.

    This is somewhat cursed, but necessary to avoid jank.
    When opening a window, ONLY EVER do it via importing windowWrappers.
    (this is not optional)
]]
local windowWrappers = {}

return windowWrappers