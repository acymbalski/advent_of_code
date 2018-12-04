
reg = {}
instr = []

with open("input8.txt") as f:
	for line in f.readlines():
		line = line.split()
		reg_name = line[0]
		if line[1] == "inc":
			sign = 1
		else:
			sign = -1
		#sign = line[1] == "inc" ? 1 : -1
		amt = int(line[2])
		check_reg = line[4]
		condition = line[5]
		check_amt = int(line[6].strip("\n"))
		reg[reg_name] = 0
		
		instr.append({"name": reg_name,"sign": sign, "amt": amt, "check_reg": check_reg, "condition": condition, "check_amt": check_amt})
	
#print(instr)

mx_all = -999
mx_all_reg = ""

for itm in instr:
	perform_op = False
	if itm["condition"] == ">":
		if reg[itm["check_reg"]] > itm["check_amt"]:
			perform_op = True
	elif itm["condition"] == "<":
		if reg[itm["check_reg"]] < itm["check_amt"]:
			perform_op = True
	elif itm["condition"] == ">=":
		if reg[itm["check_reg"]] >= itm["check_amt"]:
			perform_op = True
	elif itm["condition"] == "<=":
		if reg[itm["check_reg"]] <= itm["check_amt"]:
			perform_op = True
	elif itm["condition"] == "==":
		if reg[itm["check_reg"]] == itm["check_amt"]:
			perform_op = True
	elif itm["condition"] == "!=":
		if reg[itm["check_reg"]] != itm["check_amt"]:
			perform_op = True
	else:
		print("Error: {}".format(itm["condition"]))
	
	if perform_op:
		reg[itm["name"]] += itm["sign"] * itm["amt"]
		if reg[itm["name"]] > mx_all:
			mx_all = reg[itm["name"]]
			mx_all_reg = itm["name"]
		
mx = -999
mx_reg = ""

for key in reg.keys():
	if reg[key] > mx:
		mx = reg[key]
		mx_reg = key
		
print("Largest register: {} with {}".format(mx_reg, mx))
print("Largest register at any given point: {} with {}".format(mx_all_reg, mx_all))