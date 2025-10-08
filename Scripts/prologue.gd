extends BaseMap


func _ready():
	for unit in GameManager.party_units:
			var unit_scene = load(unit["scene"])
			var unit_instance = unit_scene.instantiate()
			add_child(unit_instance)
			unit_instance.position = Vector2(14 * 5, 14 * 5)  # Example position, adjust as needed
	
