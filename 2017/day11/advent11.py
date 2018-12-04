import copy

dt = {"nw": 0, "n": 0, "ne": 0, "se": 0, "s": 0, "sw": 0}
max_dist = 0

def get_distance(dit):
	dct = copy.deepcopy(dit)
	# every se + sw = s
	# every s + nw = sw
	# etc etc

	# or better yet, 1n + 1s = 0
	# so...
	min_val = min(dct["n"], dct["s"])
	dct["n"] -= min_val
	dct["s"] -= min_val

	min_val = min(dct["nw"], dct["se"])
	dct["nw"] -= min_val
	dct["se"] -= min_val


	min_val = min(dct["ne"], dct["sw"])
	dct["ne"] -= min_val
	dct["sw"] -= min_val

	# also, you can still cancel things like 'n' and 'sw' to become 'nw'
	# there has to be a better way
	# kyle forgive me for hardcoding
	while (min(dct["n"], dct["sw"]) > 0) or (min(dct["n"], dct["se"]) > 0) or (min(dct["sw"], dct["se"]) > 0) or (min(dct["nw"], dct["ne"]) > 0) or (min(dct["ne"], dct["s"]) > 0) or (min(dct["nw"], dct["s"]) > 0):
		min_val = min(dct["n"], dct["sw"])
		dct["n"] -= min_val
		dct["sw"] -= min_val
		dct["nw"] += min_val


		min_val = min(dct["n"], dct["se"])
		dct["n"] -= min_val
		dct["se"] -= min_val
		dct["ne"] += min_val


		min_val = min(dct["sw"], dct["se"])
		dct["sw"] -= min_val
		dct["se"] -= min_val
		dct["s"] += min_val
		
		
		min_val = min(dct["nw"], dct["ne"])
		dct["nw"] -= min_val
		dct["ne"] -= min_val
		dct["n"] += min_val
		
		
		min_val = min(dct["ne"], dct["s"])
		dct["ne"] -= min_val
		dct["s"] -= min_val
		dct["se"] += min_val
		
		
		min_val = min(dct["nw"], dct["s"])
		dct["nw"] -= min_val
		dct["s"] -= min_val
		dct["sw"] += min_val
	
	
	sum_steps = 0
	for key in dct.keys():
		sum_steps += dct[key]
		
	
	return sum_steps

with open("input11.txt") as f:
	for line in f.readlines():
		for itm in line.split(','):
			dt[itm.strip()] += 1
			cur_dist = get_distance(dt)
			if cur_dist > max_dist:
				max_dist = cur_dist

	
print()
print("Sum of steps: {}".format(get_distance(dt)))
print("Maximum distance: {}".format(max_dist))
	