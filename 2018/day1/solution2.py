# takes some serious time to iterate through

freq = 0
freq_list = []

with open("input.txt") as f:
    all_lines = f.readlines()

repeat_found = False
while not repeat_found:
    print("Starting iteration...")
    print("len(freq_list) = {}".format(len(freq_list)))
    for line in all_lines:
        freq += int(line.strip().replace('+', ''))
        if freq in freq_list:
            print("Frequency reached twice: {}".format(freq))
            repeat_found = True
            break
        else:
            freq_list.append(freq)
        