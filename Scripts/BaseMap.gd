extends Node

# Base class for all map functionalities
class_name BaseMap

# Map dimensions
@export var width: int
@export var height: int
@onready var highlight_map: TileMap = $HighlightMap
@onready var tile_map: TileMap = $TileMap

const TILE_SIZE = 28

# grid to hold the map tiles and unit placements
var map_grid = []
var unit_grid = []
# dictionary to hold tile resources
var tiles: Dictionary = {
	"plain": preload("res://Resources/Tiles/Plain.tres"),
	"lake": preload("res://Resources/Tiles/Lake.tres"),
	"wall": preload("res://Resources/Tiles/Wall.tres")
}


func _ready():
	var cursor = get_node("Cursor")
	cursor.cursor_moved.connect(_on_cursor_moved)
	
	# Fill the map grid based on the TileMap
	fill_map_grid()

	# Initialize unit grid with nulls
	for x in range(width):
		var column = []
		for y in range(height):
			column.append(null) 
		unit_grid.append(column)
	
	

# Fills the map matrix with tile resources based on the TileMap
func fill_map_grid():
	for x in range(width):
		var column = []
		for y in range(height):
			var tile_type = tile_map.get_cell_tile_data(0, Vector2i(x, y)).get_custom_data("terrain")
			column.append(tiles[tile_type])
		map_grid.append(column)


# Return the array with all walkable tiles for a given unit (to paint in blue)
func get_walkable_tiles(unit, pos: Vector2i) -> Array:
	var queue = [pos]
	var remaining_tile_movement = {pos: unit.get_movement()}

	while queue:
		var current_pos = queue.pop_front()
		var remaining_movement = remaining_tile_movement[current_pos]

		for neighbor in get_neighbors(current_pos):
			var tile = map_grid[neighbor.x][neighbor.y]
			var new_remaining_movement = tile.can_unit_enter(unit.get_type(), remaining_movement)

			if (new_remaining_movement >= 0 and 
			(!remaining_tile_movement.has(neighbor) or new_remaining_movement > remaining_tile_movement[neighbor])):
				
				remaining_tile_movement[neighbor] = new_remaining_movement
				queue.push_back(neighbor)

	return remaining_tile_movement.keys()


# Return adjacent tiles
func get_neighbors(pos: Vector2i) -> Array:
	var directions = [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]
	var neighbors = []

	for dir in directions:
		var neighbor_pos = pos + dir
		if neighbor_pos.x >= 0 and neighbor_pos.x < width and neighbor_pos.y >= 0 and neighbor_pos.y < height:
			neighbors.append(neighbor_pos)

	return neighbors


func _on_cursor_moved(new_position: Vector2) -> void:
	var pos = Vector2i(new_position / TILE_SIZE)
	print("Cursor moved to: ", pos) # For debugging purposes
	print("tile: ", map_grid[pos.x][pos.y])

	var unit = unit_grid[pos.x][pos.y]

	if unit:
		var walkable_tiles = get_walkable_tiles(unit, pos)
		highlight_tiles(walkable_tiles)
		
		

func highlight_tiles(walkable_tiles: Array) -> void:
	highlight_map.clear()
	for tile in walkable_tiles:
		highlight_map.set_cell(0, tile, 0, Vector2i(0,0))  # Set the tile to a highlighted state
