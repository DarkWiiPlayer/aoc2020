local function decode(line)
	local op, arg = line:match("^([a-z]+)%s+([-+]?%d+)$")
	arg = tonumber(arg)
	return op, arg
end

local function run(program, ip, acc)
	ip = ip or 1
	acc = acc or 0
	local length = #program
	local visited = {}
	while 1 <= ip and ip <= length do
		if visited[ip] then
			return ip, acc
		else
			visited[ip] = true
		end
		local op, arg = program[ip][1], program[ip][2]
		if op == "jmp" then
			ip = ip + arg - 1
		elseif op == "acc" then
			acc = acc + arg
		end
		ip = ip + 1
	end
	return ip, acc
end

local program = {}
for line in io.lines() do
	table.insert(program, {decode(line)})
end

local function flip(program, ip)
	if program[ip][1] == "jmp" then
		program[ip][1] = "nop"
	elseif program[ip][1] == "nop" then
		program[ip][1] = "jmp"
	end
end

local function fix(program)
	for i, instruction in ipairs(program) do
		flip(program, i)
		local ip, acc = run(program)
		flip(program, i)
		if ip > #program then
			return ip, acc
		end
	end
	error("Program cannot be fixed!", 2)
end

print(fix(program))
