
dt = []
sm = 0
sm_alt = 0

with open("input4.txt") as f:
	for line in f.readlines():
		dt.append(line.strip('\n'))

for line in dt:
	line_prog = ""
	valid = True
	for word in line.split():
		if word in line_prog:
			valid = False
			break
		else:
			line_prog += " " + word
	if valid:
		sm += 1
		
# it would be fastest(?) to rearrange every word in alpha order and just check
# using the above algorithm, i think

dt_alph = []
for line in dt:
	line_alph = ""
	for word in line.split():
		#print("Old word: {}".format(word))
		#print("New word: {}\n".format(''.join(sorted(list(word), key=str.lower))))
		line_alph += (''.join(sorted(list(word), key=str.lower)) + " ")
	dt_alph.append(' '.join(sorted(line_alph.split(), key=str.lower)))

print()

#print(dt_alph)

for line in dt_alph:
	line_prog = ""
	valid = True
	#print(line.split())
	for word in line.split():
		if word in line_prog.split():
			valid = False
			print("I: {}".format(line))
			print("    - {}".format("\"{}\"".format(word)))
			break
		else:
			line_prog += " " + word
	if valid:
		sm_alt += 1
		print("V: {}".format(line))

print()
print("Sum (std): {}/{} valid passwords".format(sm, len(dt)))
print("Sum (alt): {}/{} valid anagrammatic passwords".format(sm_alt, len(dt_alph)))

