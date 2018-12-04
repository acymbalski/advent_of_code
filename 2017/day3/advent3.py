# spiral grid 527x527
# '1' is in the center, spiraling cc starting going right
# center is loc 264, 264
# we want to know the distance in x and y from 1 of number 277678

wd = 527
hg = 527
goal = 277678

grid = []
grid_alt = []
for x in range(wd):
	grid.append([])
	grid_alt.append([])
	for y in range(hg):
		grid[x].append("")
		grid_alt[x].append("")

x = wd
y = hg


d_x = 1
d_y = 0

cur_x = int(wd / 2)
cur_y = int(hg / 2)

#grid[wd/2][hg/2] = 1

count = 1
while count <= wd * hg:
	#print(count)
	grid[cur_y][cur_x] = count

	if count == goal:
		print("GOAL (std): {}".format((cur_x - int(wd / 2)) + (cur_y - int(hg / 2))))

	count += 1
	cur_x += d_x
	cur_y += d_y
	if count <= wd * hg:
	
		#for row in grid:
		#	print(row)
		#	print()
		# if we're going right, we turn as soon as there's nobody above us
		if d_x == 1:
			if cur_y == 0 or grid[cur_y - 1][cur_x] == "":
				d_x = 0
				d_y = -1
		# if going up, check left
		elif d_y == -1:
			if cur_x == 0 or grid[cur_y][cur_x - 1] == "":
				d_x = -1
				d_y = 0
		# if going left, check below
		elif d_x == -1:
			if cur_y == hg - 1 or grid[cur_y + 1][cur_x] == "":
				d_x = 0
				d_y = 1
		# if going down, check right
		elif d_y == 1:
			if cur_x == wd or grid[cur_y][cur_x + 1] == "":
				d_x = 1
				d_y = 0

def sum_neighbors(y, x):
	ret_sum = 0
	#print("Checking neighbors of ({}, {})".format(y, x))
	for t_d_y in range(-1, 2):
		for t_d_x in range(-1, 2):
			if t_d_y == 0 and t_d_x == 0:
				continue
			else:
				if 0 <= y + t_d_y < hg and 0 <= x + t_d_x < wd:
					#print("d_y = {}, d_x = {}".format(d_y, d_x))
					#print("Checking ({}, {})...".format(y + d_y, x + d_x))
					if grid_alt[y + t_d_y][x + t_d_x] != "":
						#print("({}, {}) = {}".format(y + d_y, x + d_x, grid_alt[y + d_y][x + d_x]))
						ret_sum += grid_alt[y + t_d_y][x + t_d_x]
	if ret_sum == 0:
		ret_sum = 1
	#print("Returning: {}".format(ret_sum))
	return ret_sum

# alt
count = 1
cur_x = int(wd / 2)
cur_y = int(hg / 2)

while count <= goal: #wd * hg:
	#print(count)
	count = sum_neighbors(cur_y, cur_x)
	#print("({}, {}): {}".format(cur_y, cur_x, count))
	grid_alt[cur_y][cur_x] = count

	if count > goal:
		print("GOAL (alt) : {}".format(count))

	#count += 1
	cur_x += d_x
	cur_y += d_y
	if count <= goal: #wd * hg:
	
		#for row in grid_alt:
		#	print(row)
		#print()
		# if we're going right, we turn as soon as there's nobody above us
		if d_x == 1:
			if cur_y == 0 or grid_alt[cur_y - 1][cur_x] == "":
				d_x = 0
				d_y = -1
		# if going up, check left
		elif d_y == -1:
			if cur_x == 0 or grid_alt[cur_y][cur_x - 1] == "":
				d_x = -1
				d_y = 0
		# if going left, check below
		elif d_x == -1:
			if cur_y == hg - 1 or grid_alt[cur_y + 1][cur_x] == "":
				d_x = 0
				d_y = 1
		# if going down, check right
		elif d_y == 1:
			if cur_x == wd or grid_alt[cur_y][cur_x + 1] == "":
				d_x = 1
				d_y = 0

#while x >= 0:
#	y = hg
#	while y >= 0:
#		print("x, y: {},{}".format(x, y))
#		grid[x - 1][y - 1] = x * y		
#		y -= 1	
#
#	x -= 1


#for row in grid:
#	print(row)
#	print()
#print(grid)
