local MODULE = ModLib.Pattern or MODULE

MODULE.BaseClass = MODULE.BaseClass or setmetatable({}, {__index = MODULE})
MODULE.BaseClass.__index = MODULE.BaseClass

function MODULE.BaseClass:New()
	return setmetatable({}, self)
end
function MODULE.BaseClass:__call(...)
	return self:New(...)
end

function MODULE.BaseClass:Optional()
	self.repeats = "?"
	return self
end

function MODULE.BaseClass:OptionallyMany()
	self.repeats = "*"
	return self
end

function MODULE.BaseClass:Many()
	self.repeats = "+"
	return self
end

function MODULE.BaseClass:OptionallyManyLazy()
	self.repeats = "-"
	return self
end

function MODULE.BaseClass:Capture()
	return self.CaptureGroup(self)
end

function MODULE.BaseClass:ToString()
	return ""
end

function MODULE.BaseClass.__tostring(self)
	return string.format("%s%s", self:ToString(), self.repeats or "")
end
