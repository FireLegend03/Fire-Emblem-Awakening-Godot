extends BaseMap


func _ready():
	super() # Call the parent _ready() to set up cursor signal connection
	
	for unit in GameManager.party_units:
		var unit_scene = load(unit["scene"])
		var unit_instance = unit_scene.instantiate()
		add_child(unit_instance)
		unit_instance.position = Vector2(14 + 28 * 5, 14 + 28 * 5)  # Example position, adjust as needed
		unit_grid[5][5] = unit_instance  # Place unit in the unit grid

	fill_map_grid()
	

# Fills the map matrix for the prologue map
func fill_map_grid():
	var plain = tiles["plain"]
	var lake = tiles["lake"]
	var wall = tiles["wall"]
	var column = []
	for x in range(6):
		column = []
		for y in range(height):
			if y >= 2 and y <= 4:
				column.append(lake)
			else:
				column.append(plain)
		map_grid.append(column)
	for x in range(6, 9):
		column = []
		for y in range(height):
			column.append(plain)
		map_grid.append(column)
	# x = 9:
	column = []
	for y in range(height):
		if y >= 2 and y <= 4:
			column.append(lake)
		else:
			column.append(plain)
	map_grid.append(column)
	for x in range(10, 12):
		column = []
		for y in range(height):
			if y < 2 or y == 7 or y == 8:
				column.append(plain)
			else:
				column.append(lake)
		map_grid.append(column)
	# x = 12:
	column = []
	for y in range(height):
		if (y >= 2 and y <= 4) or y == 10 or y == 11:
			column.append(lake)
		else:
			column.append(plain)
	map_grid.append(column)
	for x in range(13, width):
		column = []
		for y in range(height):
			if y >= 2 and y <= 4:
				column.append(lake)
			else:
				column.append(plain)
		map_grid.append(column)
	map_grid[2][7] = wall
	map_grid[3][7] = wall
	map_grid[6][7] = wall
	map_grid[7][7] = wall
	
	map_grid[2][10] = wall
	map_grid[3][10] = wall
	map_grid[6][10] = wall
	map_grid[7][10] = wall
