# ugly but functional
# a rewrite would look nothing like this


lens = []
seq = []
inp = []

cur_ind = 0
skip = 0

with open("input10.txt") as f:
	for line in f.readlines():
		inp = line.strip()
		for itm in line.strip().split(","):
			lens.append(int(itm))

seq = list(range(256))

def sparse_hash(sequence, lengths, cur_ind=0, skip=0):
	
	for itm in lengths:
		if itm == 0:
			pass
			
		elif cur_ind + itm > 256:
			end_len = 256 - cur_ind
			start_len = itm - end_len
			
			sub_sequence = list(reversed(sequence[cur_ind:] + sequence[:start_len]))
			
			sequence = sub_sequence[end_len:] + sequence[start_len:cur_ind] + sub_sequence[:end_len]
		else:
			sub_sequence = sequence[cur_ind:cur_ind + itm]
		
			sequence = sequence[:cur_ind] + list(reversed(sub_sequence)) + sequence[cur_ind + itm:]
		
		cur_ind += itm + skip
		skip += 1
		
		cur_ind %= 256
	return sequence, cur_ind, skip
seq, cur_ind, skip = sparse_hash(seq, lens)

print("First two numbers, multiplied: {} x {} = {}".format(seq[0], seq[1], seq[0] * seq[1]))

# part 2
print()


inp = "flqrgnkx-0"

# convert input to list of ints
lens = list(int(ord(x)) for x in inp)

# append standard suffix values
lens += [17, 31, 73, 47, 23]

# re-init
seq = list(range(256))

# re-init, preserve between rounds
skip = 0
cur_ind = 0

# sparse_hash 64 times
for n in range(64):
	seq, cur_ind, skip = sparse_hash(seq, lens, cur_ind, skip)

# bitwise xor to get 16 numbers
bitted = []
cur_num = 0
for i in range(len(seq)):
	if i % 16 == 0:
		cur_num = seq[i]
	else:
		cur_num = cur_num ^ seq[i]
		if i % 16 == 15:
			bitted.append(cur_num)

# hex
bitted = [str(hex(x))[2:].zfill(2) for x in bitted]

# make string
print("Hashed string from \"{}\": \"{}\"".format(inp, "".join(bitted)))
