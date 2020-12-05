local fun = require 'fun'

local function id(str)
	return tonumber(str:lower():gsub(".", {f="0", b="1", r="1", l="0"}), 2)
end

local seats = fun.tabulate(io.lines())
: take(fun.operator.truth)
: map(id)
: totable()

table.sort(seats)

print("Highest seat:", seats[#seats])

local function border(last, element)
	if element == last+1 then
		return element
	else
		return last
	end
end

local result =
fun.iter(seats)
: reduce(border, seats[1]-1)

print("Your seat:", result+1)
