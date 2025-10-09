extends Node2D

class_name Cursor

enum STATE {
	IDLE,
	MOVING
}

@onready var state = STATE.IDLE

@export var cursor_sprite: Sprite2D
@export var map_size: Vector2i # Stores the map size in grid units

var cursor_tween: Tween # Tween for smooth cursor movement

func _ready():
	position = Vector2(14 * 5, 14 * 5)  # Initial position
	hover_animation()

# Creates looping up and down animation for the cursor
func hover_animation():
	var sprite_tween = get_tree().create_tween()
	sprite_tween.tween_property(cursor_sprite, "position:y", cursor_sprite.position.y - 4, 0.5)
	sprite_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	sprite_tween.tween_property(cursor_sprite, "position:y", cursor_sprite.position.y + 4, 0.5)
	sprite_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	sprite_tween.set_loops()  # Loop indefinitely

func _process(delta: float) -> void:
	
	match state:
		STATE.IDLE:
			if Input.is_action_just_pressed("ui_right"):
				move_cursor(Vector2(1, 0))
			elif Input.is_action_just_pressed("ui_left"):
				move_cursor(Vector2(-1, 0))
			elif Input.is_action_just_pressed("ui_down"):
				move_cursor(Vector2(0, 1))
			elif Input.is_action_just_pressed("ui_up"):
				move_cursor(Vector2(0, -1))
	


func move_cursor(direction: Vector2):
	var new_position = position + direction * 14
	print("Moving cursor to: ", new_position)
	if new_position.x >= 0 and new_position.x < map_size.x * 14 and new_position.y >= 0 and new_position.y < map_size.y * 14:
		state = STATE.MOVING
		cursor_tween = get_tree().create_tween()
		# Smoothly move to new position (4 frames)
		cursor_tween.tween_property(self, "position", new_position, 0.07) 
		cursor_tween.set_trans(Tween.TRANS_LINEAR)
		cursor_tween.tween_callback(_on_tween_finished) # Somehow this connects the signal 

# Enable movement again when tween is finished
func _on_tween_finished():
	cursor_tween.kill()
	state = STATE.IDLE
