freq = 0

with open("input.txt") as f:
    for line in f.readlines():
        #print(line.strip())
        freq += int(line.strip().replace('+', ''))
print("Final frequency: {}".format(freq))