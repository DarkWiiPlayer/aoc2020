local function trees(read, dx, dy)
	local tree = string.byte("#")
	local counter = 0
	local i = 0
	for line in read do
		if i % dy == 0 then
			local pos = (dx*(i/dy))%#line+1
			if line:byte(pos,pos) == tree then
				counter = counter + 1
			end
		end
		i = i + 1
	end
	return counter
end

local dx, dy = ...
dx, dy = tostring(dx), tostring(dy)

print(trees(io.lines(), dx, dy))
