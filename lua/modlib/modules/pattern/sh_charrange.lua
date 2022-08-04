local format = string.format
local upper = string.upper

local MODULE = ModLib.Pattern or MODULE
MODULE.CharacterRange = MODULE.CharacterRange or setmetatable({}, {__index = MODULE.BaseClass, __call = MODULE.BaseClass.__call})
MODULE.CharacterRange.__index = MODULE.CharacterRange
MODULE.CharacterRange.__tostring = MODULE.BaseClass.__tostring

function MODULE.CharacterRange:New(rangeStart, rangeEnd)
	return setmetatable({
		rangeStart = rangeStart,
		rangeEnd = rangeEnd
	}, self)
end

function MODULE.CharacterRange:ToString()
	return format("%s-%s", self.rangeStart, self.rangeEnd)
end
