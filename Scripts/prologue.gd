extends BaseMap


func _ready():
	super() # Call the parent _ready() to set up cursor signal connection
	
	for unit in GameManager.party_units:
		var unit_scene = load(unit["scene"])
		var unit_instance = unit_scene.instantiate()
		add_child(unit_instance)
		unit_instance.position = Vector2(14 + 28 * 5, 14 + 28 * 5)  # Example position, adjust as needed
		unit_grid[5][5] = unit_instance  # Place unit in the unit grid