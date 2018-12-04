dt = []


with open("input2.txt") as f:
	for itm in f.readlines():
		dt.append(itm.replace("\n", "").split('\t'))

#dt = list(map(int, dt))
#dt = [int(i) for i in dt]
sm = 0
sm_alt = 0

for row in dt:
	row = [int(i) for i in row]
	print(row)
	mx = max(row)
	mn = min(row)
	print("Max: {}".format(mx))
	print("Min: {}\n".format(mn))
	sm += int(mx) - int(mn)
#	for itm in row:
#		if 

for row in dt:
	row = [int(i) for i in row]
	print(row)
	for itm in row:
		for itm2 in row:
			if (itm / itm2).is_integer() and (itm / itm2) != 1:
				print("{} / {} = {}\n".format(itm, itm2, itm / itm2))
				sm_alt += (itm / itm2)

print("Sum total (std): {}".format(sm))
print("Sum total (alt): {}".format(sm_alt))
