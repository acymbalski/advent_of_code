
with open("input.txt") as f:
    all_lines = f.readlines()
    
# returns the number of differing characters
def compare_str(str1, str2):
    num_diff = 0

    for i in range(len(str1)):
        if str1[i] != str2[i]:
            num_diff += 1
    
    return num_diff

# returns str1 with mismatched characters to str2 omitted
def get_common(str1, str2):
    ret = ""
    for i in range(len(str1)):
        if str1[i] == str2[i]:
            ret += str1[i]
    return ret

for line1 in all_lines:
    for line2 in all_lines:
        if compare_str(line1, line2) == 1:
            print("Match found")
            print("Str 1:  {}".format(line1))
            print("Str 2:  {}".format(line2))
            print("Common: {}".format(get_common(line1, line2)))
            
            exit()
