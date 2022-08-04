--- Moderation Library Core
-- @module ModLib
-- @copyright Joshua Piper 2022
-- @author Joshua Piper

ModLib = ModLib or {
	REALM_SHARED = "sh",
	REALM_CLIENT = "cl",
	REALM_SERVER = "sv",

	Modules = {}
}

if not file.Exists("modlib", "DATA") then
	file.CreateDir("modlib")
end

function ModLib.AddCSLuaInclude(path)
	AddCSLuaFile(path)
	include(path)
end
ModLib.AddCSLuaInclude("string_ext.lua")
ModLib.AddCSLuaInclude("module.lua")

--- Create an argument error for the given function.
-- @tparam[opt] string|number funcName If nil, the calling function's name, if number, the name of the function 2 + n in the sdtack, if string, that is used directly.
-- @number argNum Which argument was incorrectly passed.
-- @string expected The expected type.
-- @param got The recieved value.
-- @rstring The formatted argument error.
function ModLib.ArgError(funcName, argNum, expected, got)
	if not funcName then
		funcName = (debug.getinfo(2, "n") or {}).name or "unknown function"
	elseif isnumber(funcName) then
		funcName = (debug.getinfo(2 + funcName, "n") or {}).name or "unknown function"
	end

	return string.format("Bad Argument #%i to %s, expected %s got %s.", argNum, funcName, expected, type(got))
end

function ModLib.FArgError(argNum, expected, got, funcName)
	error(ModLib.ArgError(funcName or 1, argNum, expected, got))
end

--- Detect the realm of a given path
-- @string path The lua path of the file to detect the realm of.
-- @rstring[opt] Realm prefix, one of ModLib.REALM_x, or nil if not found.
function ModLib.DetectRealm(path)
	if not isstring(path) then
		ModLib.FArgError(1, "LuaPath<string>", path, "ModLib.DetectRealm")
		return
	end

	local segment = path:match("^.-/?([^/]+).lua$")
	if not segment then
		ModLib.FArgError(1, "LuaPath<string>", path, "ModLib.DetectRealm")
		return
	end

	if segment == "shared" then
		return ModLib.REALM_SHARED
	end
	if segment == "init" then
		return ModLib.REALM_SERVER
	end

	local prefix = segment:match("^(%w+)_")
	if prefix == ModLib.REALM_SERVER or prefix == ModLib.REALM_SHARED or prefix == ModLib.REALM_CLIENT then
		return prefix
	end

	if path:ML_Contains("shared") then
		return ModLib.REALM_SHARED
	end

	if path:ML_Contains("server") then
		return ModLib.REALM_CLIENT
	end

	if path:ML_Contains("client") then
		return ModLib.REALM_SERVER
	end

	return nil
end

--- Include a path.
-- @string path Path to include.
-- @string[opt] realm Realm to include this path as, or attempt to auto-detect if nil.
function ModLib.Include(path, realm)
	if not realm then
		realm = ModLib.DetectRealm(path)
	end
	if not realm then
		return
	end

	print(string.format("Including %s in %s", path, realm))

	local client, server = realm == "cl" or realm == "sh", realm == "sh" or realm == "sv"

	if client then
		AddCSLuaFile(path)
		if CLIENT then
			include(path)
		end
	end
	if server and SERVER then
		include(path)
	end
end

local files, folders
files = file.Find("modlib/internals/*", "LUA")
for _, f in ipairs(files) do
	ModLib.Include("modlib/internals/" .. f)
end

files, folders = file.Find("modlib/modules/*", "LUA")
for _, f in ipairs(files) do
	MODULE = ModLib.Module:New(f)
	ModLib.Include("modlib/internals/" .. f)
	ModLib.Modules[f] = MODULE
end

local fp
for _, f in ipairs(folders) do
	fp = "modlib/modules/" .. f .. "/sh_init.lua"
	if file.Exists(fp, "LUA") then
		MODULE = ModLib.Module:New(f)
		ModLib.Include(fp)
		ModLib.Modules[f] = MODULE
	end
end
MODULE = nil
