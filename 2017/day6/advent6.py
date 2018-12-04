from copy import deepcopy

dt = []
dt_alt = []
index = 0
rem = 0
patterns = []
count = 0
count_alt = 0

with open("input6.txt") as f:
	for itm in f.readlines()[0].split("\t"):
		dt.append(int(itm.strip("\n")))
		

while dt not in patterns:
	patterns.append(deepcopy(dt))
	index = dt.index(max(dt))
	rem = dt[index]
	dt[index] = 0
	index += 1
	count += 1
	while rem > 0:
		if index >= len(dt):
			index = 0
		dt[index] += 1
		rem -= 1
		index += 1
		
patterns = []
dt_alt = deepcopy(dt)

while dt_alt not in patterns:
	patterns.append(deepcopy(dt_alt))
	index = dt_alt.index(max(dt_alt))
	rem = dt_alt[index]
	dt_alt[index] = 0
	index += 1
	count_alt += 1
	while rem > 0:
		if index >= len(dt_alt):
			index = 0
		dt_alt[index] += 1
		rem -= 1
		index += 1

	
print("Step count (std): {}".format(count))
print("Step count (alt): {}".format(count_alt))