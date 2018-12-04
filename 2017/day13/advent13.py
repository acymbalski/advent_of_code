import copy

origLayerInfo = {}
layerInfo = {}

with open("input13.txt") as f:
	lines = f.readlines()
	#lines = ["0: 3", "1: 2", "4: 4", "6: 4"]
	for i in range(int(lines[len(lines) - 1].split(':')[0])):
		layerInfo[i] = {"range": 0, "scanner": 0, "ds": 0}

	for line in lines:
		#print(line.strip().split(": "))
		#layerInfo.append(line.strip().split(": ") + [0])
		layer = line.strip().split(": ")
		layerInfo[int(layer[0])] = {"range": int(layer[1]), "scanner": 0, "ds": 1}

#print(layerInfo.keys())
#for key in layerInfo.keys():
#	print("{}: {}".format(key, layerInfo[key]))
		
# depth travelled
depth = -1
# severity sum
sev_sum = 0

origLayerInfo = copy.deepcopy(layerInfo)

while depth < len(layerInfo.keys()) - 1:
	# move
	depth += 1
	
	# caught?
	if layerInfo[depth]["scanner"] == 0 and layerInfo[depth]["range"] > 0:
		sev_sum += layerInfo[depth]["range"] * depth
		print("Caught: {}: {} = {}".format(depth, layerInfo[depth], layerInfo[depth]["range"] * depth))
		
	# move scanners
	for i in range(len(layerInfo.keys())):
		#if layerInfo[i]["scanner"] >= layerInfo[i]["range"]:
		#	layerInfo[i]["ds"] = -1
		if layerInfo[i]["scanner"] + layerInfo[i]["ds"] < 0 or layerInfo[i]["scanner"] + layerInfo[i]["ds"] >= layerInfo[i]["range"]:
			layerInfo[i]["ds"] *= -1
		layerInfo[i]["scanner"] += layerInfo[i]["ds"]
		#print("{}: {}".format(i, layerInfo[i]["scanner"]))

		

delay = 0
caught = True
caughtAt = []


while caught:

	#print(">")
	delayedLayerInfo = copy.deepcopy(origLayerInfo)
	
	# delay-move scanners
	for i in range(delay):
		#print('.', end='')
		for i in range(len(delayedLayerInfo.keys())):
			if delayedLayerInfo[i]["scanner"] + delayedLayerInfo[i]["ds"] < 0 or delayedLayerInfo[i]["scanner"] + delayedLayerInfo[i]["ds"] >= delayedLayerInfo[i]["range"]:
				delayedLayerInfo[i]["ds"] *= -1
			delayedLayerInfo[i]["scanner"] += delayedLayerInfo[i]["ds"]
		#if delayedLayerInfo[i]["scanner"] >= delayedLayerInfo[i]["range"]:
		#	delayedLayerInfo[i]["ds"] = -1
		#if delayedLayerInfo[i]["scanner"] + delayedLayerInfo[i]["ds"] < 0 or delayedLayerInfo[i]["scanner"] + delayedLayerInfo[i]["ds"] >= delayedLayerInfo[i]["range"]:
		#	delayedLayerInfo[i]["ds"] *= -1
		#delayedLayerInfo[i]["scanner"] += delayedLayerInfo[i]["ds"]
	#print()
	# now try to move
	#print("Size: {}".format(len(delayedLayerInfo.keys()) - 1))
	depth = -1
	while depth < len(delayedLayerInfo.keys()) - 1:
	
		#print("Depthy: {}".format(depth))
		# move
		depth += 1
		
		# caught? if caught, we can just move on
		if delayedLayerInfo[depth]["scanner"] == 0 and delayedLayerInfo[depth]["range"] > 0:
			#sev_sum += delayedLayerInfo[depth]["range"] * depth
			#print("Caught: {}: {} = {}".format(depth, delayedLayerInfo[depth], delayedLayerInfo[depth]["range"] * depth))
			#print("Caught at {}. Break.".format(depth))
			if depth not in caughtAt:
				caughtAt.append(depth)
				print("New progress: Caught at {}".format(depth))
			break
			
		# move scanners
		#print("Move scanners...")
		for i in range(len(delayedLayerInfo.keys()) - 1):
			#print("i: {}".format(i))
			if delayedLayerInfo[i]["scanner"] + delayedLayerInfo[i]["ds"] < 0 or delayedLayerInfo[i]["scanner"] + delayedLayerInfo[i]["ds"] >= delayedLayerInfo[i]["range"]:
				delayedLayerInfo[i]["ds"] *= -1
			delayedLayerInfo[i]["scanner"] += delayedLayerInfo[i]["ds"]
			
	if delayedLayerInfo[depth]["scanner"] == 0 and delayedLayerInfo[depth]["range"] > 0:
		delay += 1
		#print(delay)
		if delay % 100 == 0:
			print("delay: {}".format(delay))
	# if made it to the end...
	elif depth == len(delayedLayerInfo.keys()) - 1:
		#print("Not caught!")
		caught = False
	# otherwise, delay and try again
	else:
		#print("Delaying...")
		delay += 1
		#print(delay)
		if delay % 100 == 0:
			print("delay: {}".format(delay))


print()
print("Total severity:    {}".format(sev_sum))
print("Delay for success: {}".format(delay))