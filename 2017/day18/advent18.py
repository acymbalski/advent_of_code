
commands = []
reg = {}
lastPlayed = -1
recovered = -1

for c in range(ord('a'), ord('z') + 1):
	reg[chr(c)] = 0
	#print(c)
	#print(chr(c))

with open("input18.txt") as f:
	for line in f.readlines():
		commands.append(line.strip().split())
	
index = 0
while True:#for i in range(len(commands)):#cmd in commands:
	cmd = commands[index]
	#print(cmd)
	
	if cmd[1] in reg.keys():
		check = reg[cmd[1]]
	else:
		check = int(cmd[1])
	
	if len(cmd) == 3:
		if cmd[2] in reg.keys():
			val = reg[cmd[2]]
		else:
			val = int(cmd[2])
	
	if cmd[0] == "set":
		reg[cmd[1]] = val
	elif cmd[0] == "snd":
		#print("Playing sound in '{}' ({})".format(cmd[1], reg[cmd[1]]))
		lastPlayed = reg[cmd[1]]
	elif cmd[0] == "mul":
		reg[cmd[1]] *= val
	elif cmd[0] == "add":
		reg[cmd[1]] += val
	elif cmd[0] == "mod":
		reg[cmd[1]] %= val
	elif cmd[0] == "rcv":
		if check != 0:
			print("Recovered sound freq. {}".format(lastPlayed))
			recovered = lastPlayed
			break
	elif cmd[0] == "jgz":
		if check > 0:
			index += val - 1

	index += 1
		
	
print("Last Recovered: {}".format(recovered))



index = [0, 0]
q = [[], []]
reg = [{}, {}]
p1valsend = 0

for c in range(ord('a'), ord('z') + 1):
	reg[0][chr(c)] = 0
	reg[1][chr(c)] = 0

reg[0]['p'] = 0
reg[1]['p'] = 1

running = [True, True]

def preg(p):
	for k in ['a', 'b', 'i', 'p', 'f']:
		print("({}){}: {}".format(p, k, reg[p][k]))
	print()

while False:#True:#for i in range(len(commands)):#cmd in commands:
	#print(">>", index)
	if index[0] >= len(commands) and running[0]:
		print("Program 0 is dead.")
		running[0] = False
	# since we really only care about program 1's executions...
	if index[1] >= len(commands):
		print("index[1] = {}, len(commands) = {}".format(index[1], len(commands)))
		break
	cmd = [commands[index[0]] if index[0] < len(commands) else ["", "", ""], commands[index[1]]]
	#if index[0] != index[1]:
	#	print("Desync")
	#print(cmd)
	#print(reg)
	
	if cmd[0][0] == "rcv" and cmd[1][0] == "rcv" and len(q[0]) == 0 and len(q[1]) == 0:
		print("Deadlock.")
		break
		
	check = [-1, -1]
	val = [-1, -1]
	
	for p in [0, 1]:
		p = int(p)
		if running[p]:
			if cmd[p][1] in reg[p].keys():
				#print(cmd[p][1])
				#print(reg[0]['a'])
				check[p] = reg[p][cmd[p][1]]
			else:
				check[p] = int(cmd[p][1])
			
			if len(cmd[p]) == 3:
				if cmd[p][2] in reg[p].keys():
					val[p] = reg[p][cmd[p][2]]
				else:
					val[p] = int(cmd[p][2])
				
			#print(">>>", cmd[p])
				#if p == 0:
					#print(cmd[p][2], val[p])
		
			#if cmd[p][1] == 'b':
				#if len(cmd[p]) > 2:
					#print("b: {}".format(cmd[p][2]))
			
			if cmd[p][0] == "set":
				#if p == 0:
					#print("{}: {} =?> {}".format(cmd[p][1], reg[p][cmd[p][1]], val[p]))
				reg[p][cmd[p][1]] = val[p]
			elif cmd[p][0] == "snd":
				#print("Playing sound in '{}' ({})".format(cmd[p][1], reg[p][cmd[p][1]]))
				#lastPlayed = reg[p][cmd[p][1]]
				q[0 if p else 1].append(val[p])
				if p == 1:
					p1valsend += 1
				#else:
				#print(reg[p])
				#print(reg[0 if p else 1])
				#print("Sending {}".format(cmd[p][1]))
			elif cmd[p][0] == "mul":
				reg[p][cmd[p][1]] *= val[p]
				
			elif cmd[p][0] == "add":
				#if p == 0:
				#	print("{}: {} +?> {}".format(cmd[p][1], reg[p][cmd[p][1]], val[p]))
				reg[p][cmd[p][1]] += val[p]
				
			elif cmd[p][0] == "mod":
				#if p == 0:
				#	print("{}: {} %?> {}".format(cmd[p][1], reg[p][cmd[p][1]], val[p]))
				reg[p][cmd[p][1]] %= val[p]
			elif cmd[p][0] == "rcv":
				if len(q[p]) == 0:
					index[p] -= 1
				else:
					reg[p][cmd[p][1]] = q[p][0]
					#print(q[p])
					q[p] = q[p][1:]
					#print(q[p])
			elif cmd[p][0] == "jgz":
				#print(p)
				#print(check)
				#print(check[p])
				if check[p] > 0:
					index[p] += val[p] - 1
					

			
			#preg(p)
			index[p] += 1
			print(p, index, cmd)
	
	
			#if cmd[p][1] == 'b':
			#	if len(cmd[p]) > 2:
			#		print("b: {}: b={}".format(cmd[p][2], reg[p]['b']))

