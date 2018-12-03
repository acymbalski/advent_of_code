
with open("input.txt") as f:
    all_lines = f.readlines()
    
    
num_twos = 0
num_threes = 0

for line in all_lines:
    # use these so we don't double-count letters
    contains_two = False
    contains_three = False
    
    for character in line:
        if line.count(character) == 2:
            contains_two = True
        elif line.count(character) == 3:
            contains_three = True
    
    if contains_two:
        num_twos += 1
    if contains_three:
        num_threes += 1
        
print("Num twos:   {}".format(num_twos))
print("Num threes: {}".format(num_threes))
print("checksum:   {}".format(num_twos * num_threes))
