extends Node2D

class_name Unit

@export var unit_data: UnitData
@export var animation: AnimatedSprite2D

var data : UnitData
var current_hp: int

enum ALLEIANCE{
    PLAYER,
    ENEMY,
    NPC
}
var alleiance = ALLEIANCE.PLAYER

func _ready():
    if unit_data:
        data = unit_data.duplicate()
        current_hp = data.max_hp
    else:
        push_error("UnitData not assigned to Unit node.")


func get_movement() -> int:
    return data.movement

func get_type() -> String:
    return data.unit_type