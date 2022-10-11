local path = ModLib.Path

local suite = {
	groupName = "ModLib.Path.Relative",
	cases = {
		{
			name = "Relative Path must fail.",
			func = function()
				expect(function() path:Relative("root", "/") end).to.errWith("Input path must be absolute.")
			end
		}, {
			name = "Relative Root must fail.",
			func = function()
				expect(function() path:Relative("/root", "root") end).to.errWith("Root path must be absolute.")
			end
		}
	}
}

local paths = {
	{"/root", "/root", "."},
	{"/root/directory/with/files", "/root", "directory/with/files"},
	{"/root/directory/with/files", "/root/directory", "with/files"},
	{"/root/directory/with/files", "/root/directory/with", "files"},
	{"/root/directory/with/files", "/root/directory/with/files", "."},
}
for _, spec in ipairs(paths) do
	table.insert(suite.cases, {
		name = string.format("Get %s as a relative path from %s.", spec[1], spec[2]),
		func = function()
			expect(path:Relative(spec[1], spec[2])).to.eq(spec[3])
		end
	})
end

return suite
