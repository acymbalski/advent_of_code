import time
import copy


commands = []
p = []
for i in range(ord('a'), ord('p') + 1):
	p.append(chr(i))

with open("input16.txt") as f:
	for line in f.readlines():
		commands = line.strip().split(",")
		
def dance(progs):
	for cmd in commands:
		chr = cmd[0]
		if chr == 's':
			pl = len(progs)
			cut = pl - int(cmd[1:])
			progs = progs[cut:] + progs[:cut]
		else:
			cmds = cmd[1:].split('/')
			n1, n2 = cmds[0], cmds[1]
			if chr == 'x':
				n1 = int(n1)
				n2 = int(n2)
				temp = progs[n1]
				progs[n1] = progs[n2]
				progs[n2] = temp
			elif chr == 'p':
				ind1 = progs.index(n1)
				ind2 = progs.index(n2)
				temp = progs[ind1]
				progs[ind1] = progs[ind2]
				progs[ind2] = temp
	return progs
	
dance(p)
print("Final order: {}".format(''.join(dance(p))))

initial_start = time.process_time()
start = initial_start
# I found that the pattern repeats itself every 42 iterations
# so we only need to run it 1b%42 times to get the right answer
for i in range(1000000000 % 42):

	p = dance(p)

	if i % 1000 == 0:
		end = time.process_time()
		print("Calculating... (@{:,})".format(i))
		print("\tCurrent string: {}".format(''.join(p)))
		print("\tPercent calculated: {}%".format(round((i)/1000000000, 3)))
		print("\tCalculation time:   {}s".format(end - start))
		print("\tTotal time:         {}s".format(end - initial_start))
		if i > 0:
			print("\tEstimated rem.:     {}s".format((end - initial_start) / ((i)/1000000000)))
		print()
		start = end
	
print("Final order (part 2): {}".format(''.join(p)))


	