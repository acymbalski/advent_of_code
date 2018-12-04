dt = {}
dt_l = []

with open("input7.txt") as f:
	for line in f.readlines():
		nl = line.split(" -> ")
		
		# save layer name
		layer = nl[0].split()[0].strip("\n,")
		# save layer weight (for later, presumably)
		weight = int(nl[0].split()[1].strip("\n,()"))
		# save layer toppers
		toppers = []
		if len(nl) > 1:
			tops = nl[1].split()
			for itm in tops:
				toppers.append(itm.strip("\n,"))
		
		dt[layer] = {"weight": weight, "tops": toppers}
		#print(line.split(" -> "))
		
#for key in dt.keys():
#	print("{} : {}".format(key, dt[key]))
		
dt_l = list(dt.keys())
#print(dt_l)

nl = []
class node:
	parent = ""
	name = ""
	children_l = []
	children = []
	weight = 0
	weight_sm = 0
	checked = False
	
	def __init__(self, n):
		self.name = n
		
	
	def __init__(self, n, c, w):
		self.parent = ""
		self.name = n
		self.children_l = c
		self.children = []
		self.weight = w
		self.weight_sm = w
		self.checked = False
	
	
# make nodes
for key in dt.keys():
	nl.append(node(key, dt[key]["tops"], dt[key]["weight"]))

# populate children
for n in nl:
	#print("> > {}".format(n.name))
	for c in n.children_l:
		for m in nl:
			#print("if m.name ({}) == {}".format(m.name, c))
			if m.name == c:
				n.children.append(m)
				m.parent = n
				#print("Appending {} to the list.\nNow: {}".format(m.name, n.children))
				break
			#for c in n.children:
			#	print("   {}".format(c.name))

root = ""
for n in nl:
	if n.parent == "":
		print("ROOT NODE: {}".format(n.name))
		root = n

def sm_weights(n):
	if len(n.children) > 0:
		for c in n.children:
			#print("{}: {} ({})".format(n.name, c.name, c.weight_sm))
			n.weight_sm += sm_weights(c)
	return n.weight_sm

sm_weights(root)

wgt = 0
for n in nl:
	if len(n.children) > 0:
		cur_wgt = -1
		p_children = False
		for c in n.children:
			if cur_wgt == -1:
				cur_wgt = c.weight_sm
			elif cur_wgt != c.weight_sm:
				p_children = True
		if p_children:
			print("Parent \"{}\" has wrongly weighted children:".format(n.name))
			for c in n.children:
				print("    {} ({}): {}".format(c.name, c.weight, c.weight_sm))

#for n in nl:
#	print("{}: {}".format(n.name, n.weight))
#	print("    P: {}".format(n.parent))
#	if len(n.children) > 0:
#		for c in n.children:
#			print("   {}".format(c.name))