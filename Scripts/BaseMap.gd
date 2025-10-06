extends Node

# Base class for all map functionalities
class_name BaseMap

var map_grid = {}
var unit_grid = {}


func _ready():
    for unit in GameManager.party_units:
        var unit_scene = load(unit["scene"])
        var unit_instance = unit_scene.instantiate()
        add_child(unit_instance)