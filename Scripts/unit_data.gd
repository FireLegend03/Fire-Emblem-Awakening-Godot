extends Resource

class_name UnitData

@export var unit_name: String
@export var unit_class : String
@export var unit_type: String # e.g., "Infantry", "Mounted", "Fliers", "Magicians", "Special"

# Stats
@export var level: int
@export var max_hp: int
@export var strength: int
@export var magic: int
@export var skill: int
@export var speed: int
@export var luck: int
@export var defense: int
@export var resistance: int
@export var movement: int