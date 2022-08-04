local format = string.format
local upper = string.upper

local MODULE = ModLib.Pattern or MODULE
MODULE.CharacterClass = MODULE.CharacterClass or setmetatable({}, {__index = MODULE.BaseClass, __call = MODULE.BaseClass.__call})
MODULE.CharacterClass.__index = MODULE.CharacterClass
MODULE.CharacterClass.__tostring = MODULE.BaseClass.__tostring

function MODULE.CharacterClass:New(class)
	return setmetatable({
		class = class,
		inverted = false
	}, self)
end

function MODULE.CharacterClass:SetClass(class)
	self.class = class
	return self
end

function MODULE.CharacterClass:Invert()
	self.inverted = not self.inverted
	return self
end

function MODULE.CharacterClass:ToString()
	local class = self.class
	if self.inverted then
		class = upper(class)
	end

	return format("%%%s", class)
end

function MODULE.CharacterClass:LatinLetter()
	return self:New("a")
end

function MODULE.CharacterClass:ControlCharacter()
	return self:New("c")
end

function MODULE.CharacterClass:Digit()
	return self:New("d")
end

function MODULE.CharacterClass:PrintableCharacter()
	return self:New("d")
end

function MODULE.CharacterClass:LowercaseLetter()
	return self:New("l")
end

function MODULE.CharacterClass:Punctuation()
	return self:New("p")
end

function MODULE.CharacterClass:Space()
	return self:New("s")
end

function MODULE.CharacterClass:UppercaseLetter()
	return self:New("u")
end

function MODULE.CharacterClass:AlphaNumeric()
	return self:New("w")
end

function MODULE.CharacterClass:HexDigit()
	return self:New("x")
end
