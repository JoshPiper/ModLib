local path = ModLib.Path

local suite = {
	groupName = "ModLib.Path.Explode",
	cases = {}
}

local paths = {
	{"", {}},
	{".", {"."}},
	{"./dir", {".", "dir"}},
	{"/absolute", {"absolute"}},
	{"//absolute", {"absolute"}},
	{"/a/b", {"a", "b"}},
	{"/a//b", {"a", "b"}},
	{"relative", {"relative"}},
	{"relative/dir", {"relative", "dir"}},
}
for _, spec in ipairs(paths) do
	table.insert(suite.cases, {
		name = string.format("Split %s to %i segments", spec[1], #spec[2]),
		func = function()
			local segments, n = path:Explode(spec[1])
			expect(segements).to.beA("table")
			expect(#segements).to.eq(n)
			expect(#segements).to.eq(#spec[2])

			for i, seg in ipairs(spec[2]) do
				expect(segments[i]).to.eq(seg)
			end
		end
	})
end

return suite
