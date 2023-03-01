if SERVER then return end

local lang = GetConVar("gmod_language"):GetString()
local strings

local fileName = "lang_"..lang..".lua" -- Replace with the name of the Lua file you want to check
local filePath = "lua/autorun/" .. fileName -- Construct the path to the file

if file.Exists(filePath, "GAME") then
  strings = include("lang_"..lang..".lua")
else
  strings = include("lang_en.lua")
end

language.Add("tool.disintegrator.name", strings.name)
language.Add("tool.disintegrator.desc", strings.desc)

language.Add("tool.disintegrator.left", strings.left)
language.Add("tool.disintegrator.right", strings.right)
language.Add("tool.disintegrator.reload", strings.reload)