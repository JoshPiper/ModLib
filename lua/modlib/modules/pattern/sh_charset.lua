local format = string.format
local upper = string.upper

local MODULE = ModLib.Pattern or MODULE
MODULE.CharacterSet = MODULE.CharacterSet or setmetatable({}, {__index = MODULE.BaseClass, __call = MODULE.BaseClass.__call})
MODULE.CharacterSet.__index = MODULE.CharacterSet
MODULE.CharacterSet.__tostring = MODULE.BaseClass.__tostring

function MODULE.CharacterSet:New(...)
	return setmetatable({
		classes = {...},
		inverted = false
	}, self)
end

function MODULE.CharacterSet:Invert()
	self.inverted = not self.inverted
	return self
end

function MODULE.CharacterSet:ToString()
	local prefix = self.inverted and "^" or ""
	local map = {}
	for _, class in ipairs(self.classes) do
		if isstring(class) then
			class = self:Escape(class)
		end

		table.insert(map, tostring(class))
	end
	if map[1] == "^" then
		map[1] = "%^"
	end

	return format("[%s%s]", prefix, table.concat(map))
end

function MODULE.CharacterSet:Add(...)
	for _, set in ipairs({...}) do
		table.insert(self.classes, set)
	end

	return self
end

function MODULE.CharacterSet:AddRange(from, to)
	table.insert(self.classes, self.CharacterRange:New(from, to))
	return self
end
