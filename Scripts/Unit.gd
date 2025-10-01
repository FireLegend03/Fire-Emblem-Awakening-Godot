extends Node2D

class_name Unit

@export var unit_data: UnitData
@export var animation: AnimatedSprite2D

var data : UnitData

func _ready():
    if unit_data:
        data = unit_data.duplicate()
    else:
        push_error("UnitData not assigned to Unit node.")

