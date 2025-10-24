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

signal cursor_moved(new_position: Vector2)


func _ready():
	hover_animation()


func _process(_delta: float) -> void:
	
	match state:
		STATE.IDLE:
			var current_direction = Vector2.ZERO
			# Rounds so diagonal input are (1,1), (-1,1), (1,-1), (-1,-1)
			current_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").round()
			if current_direction != previous_direction and current_direction != Vector2.ZERO:
				previous_direction = current_direction
				holding_delay_timer.start() # Start the timer for holding delay only after the first move
				move_cursor(previous_direction)
			elif current_direction == Vector2.ZERO:
				holding_delay_timer.stop()
				previous_direction = Vector2.ZERO
			elif holding_delay_timer.time_left == 0 and current_direction != Vector2.ZERO:
				move_cursor(current_direction)
			
	

func move_cursor(direction: Vector2) -> void:
	var new_position = position + direction * TILE_SIZE
	if new_position.x >= 0 and new_position.x < map_size.x * TILE_SIZE and new_position.y >= 0 and new_position.y < map_size.y * TILE_SIZE:
		state = STATE.MOVING
		cursor_moved.emit(new_position) # Tells the map the new cursor position

		cursor_tween = get_tree().create_tween()
		# Smoothly move to new position (4 frames)
		cursor_tween.tween_property(self, "position", new_position, 0.07) 
		cursor_tween.set_trans(Tween.TRANS_LINEAR)

		await cursor_tween.finished # Wait until the tween is done
		cursor_tween.kill() # Free the tween
		state = STATE.IDLE # Allow movement again
	

# Creates looping up and down animation for the cursor
func hover_animation():
	var sprite_tween = get_tree().create_tween()
	sprite_tween.tween_property(cursor_sprite, "position:y", cursor_sprite.position.y - 4, 0.5)
	sprite_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	sprite_tween.tween_property(cursor_sprite, "position:y", cursor_sprite.position.y + 4, 0.5)
	sprite_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	sprite_tween.set_loops()  # Loop indefinitely
