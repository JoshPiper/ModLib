local path = ModLib.Path

local suite = {
	groupName = "ModLib.Path.Split",
	cases = {}
}

local paths = {
	{"/absolute", "/", "absolute"},
	{"./relative", "./", "relative"},
	{"relative", "", "relative"},
	{"/absolute/with_subdir", "/absolute/", "with_subdir"},
	{"./relative/with_subdir.extension", "./relative/", "with_subdir.extension"},
	{"relative/with_subdir", "relative/", "with_subdir"},
	{"relative//with_doubleslash", "relative//", "with_doubleslash"}
}
for _, spec in ipairs(paths) do
	table.insert(suite.cases, {
		name = string.format("Split %s to (%s, %s)", spec[1], spec[2], spec[3]),
		func = function()
			local a, b = path:Split(spec[1])
			expect(a).to.eq(spec[2])
			expect(b).to.eq(spec[3])
		end
	})
end

return suite
