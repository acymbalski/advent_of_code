
# length of string until we have to stop and search
len_after = 513401

# length to search for
len_len = 10

# starting configuration
start_config = "37"

# may add additional helpers here, just set their starting index
helpers = [0, 1]

# track generations for fun
# (also to reassure the viewer that this is actually running)
gen = 0
while len(start_config) < (len_after + len_len):
    # sum two numbers
    sum = 0
    for helper in helpers:
        sum += int(start_config[helper])
        
    # break into digits
    # append to list
    start_config = start_config + str(sum)
    
    # select new index
    for helper in range(len(helpers)):
        helpers[helper] += (int(start_config[helpers[helper]]) + 1)
        helpers[helper] = helpers[helper] % len(start_config)
    
    gen += 1
    if gen % 100000 == 0:
        print("Gen " + str(gen) + " complete.")

print("final " + str(len_len) + ": " + start_config[len_after: len_after + len_len])
