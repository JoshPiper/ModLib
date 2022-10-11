local path = ModLib.Path

local suite = {
	groupName = "ModLib.Path.Normalize",
	cases = {}
}

local paths = {
	{"", "."},
	{".", "."},
	{"./", "."},
	{"./dir", "dir"},
	{"dir/..", "."},
	{"dir/../dir", "dir"},
	{"/root", "/root"},
	{"/root/", "/root"},
	{"/root/dir", "/root/dir"},
	{"/root/dir/", "/root/dir"},
	{"/root/dir/../", "/root"},
	{"//root//dir//..//", "/root"},
	{"/", "/"}
}
for _, spec in ipairs(paths) do
	table.insert(suite.cases, {
		name = string.format("Normalise %s to %s", spec[1], spec[2]),
		func = function()
			expect(path:Normalize(spec[1])).to.eq(spec[2])
		end
	})
end

return suite