p = 0
while True:#for i in range(len(commands)):#cmd in commands:
	#print(">>", index)
	if index[0] >= len(commands) and running[0]:
		print("Program 0 is dead.")
		running[0] = False
	# since we really only care about program 1's executions...
	if index[1] >= len(commands):
		#print("index[1] = {}, len(commands) = {}".format(index[1], len(commands)))
		break
	cmd = [commands[index[0]] if index[0] < len(commands) else ["", "", ""], commands[index[1]]]
	#if index[0] != index[1]:
	#	print("Desync")
	#print(cmd)
	#print(reg)
	
	if cmd[0][0] == "rcv" and cmd[1][0] == "rcv" and len(q[0]) == 0 and len(q[1]) == 0:
		print("Deadlock.")
		break
		
	check = [-1, -1]
	val = [-1, -1]
	
	p = int(p)
	if running[p]:
		if cmd[p][1] in reg[p].keys():
			#print(cmd[p][1])
			#print(reg[0]['a'])
			check[p] = reg[p][cmd[p][1]]
		else:
			check[p] = int(cmd[p][1])
		
		if len(cmd[p]) == 3:
			if cmd[p][2] in reg[p].keys():
				val[p] = reg[p][cmd[p][2]]
			else:
				val[p] = int(cmd[p][2])
			
		#print(">>>", cmd[p])
			#if p == 0:
				#print(cmd[p][2], val[p])
	
		#if cmd[p][1] == 'b':
			#if len(cmd[p]) > 2:
				#print("b: {}".format(cmd[p][2]))
		
		if cmd[p][0] == "set":
			#if p == 0:
				#print("{}: {} =?> {}".format(cmd[p][1], reg[p][cmd[p][1]], val[p]))
			reg[p][cmd[p][1]] = val[p]
		elif cmd[p][0] == "snd":
			#print("Playing sound in '{}' ({})".format(cmd[p][1], reg[p][cmd[p][1]]))
			#lastPlayed = reg[p][cmd[p][1]]
			q[0 if p else 1].append(val[p])
			if p == 1:
				p1valsend += 1
			#else:
			#print(reg[p])
			#print(reg[0 if p else 1])
			#print("Sending {}".format(cmd[p][1]))
		elif cmd[p][0] == "mul":
			reg[p][cmd[p][1]] *= val[p]
			
		elif cmd[p][0] == "add":
			#if p == 0:
			#	print("{}: {} +?> {}".format(cmd[p][1], reg[p][cmd[p][1]], val[p]))
			reg[p][cmd[p][1]] += val[p]
			
		elif cmd[p][0] == "mod":
			#if p == 0:
			#	print("{}: {} %?> {}".format(cmd[p][1], reg[p][cmd[p][1]], val[p]))
			reg[p][cmd[p][1]] %= val[p]
		elif cmd[p][0] == "rcv":
			if len(q[p]) == 0:
				#index[p] -= 1
				
				print(p, index, cmd)
				p = 0 if p else 1
				
				continue
			else:
				reg[p][cmd[p][1]] = q[p][0]
				#print(q[p])
				q[p] = q[p][1:]
				#print(q[p])
		elif cmd[p][0] == "jgz":
			#print(p)
			#print(check)
			#print(check[p])
			if check[p] > 0:
				index[p] += val[p] - 1
				

		
		#preg(p)
		index[p] += 1
		print(p, index, cmd)
			
			
# i think the correct answer is 7493 but i'm not a cheater so I can't enter it until I get it myself
print("Program 1 sent a value {} times".format(p1valsend))