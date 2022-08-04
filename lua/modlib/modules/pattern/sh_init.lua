--- Pattern Manipulation Librar
-- @module ModLib.Pattern
-- @copyright Joshua Piper 2022
-- @author Joshua Piper

ModLib.Pattern = ModLib.Pattern or MODULE

ModLib.Include("sh_base.lua")
ModLib.Include("sh_pattern.lua")
ModLib.Include("sh_escape.lua")
ModLib.Include("sh_charclass.lua")
ModLib.Include("sh_charset.lua")
ModLib.Include("sh_charrange.lua")
ModLib.Include("sh_capture.lua")
ModLib.Include("sh_backref.lua")

function MODULE:Escape(str)
	return self.Escaper:New(str)
end
