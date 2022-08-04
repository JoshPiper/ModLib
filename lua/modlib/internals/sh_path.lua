--- Path Manipulation Library
-- @module ModLib.Path
-- @copyright Joshua Piper 2022
-- @author Joshua Piper

local StartsWith = string.StartWith
local EndsWith = string.EndsWith
local PatternSafe = string.PatternSafe
local match = string.match
local gmatch = string.gmatch

ModLib.Path = ModLib.Path or ModLib.Module:New("path")

ModLib.Path.data = {
	cur = '.',
	prev = '..',
	ext = '.',
	sep = '/',
	pathSep = ':'
}

ModLib.Path.patterns = {
	inGroup = {},
	notInGroup = {}
}
for name, value in pairs(ModLib.Path.data) do
	ModLib.Path.patterns.inGroup[name] = string.format("[%s]", PatternSafe(value))
	ModLib.Path.patterns.notInGroup[name] = string.format("[^%s]", PatternSafe(value))
end

ModLib.Path.patterns.pathSplit = string.format("(.-%s?)(%s*)$", ModLib.Path.patterns.inGroup.sep, ModLib.Path.patterns.notInGroup.sep)
ModLib.Path.patterns.extSplit = string.format("(.-)(%s?%s*)$", ModLib.Path.patterns.inGroup.ext, ModLib.Path.patterns.notInGroup.ext)
ModLib.Path.patterns.split = string.format("%s+", ModLib.Path.patterns.notInGroup.sep)

--- Check if a path is absolute (begins with a /).
-- @string path Path to check.
-- @rbool
function ModLib.Path:IsAbs(path)
	return StartsWith(path, self.data.sep)
end

--- Join paths together, inserting path seperators where approprate.
-- @tparam string[]|string ... Either a list of strings, or a vararg of strings.
-- @rstring Joined, but non-normalised path.
function ModLib.Path:Join(...)
	local out = {}

	local n = select("#", ...)
	if n == 1 then
		local p = select(1, ...)
		if istable(p) then
			return self:Join(unpack(p))
		end
	end

	for i = 1, n do
		local p = select(i, ...)
		if self:IsAbs(p) then
			out = {}
		end

		table.insert(out, p)
	end

	n = #out
	if n == 1 then
		return out[1]
	end

	for i = 2, n do
		local pv, nx = out[i - 1], out[i]
		if not EndsWith(pv, self.data.sep) and not StartsWith(nx, self.data.sep) then
			out[i - 1] = pv .. self.data.sep
		end
	end

	return table.concat(out, "")
end

--- Split a file path, returning the directory and the filename.
-- Output is handled in such a way that dir .. file == path
-- @string path Pathlike string.
-- @rstring Directory, including trailing /.
-- @rstring Filename
function ModLib.Path:Split(path)
	local dir, filePath = match(path, self.patterns.pathSplit)
	return dir or "", filePath or ""
end

--- Split a file name, returning the base name and the extension.
-- Output is handled in such a way that name .. ext == filename
-- @string path Pathlike string.
-- @rstring Filename, including any preceding directories.
-- @rstring Extension, including the leading .
function ModLib.Path:SplitExt(path)
	local name, ext = match(path, self.patterns.extSplit)
	if not StartsWith(ext, self.data.ext) then
		name = ext
		ext = ""
	end
	return name or "", ext or ""
end

--- Get the base file name from a path.
-- @string path Pathlike string.
-- @rstring Filename.
function ModLib.Path:BaseName(path)
	return select(2, match(path, self.patterns.pathSplit)) or ""
end

--- Get the base file name from a path.
-- @string path Pathlike string.
-- @rstring Directory, including trailing /.
function ModLib.Path:DirName(path)
	return match(path, self.patterns.pathSplit) or ""
end

--- Generate an iterator, which goes through each segment of a path.
-- @string path Pathlike string.
-- @rfunc Path Iterator Function
function ModLib.Path:Dirise(path)
	return gmatch(path, self.patterns.split)
end

--- Explode a path to a sequential table of path segments.
-- @string path Pathlike string.
-- @treturn string[]
function ModLib.Path:Explode(path)
	local n, out = 0, {}
	for part in self:Dirise(path) do
		n = n + 1
		out[n] = part
	end
	return out, n
end

--- Normalise a path.
-- Remove trailing slash, remove redudant .. calls, remove leading current dir markings, etc.
-- @string path Pathlike string.
-- @rstring
function ModLib.Path:Normalize(path)
	if path == "" then
		return self.data.cur
	end

	local abs = self:IsAbs(path) and self.data.sep or ""
	local n
	path, n = self:Explode(path)

	while path[1] == "." do
		table.remove(path, 1)
		n = n - 1
	end

	if n == 0 then
		return self.data.cur
	elseif n == 1 then
		local part = path[1]
		if part ~= self.data.cur and part ~= self.data.prev then
			return abs .. path[1]
		end
	end

	local changed = true
	while n >= 2 and changed do
		changed = false
		for i = 2, n do
			local nx = path[i]
			if nx == self.data.prev then
				table.remove(path, i - 1)
				table.remove(path, i - 1)
				n = n - 2
				changed = true
				break
			end
		end
	end

	if n == 0 then
		return self.data.cur
	elseif n == 1 then
		local part = path[1]
		if part ~= self.data.cur and part ~= self.data.prev then
			return abs .. path[1]
		end
	end

	return abs .. table.concat(path, self.data.sep)
end

--- Get the longest common ancestor of two paths.
-- @string path Pathlike string.
-- @string otherPath Pathlike string.
-- @rstring Common path, or an empty string if there is none.
function ModLib.Path:CommonPath(path, otherPath)
	local abs = self:IsAbs(path)
	if abs ~= self:IsAbs(otherPath) then
		return ""
	end
	abs = abs and self.data.sep or ""

	path = self:Explode(self:Normalize(path))
	local i = 0
	for part in self:Dirise(self:Normalize(otherPath)) do
		i = i + 1
		if path[i] ~= part then
			return self:Normalize(abs .. table.concat(path, self.data.sep, 1, i - 1))
		end
	end

	return self:Normalize(abs .. table.concat(path, self.data.sep))
end
