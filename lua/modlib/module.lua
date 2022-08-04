--- Moderation Library Core
-- @module ModLib
-- @copyright Joshua Piper 2022
-- @author Joshua Piper

ModLib.Module = ModLib.Module or {}
ModLib.Module.__index = ModLib.Module

function ModLib.Module:New(key)
    local mod = {}
    if key ~= nil then
        mod.key = key
    end

    return setmetatable(mod, self)
end

-- function ModLib.Module:OpenFile(fileName, mode)
--     if not mode then
--         mode = "r"
--     end

--     local p = string.format("modlib/module/%s/%s", self.key, fileName)
--     if not file.Exists("modlib/module/" .. ")

--     return file.Open("modlib/")

-- function ModLib.Module:WriteFile()
