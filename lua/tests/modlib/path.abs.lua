local path = ModLib.Path

local suite = {
	groupName = "ModLib.Path.IsAbs",
	cases = {}
}

local paths = {
	{"/absolute", true},
	{"./relative", false},
	{"relative", false},
	{"/absolute/with_subdir", true},
	{"./relative/with_subdir", false},
	{"relative/with_subdir", false}
}
for _, spec in ipairs(paths) do
	table.insert(suite.cases, {
		name = string.format("Mark %s as %s.", spec[1], spec[2] and "absolute" or "relative"),
		func = function()
			expect(path:IsAbs(spec[1])).to.eq(spec[3])
		end
	})
end

return suite
