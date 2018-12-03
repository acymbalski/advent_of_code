MAX_WIDTH = 1000
MAX_HEIGHT = 1000
 
grid = []

for r in range(MAX_HEIGHT):
    grid.append([])
    for c in range(MAX_WIDTH):
        grid[r].append('0')
 
def gprint():
    print()
    for r in grid:
        for c in r:
            print(c + ' ', end="")
        print()
    print()
 
# 5 down, 2 across
#grid[5][2] = '@'

def fill_box(x, y, w, h):
    t_x = x
    t_y = y
    does_overlap = False
    while t_x < x + w:
        while t_y < y + h:
            grid[t_y][t_x] = int(grid[t_y][t_x]) + 1
            t_y += 1
        t_x += 1
        t_y = y
        
def get_max_val(x, y, w, h):
    t_x = x
    t_y = y
    max_val = 0
    while t_x < x + w:
        while t_y < y + h:
            if grid[t_y][t_x] > max_val:
                max_val = grid[t_y][t_x]
            t_y += 1
        t_x += 1
        t_y = y
    return max_val
        

with open("input.txt") as f:
    all_lines = f.readlines()

# populate grid
for line in all_lines:
    id = int(line[line.find('#') + 1: line.find(' ')].strip())
    startx = int(line[line.find('@') + 2: line.find(',')].strip())
    starty = int(line[line.find(',') + 1: line.find(':')].strip())
    
    width = int(line[line.find(':') + 2: line.find('x')].strip())
    height = int(line[line.find('x') + 1:].strip())
    
    fill_box(startx, starty, width, height)
    

# check grid for overlap for each id
for line in all_lines:
    id = int(line[line.find('#') + 1: line.find(' ')].strip())
    startx = int(line[line.find('@') + 2: line.find(',')].strip())
    starty = int(line[line.find(',') + 1: line.find(':')].strip())
    
    width = int(line[line.find(':') + 2: line.find('x')].strip())
    height = int(line[line.find('x') + 1:].strip())
    
    if get_max_val(startx, starty, width, height) == 1:
        print("id with no overlap found: {}".format(id))
        break
    