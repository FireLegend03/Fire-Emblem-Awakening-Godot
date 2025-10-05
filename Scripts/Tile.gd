extends Resource

class_name Tile

@export var terrain_type: String
@export var movement_cost: Dictionary = {
    "Infantry": 1,
    "Mounted": 1,
    "Fliers": 1,
    "Magicians": 1,
    "Special": 1
}
@export var defense_bonus: int = 0
@export var avoidance_bonus: int = 0
@export var heal_amount: int = 0

# returns remaining movement after entering, so if negative, unit can't enter
func can_unit_enter(unit_type: String, remaining_movement: int) -> int:
    # Special case for lords and tacticians on lakes
    if terrain_type == "Lake":
        # Lords and tacticians can enter lakes when they have 2 plus movement left
        if unit_type == "Special" and remaining_movement >= 2: 
            return 0 # they can't move further after entering
            
    # General movement cost check
    return remaining_movement - movement_cost.get(unit_type, 999) # Default high cost if unit type not found

    