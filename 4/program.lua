local shapeshift = require 'shapeshift'
local is = shapeshift.is

local function between(a, b)
	return function(value)
		if a <= value and value <= b then
			return value
		else
			return nil, "Number "..tostring(value).." not in range"
		end
	end
end

local valid = shapeshift.table {
	byr = shapeshift.all{
		shapeshift.matches("^%d%d%d%d$");
		shapeshift.tonumber;
		between(1920, 2002);
	};
	iyr = shapeshift.all{
		shapeshift.matches("^%d%d%d%d$");
		shapeshift.tonumber;
		between(2010, 2020);
	};
	eyr = shapeshift.all{
		shapeshift.matches("^%d%d%d%d$");
		shapeshift.tonumber;
		between(2020, 2030);
	};
	hgt = shapeshift.all{
		shapeshift.any{
			shapeshift.matches("%d+in");
			shapeshift.matches("%d+cm");
		};
		function(height)
			local number, unit = height:match("(%d+)([a-z]+)")
			number = tonumber(number)
			if unit == "cm" and 150 <= number and number <= 193 then
				return height
			elseif unit == "in" and 59 <= number and number <= 76 then
				return height
			else
				return nil, "Not a valid height: " .. tostring(height)
			end
		end;
	};
	hcl = shapeshift.matches("#%x%x%x%x%x%x");
	ecl = shapeshift.all {
		shapeshift.is.string;
		shapeshift.oneof{"amb", "blu", "brn", "gry", "grn", "hzl", "oth"};
	};
	pid = shapeshift.matches("^"..string.rep("%d", 9).."$");
	cid = shapeshift.maybe(is.string);
}

local record = {}
local count = 0
local json = require 'cjson'
for line in io.lines() do
	if line == "" then
		local valid, err = valid(record)
		if valid then
			io.stdout:write(json.encode(record), "\n")
		else
			io.stderr:write(err, "\n")
		end
		record = {}
	else
		for key, value in line:gmatch("([a-z]+):([^%s]+)") do
			record[key]=value
		end
	end
end
