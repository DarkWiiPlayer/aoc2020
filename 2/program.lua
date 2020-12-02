local fun = require 'fun' ()

local function old_check(entry)
	local min, max, letter, password = entry:match("(%d+)-(%d+) (.): (.*)")
	local number = #password:gsub("[^"..letter.."]", "")
	return tonumber(min) <= number and number <= tonumber(max)
end

local function new_check(entry)
	local a, b, letter, password = entry:match("(%d+)-(%d+) (.): (.*)")
	a, b = password:sub(a, a), password:sub(b, b)
	return (a==letter) and (b~=letter) or (b==letter) and (a~=letter)
end

local result =
tabulate(io.lines())
: take(operator.truth)
: filter(new_check)
: reduce(function(a, b) return a+1 end, 0)

print(result)
