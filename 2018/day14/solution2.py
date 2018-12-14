
search_str = "513401"

start_config = "37"

# may add additional helpers here, just set their starting index
helpers = [0, 1]

prev_size = len(start_config)

# track generations for fun
# (also to reassure the viewer that this is actually running)
gen = 0
while True:
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
        
    # does our search_str appear? we can track the old size for MAX SPEED
    if search_str in start_config[prev_size - len(search_str):]:
        print("Value " + search_str + " found at index: " + str(start_config.find(search_str)) + " after " + str(gen) + " generations.")
        break
        
    prev_size = len(start_config)
    gen += 1
    if gen % 1000000 == 0:
        print("Gen " + str(gen) + " complete.")
