extends GridMap

enum ENTITY_TYPES {PLAYER}

const CELL_SIZE = 1
const GRID_SIZE = Vector3(16, 0, 16)

var grid = []

func _ready():
	for x in range(GRID_SIZE.x):
		grid.append([])
		for z in range(GRID_SIZE.z):
			grid[x].append(null)
	
	var positions = []
	for n in range(5):
		var grid_pos = Vector3(randi() % int(GRID_SIZE.x), 0, randi() % int(GRID_SIZE.z))

func is_cell_vacant(pos, dir):
	# return true if the cell is vacant, else false
	return true

# Move child to new position returns new target position
func update_child_pos(child, direction):
	var grid_pos = world_to_map(child.get_pos())
	print(grid_pos)
	grid[grid_pos.x][grid_pos.z] = null
	
	var new_grid_pos = grid_pos + direction
	grid[new_grid_pos.x][new_grid_pos.z] = child.type
	
	var target_pos = map_to_world(new_grid_pos.x, new_grid_pos.y, new_grid_pos.z)
	return target_pos



