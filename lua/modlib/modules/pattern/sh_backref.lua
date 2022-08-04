local MODULE = ModLib.Pattern or MODULE

MODULE.BackReference = MODULE.BackReference or setmetatable({}, {__index = MODULE.CharacterClass, __call = MODULE.BaseClass.__call})
MODULE.BackReference.__index = MODULE.BackReference
MODULE.BackReference.__tostring = MODULE.BaseClass.__tostring

function MODULE.BackReference:SetId(id)
	self.class = id
	return self
end
