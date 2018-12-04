import sys
# "module advent10c not found"
# yeah okay buddy. this fixes that
# if you're running this code it won't work without tweaking this
sys.path.append("C:\\code\\advent")
# we need this for the hash_str method from day 10
from advent10c import *

# input data
inp = "jzgqcdpd"
# sample data
#inp = "flqrgnkx"

hashes = []

for i in range(128):

	hx = ''.join(hash_str(inp + '-' + str(i)))
	hashes.append(str(bin(int(hx, 16))[2:].zfill(8)).zfill(128))
sq = 0

# i know there's some mathy solution to all this but my brain is too dumb, so this is what we've got. more recursion.
def convert_neighbors(line, index):
	# replace self with '0' to prevent backtracking
	hashes[line] = hashes[line][:index] + '0' + hashes[line][index + 1:]
	
	# check adjacent neighbors
	if line > 0:
		if hashes[line - 1][index] == '1':
			convert_neighbors(line - 1, index)
	if line < len(hashes) - 1:
		if hashes[line + 1][index] == '1':
			convert_neighbors(line + 1, index)
	if index > 0:
		if hashes[line][index - 1] == '1':
			convert_neighbors(line, index - 1)
	if index < len(hashes[line]) - 1:
		if hashes[line][index + 1] == '1':
			convert_neighbors(line, index + 1)

# calculate part 1 very inelegantly
for hsh in hashes:
	for bit in hsh:
		if int(bit) == 1:
			sq += 1

# part 2
# calculate adjacent groups
groups = 0

# calculate part 2 in a 'just okay' way
for ln in range(len(hashes)):
	for i in range(len(hashes[ln])):
		if hashes[ln][i] == '1':
			groups += 1
			convert_neighbors(ln, i)
	
# i don't like calling them squares but i can't think of anything better
print("Squares (part 1): {}".format(sq))
print("Groups (part 2):  {}".format(groups))