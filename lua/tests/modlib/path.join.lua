local suite = {
	groupName = "ModLib.Path.Join",
	cases = {}
}

local paths = {
	{"/root", "folder", "/root/folder"},
	{"/root/", "folder/", "/root/folder"},
	{"root", "folder", "root/folder"},
	{"root", "/folder", "/folder"}
}
for i, spec in ipairs(paths) do
	table.insert(suite.cases, {
		name = "Correctly Join Paths [" .. i .. "]",
		func = function()
			expect(path.Join(spec[1], spec[2])).to.eq(spec[3])
		end
	})
end

return suite
