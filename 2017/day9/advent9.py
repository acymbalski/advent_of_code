
depth = 0
ignore = False
garbage = False

# increment sum on closing brackets
sm = 0
num_garbage = 0

stream = ""

with open("input9.txt") as f:
	stream = f.readlines()[0].strip()

for char in stream:
	# ignore and un-set ignore
	if ignore:
		ignore = False
	# close garbage if garbage
	elif char == '>' and garbage:
		garbage = False
	# set ignore
	elif char == '!':
		ignore = True
	# ignore garbage
	elif garbage:
		num_garbage += 1
	# open garbage
	elif char == '<':
		garbage = True
	# open group
	elif char == '{':
		depth += 1
	# close group
	elif char == '}':
		sm += depth
		depth -= 1
	
# hmmm... possible to make a big branching dict or tree?

print("Score: {}".format(sm))
print("{} garbage characters".format(num_garbage))