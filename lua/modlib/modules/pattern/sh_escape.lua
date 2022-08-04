local PatternSafe = string.PatternSafe

local MODULE = ModLib.Pattern or MODULE
MODULE.Escaper = MODULE.Escaper or setmetatable({}, {__index = MODULE.BaseClass, __call = MODULE.BaseClass.__call})
MODULE.Escaper.__index = MODULE.Escaper
MODULE.Escaper.__tostring = MODULE.BaseClass.__tostring

function MODULE.Escaper:New(letter)
	return setmetatable({
		letter = letter
	}, self)
end

function MODULE.Escaper:ToString()
	return PatternSafe(self.letter)
end
