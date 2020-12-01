local fun = require 'fun' ()

local numbers =
	tabulate(io.lines())
	: take(operator.truth)
	: map(tonumber)
	: totable()

table.sort(numbers)

local function add(a, b, ...)
	if b then
		return add(a+b, ...)
	else
		return a
	end
end

local function prod(a, b, ...)
	if b then
		return prod(a*b, ...)
	else
		return a
	end
end

local function sumprod(list, n, target, ...)
	if select('#', ...) == n-1 then
		for i, last in ipairs(list) do
			if add(last, ...) == target then
				return prod(last, ...)
			end
		end
	else
		for i, current in ipairs(list) do
			local sum = add(current, ...)
			if sum <= target-list[1] then
				local result = sumprod(list, n, target, current, ...)
				if result then
					return result
				end
			end
		end
	end
end

print(sumprod(numbers, tonumber(...), 2020))
