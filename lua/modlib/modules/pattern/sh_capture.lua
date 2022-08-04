local MODULE = ModLib.Pattern or MODULE

MODULE.CaptureGroup = MODULE.CaptureGroup or setmetatable({}, {__index = MODULE, __call = MODULE.BaseClass.__call})
MODULE.CaptureGroup.__index = MODULE.CaptureGroup
MODULE.CaptureGroup.__tostring = MODULE.BaseClass.__tostring

function MODULE.Pattern:New(...)
	return setmetatable({
		entries = {...},
	}, self)
end

function MODULE.Pattern:Add(...)
	local n = select("#", ...)
	for i = 1, n do
		table.insert(self.entries, select(i, ...), nil)
	end

	return self
end

function MODULE.Pattern:ToString()
	local out = {}
	for _, entry in ipairs(self.entries) do
		table.insert(out, tostring(entry))
	end

	if self.anchorStart then
		table.insert(out, 1, "^")
	elseif out[1] == "^" then
		out[1] = "%^"
	end
	if self.anchorEnd then
		table.insert(out, "$")
	elseif out[#out] == "$" then
		out[#out] = "%$"
	end

	return table.concat(out, "")
end
