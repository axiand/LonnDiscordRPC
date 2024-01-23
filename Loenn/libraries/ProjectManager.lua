local logger = require("logging")
local state = require("loaded_state")
local fs = require("utils.filesystem")
local mods = require("mods")

local ProjectManager = {
    currentProject = nil,
    lastKnownMapPath = nil,
    probablyHasLoadedMap = false,
    modName = nil,
    mapName = nil,
}

function ProjectManager.locateProject()
    return mods.getFilenameModPath(state.filename)
end

function ProjectManager.checkState(path)
    if not path then
        ProjectManager.probablyHasLoadedMap = false
    else ProjectManager.probablyHasLoadedMap = true end

    if path ~= ProjectManager.lastKnownMapPath then
        ProjectManager.lastKnownMapPath = path
        ProjectManager.currentProject = ProjectManager.locateProject()

        -- sometimes these are nil
        if ProjectManager.currentProject then
            local projsplit = fs.splitpath(ProjectManager.currentProject)
            ProjectManager.modName = projsplit[#projsplit]
        else ProjectManager.modName = nil end

        if path then
            local mapsplit = fs.splitpath(path)
            ProjectManager.mapName = mapsplit[#mapsplit]
        else ProjectManager.mapName = nil end
    end

    --[[
    if ProjectManager.currentProject then
        logger.info("current project path: " .. ProjectManager.currentProject)
    else logger.info("no project loaded") end
    ]]
end

return ProjectManager