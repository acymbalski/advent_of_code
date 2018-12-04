
dt = []
dt_alt = []
index = 0
count = 0
count_alt = 0

with open("input5.txt") as f:
	for line in f.readlines():
		dt.append(int(line.strip("\n")))
		dt_alt.append(int(line.strip("\n")))
		
while 0 <= index < len(dt):
	#print("Index {}: {}".format(index, dt[index]))
	to_jump = dt[index]
	dt[index] += 1
	#print("dt[{}] incremented by 1 to become: {}".format(index, dt[index]))
	index += to_jump
	count += 1
	#print("Count: {}".format(count))
	
	
index = 0
while 0 <= index < len(dt_alt):
	#print("Index {}: {}".format(index, dt[index]))
	to_jump = dt_alt[index]
	if dt_alt[index] >= 3:
		dt_alt[index] -= 1
	else:
		dt_alt[index] += 1
	#print("dt[{}] incremented by 1 to become: {}".format(index, dt[index]))
	index += to_jump
	count_alt += 1
	#print("Count: {}".format(count))

#for line in dt:
#	print(line)

print("Exited in {} jumps".format(count))
print("Exited (alt) in {} jumps".format(count_alt))