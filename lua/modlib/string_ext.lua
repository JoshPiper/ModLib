local s = string

if not isfunction(s.ML_Contains) then
    local find = s.find
    function s:ML_Contains(other, usePatterns)
        return find(self, other, 1, not usePatterns)
    end
end

if not isfunction(s.ML_Format) then
    local gsub = s.gsub
    function s:ML_Format(args)
        gsub(self, '%${(.-)}', function(w) return tab[args] or ("${" .. w .. "}") end)
    end
end
