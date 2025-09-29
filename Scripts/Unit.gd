extends Node2D

class_name Unit

@export var unit_data: UnitData
@export var animation: AnimatedSprite2D

var level: int
var max_hp: int
var current_hp: int
var strength: int
var magic: int
var skill: int
var speed: int
var luck: int
var defense: int
var resistance: int
var movement: int

func _ready():
    if unit_data:
        level = unit_data.level
        max_hp = unit_data.max_hp
        current_hp = max_hp
        strength = unit_data.strength
        magic = unit_data.magic
        skill = unit_data.skill
        speed = unit_data.speed
        luck = unit_data.luck
        defense = unit_data.defense
        resistance = unit_data.resistance
        movement = unit_data.movement
    else:
        push_error("UnitData not assigned to Unit node.")