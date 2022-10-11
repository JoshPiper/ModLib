local path = ModLib.Path

local suite = {
	groupName = "ModLib.Path.CommonPath",
	cases = {}
}

local paths = {
	{"/root", "/root", "/root"},
	{"/root", "", ""},
	{"/root", "/", "/"},
	{"", "/root", ""},
	{"/", "/root", "/"},

	{"/root/directory/with/files", "/root", "/root"},
	{"/root/directory/with/files", "/root/directory", "/root/directory"},
	{"/root/directory/with/files", "/root/directory/with", "/root/directory/with"},
	{"/root/directory/with/files", "/root/directory/with/files", "/root/directory/with/files"},
}
for _, spec in ipairs(paths) do
	table.insert(suite.cases, {
		name = string.format("Get Longest Common Segment of %s and %s.", spec[1], spec[2]),
		func = function()
			expect(path:CommonPath(spec[1], spec[2])).to.eq(spec[3])
		end
	})
end

return suite
