extends Node

# Base class for all map functionalities
class_name BaseMap

@export var width: int
@export var height: int

const TILE_SIZE = 28

var map_grid = []
var unit_grid = []
var tiles: Dictionary = {
    "plain": preload("res://Resources/Tiles/Plain.tres"),
    "lake": preload("res://Resources/Tiles/Lake.tres"),
    "wall": preload("res://Resources/Tiles/Wall.tres")
}


# Return the array with all reachable tiles for a given unit (to paint in blue)
func get_reachable_tiles(unit) -> Array:
    var queue = [unit.position]
    var remaining_tile_movement = {unit.position: unit.movement}

    while queue:
        var current_pos = queue.pop_front()
        var remaining_movement = remaining_tile_movement[current_pos]

        for neighbor in get_neighbors(current_pos):
            var tile = map_grid[neighbor.y][neighbor.x]
            var new_remaining_movement = tile.can_unit_enter(unit.unit_type, remaining_movement)

            if (new_remaining_movement >= 0 and 
            (!remaining_tile_movement.has(neighbor) or new_remaining_movement > remaining_tile_movement[neighbor])):
                
                remaining_tile_movement[neighbor] = new_remaining_movement
                queue.push_back(neighbor)

    return remaining_tile_movement.keys()


# Return adjacent tiles
func get_neighbors(pos: Vector2) -> Array:
    var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
    var neighbors = []

    for dir in directions:
        var neighbor_pos = pos + dir
        if neighbor_pos.x >= 0 and neighbor_pos.x < width and neighbor_pos.y >= 0 and neighbor_pos.y < height:
            neighbors.append(neighbor_pos)

    return neighbors