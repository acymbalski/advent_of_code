
step = 337
# sample step size 3
#step = 3

buf = [0]
index = 0

# print the entire(!) list to hunt for patterns
def pprint():
	print("({:2d}, {:2d})  ".format(index, len(buf)), end="")
	for n in range(len(buf)):
		print("{:2d} ".format(buf[n]), end="")
			
	print()
		
# this method is good but it's not "50 million" good.
# there has to be a better way...
for n in range(1, 2018):
	index = (index + step) % len(buf)
	buf = buf[:index + 1] + [n] + buf[index + 1:]
	index = (index + 1)

# it takes me longer to print pretty than to solve the original problem. oh well
for n in range(max(index - 3, 0), min(index + 3, len(buf) - 1) + 1):
	if n == index:
		print("({}) >".format(buf[n]), end="")
	else:
		print("{} ".format(buf[n]), end="")
print()

# hmmm... If we look, we can see something will be inserted next to 0 when
# it steps onto zero (duh). So we don't need a list anymore, we only care about the length
# (which we'll track with "ln")
# We'll record whatever is placed next to 0.
# This completes running within a minute or so, fast enough
neighbor = -1
ln = 1
index = 0
for n in range(1, 50000000):
	index = ((index + step) % ln) + 1
	
	# increase buffer length, even though we don't have the buffer anymore
	ln += 1
	# check if something is to be inserted after 0
	if (index + step) % ln == 0:
		neighbor = ln
	
	# print occasionally so we know nothing is frozen/stuck in a loop
	if n % 10000000 == 0:
		print("Current location: {}".format(n))
		
print("Item next to 0: {}".format(neighbor))
		