import copy
import uuid

dt = {}
valids = []
sm = 0

# parse input
with open("input12.txt") as f:
	for line in f.readlines():
		nl = line.translate(str.maketrans("", "", "<->\n,")).split()
		for itm in range(len(nl)):
			if itm == 0:
				dt[nl[0]] = {"name": nl[0], "groupID": 0, "connects": []}
			else:
				dt[nl[0]]["connects"].append(nl[itm])
	
# yeah, that's right
# it took me three attempts to write this function
def set_friends3(node):
	# if not part of a list, give in an ID
	if node["groupID"] == 0:
		# get unique ID
		node["groupID"] = uuid.uuid4()
	for nn in node["connects"]:
		if dt[nn]["groupID"] == 0:
			dt[nn]["groupID"] = node["groupID"]
			set_friends3(dt[nn])
	
for key in dt.keys():
	set_friends3(dt[key])	
	if dt[key]["groupID"] not in valids:
		valids.append(dt[key]["groupID"])
	
sm = 0
for key in dt.keys():
	if dt[key]["groupID"] == dt["0"]["groupID"]:
		sm += 1
		
print("Number of programs with access to Program 0: {}".format(sm))
print("Number of groups of programs: {}".format(len(valids)))