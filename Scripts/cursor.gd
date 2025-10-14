extends Node2D

class_name Cursor


enum STATE {
	IDLE,
	MOVING
}
@onready var state = STATE.IDLE

const TILE_SIZE = 28

@export var cursor_sprite: Sprite2D
@export var map_size: Vector2i # Stores the map size in grid units
@export var holding_delay_timer: Timer # little delay before moving after holding down a direction


var cursor_tween: Tween # Tween for smooth cursor movement
var previous_direction: Vector2 = Vector2.ZERO # To track the last direction moved

func _ready():
	position = Vector2(14 + TILE_SIZE * 5, 14 + TILE_SIZE * 5)  # Initial position
	hover_animation()


func _process(_delta: float) -> void:
	
	match state:
		STATE.IDLE:
			# Diagonal movement
			if Input.is_action_just_pressed("ui_right") and Input.is_action_just_pressed("ui_down"):
				holding_delay_timer.start() # Start the timer for holding delay only after the first move
				previous_direction = Vector2(1, 1)
				move_cursor(previous_direction)
			elif Input.is_action_just_pressed("ui_right") and Input.is_action_just_pressed("ui_up"):
				holding_delay_timer.start()
				previous_direction = Vector2(1, -1)
				move_cursor(previous_direction)
			elif Input.is_action_just_pressed("ui_left") and Input.is_action_just_pressed("ui_up"):
				holding_delay_timer.start()
				previous_direction = Vector2(-1, -1)
				move_cursor(previous_direction)
			elif Input.is_action_just_pressed("ui_left") and Input.is_action_just_pressed("ui_down"):
				holding_delay_timer.start()
				previous_direction = Vector2(-1, 1)
				move_cursor(previous_direction)

			# Single input directions
			elif Input.is_action_just_pressed("ui_right"):
				holding_delay_timer.start()
				previous_direction = Vector2(1, 0)
				move_cursor(previous_direction)
			elif Input.is_action_just_pressed("ui_left"):
				holding_delay_timer.start()
				previous_direction = Vector2(-1, 0)
				move_cursor(previous_direction)
			elif Input.is_action_just_pressed("ui_down"):
				holding_delay_timer.start()
				previous_direction = Vector2(0, 1)
				move_cursor(previous_direction)
			elif Input.is_action_just_pressed("ui_up"):
				holding_delay_timer.start()
				previous_direction = Vector2(0, -1)
				move_cursor(previous_direction)

			# Holding input directions
			# Slide if the timer has run out and the key is still held
			elif holding_delay_timer.time_left == 0:
				var current_direction = Vector2.ZERO
				# Diagonal movement
				if Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_down"):
					current_direction = Vector2(1, 1)
					move_cursor(current_direction)
				elif Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_up"):
					current_direction = Vector2(1, -1)
					move_cursor(current_direction)
				elif Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_up"):
					current_direction = Vector2(-1, -1)
					move_cursor(current_direction)
				elif Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_down"):
					current_direction = Vector2(-1, 1)
					move_cursor(current_direction)

				# Single directions
				elif Input.is_action_pressed("ui_right"):
					current_direction = Vector2(1, 0)
					move_cursor(current_direction)
				elif Input.is_action_pressed("ui_left"):
					current_direction = Vector2(-1, 0)
					move_cursor(current_direction)
				elif Input.is_action_pressed("ui_down"):
					current_direction = Vector2(0, 1)
					move_cursor(current_direction)
				elif Input.is_action_pressed("ui_up"):
					current_direction = Vector2(0, -1)
					move_cursor(current_direction)
				
				# If the direction has changed, reset the timer
				if current_direction != previous_direction and current_direction != Vector2.ZERO:
					previous_direction = current_direction
					holding_delay_timer.start()


	if (Input.is_action_just_released("ui_right") or Input.is_action_just_released("ui_left")
	or Input.is_action_just_released("ui_down") or Input.is_action_just_released("ui_up")):
		holding_delay_timer.stop()
	

func move_cursor(direction: Vector2) -> void:
	var new_position = position + direction * TILE_SIZE
	print("Moving cursor to: ", new_position)
	if new_position.x >= 0 and new_position.x < map_size.x * TILE_SIZE and new_position.y >= 0 and new_position.y < map_size.y * TILE_SIZE:
		state = STATE.MOVING
		cursor_tween = get_tree().create_tween()
		# Smoothly move to new position (4 frames)
		cursor_tween.tween_property(self, "position", new_position, 0.07) 
		cursor_tween.set_trans(Tween.TRANS_LINEAR)

		await cursor_tween.finished # Wait until the tween is done
		cursor_tween.kill() # Free the tween
		state = STATE.IDLE # Allow movement again
	


func _on_holding_delay_timeout() -> void:
	pass # Replace with function body.


# Creates looping up and down animation for the cursor
func hover_animation():
	var sprite_tween = get_tree().create_tween()
	sprite_tween.tween_property(cursor_sprite, "position:y", cursor_sprite.position.y - 4, 0.5)
	sprite_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	sprite_tween.tween_property(cursor_sprite, "position:y", cursor_sprite.position.y + 4, 0.5)
	sprite_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	sprite_tween.set_loops()  # Loop indefinitely