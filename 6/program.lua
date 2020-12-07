local fun = require 'fun'

local function count(map)
	local acc = 0
	for item, count in pairs(map) do
		if type(item)=="string" and count == map[0] then
			acc = acc + 1
		end
	end
	return acc
end

local map = {}
local acc = 0

local json = require 'cjson'
for line in io.lines() do
	if line == "" then
		acc = acc + count(map)
		map = {}
	else
		for char in line:gmatch(".") do
			map[char] = (map[char] or 0) + 1
		end
		map[0] = (map[0] or 0) + 1
	end
end

print(acc)
