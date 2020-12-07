local lpeg = require 'lpeg'

local function yp(i) print(require'lyaml'.dump{i}) end

--------------------------------------------------------------------------------

local word = lpeg.R'az' ^ 1
local space = lpeg.P' '^1
local function concat(a, b, ...)
	if b then
		return concat(a * space * b, ...)
	else
		return a
	end
end
local bag = lpeg.P('bags') + lpeg.P('bag')

local color = lpeg.C(concat(word, word))
local number = lpeg.R'09' ^ 1 / tonumber

local item = concat(
	concat(number, color) / function(number, name) return {name, number} end +
	color / function(name) return { name, 1 } end,
	bag)

local function map(pairs)
	local map = {}
	for i, pair in ipairs(pairs) do
		map[pair[1]]=pair[2]
	end
	return map
end

local list =
	lpeg.P 'no other bags.' / function() return {} end +
	lpeg.Ct(item * ("," * space * item) ^ 0)

list = list / map

local rule = color * space * 'bags contain' * space * list

--------------------------------------------------------------------------------

local bags = {}
for line in io.lines() do
	local color, elements = rule:match(line)
	bags[color] = elements
end

local function parents(bags, target, acc)
	acc = acc or {}

	for bag, children in pairs(bags) do
		if children[target] then
			if not acc[bag] then
				acc[bag] = target
				table.insert(acc, bag)
				parents(bags, bag, acc)
			end
		end
	end

	return acc
end

local function descendants(bags, target)
	local acc = 0
	for child, number in pairs(bags[target]) do
		acc = acc + number + descendants(bags, child) * number
	end
	return acc
end

local target = table.concat({...}, " ")

print(#parents(bags, target))
print(descendants(bags, target))
