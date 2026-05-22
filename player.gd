class_name Player
extends CharacterBody2D

const TILE_SIZE : int = 16
const TIME_TO_MOVE_BETWEEN_TILES : float = 0.15
@onready var PLAYER_SPRITE : AnimatedSprite2D = $Sprite
var POS_TWEEN : Tween

# Signals
signal completed

func _physics_process(delta: float) -> void:
	if !POS_TWEEN or !POS_TWEEN.is_running(): # If not already moving.
		_handle_movement_inputs()

func _handle_movement_inputs() -> void:
	if Input.is_action_just_pressed("move_up"):
		_move(Vector2(0, -1))
	elif Input.is_action_just_pressed("move_down"):
		_move(Vector2(0, 1))
	elif Input.is_action_just_pressed("move_left"):
		_move(Vector2(-1, 0))
	elif Input.is_action_just_pressed("move_right"):
		_move(Vector2(1, 0))

func _move(dir: Vector2, save : bool = true) -> Signal:
	# Play Animation
	_play_anim(dir)
	
	# Move
	var pos_to_tween : Vector2 = global_position + (dir * TILE_SIZE)
	POS_TWEEN = create_tween()
	POS_TWEEN.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	POS_TWEEN.tween_property(self, "global_position", pos_to_tween, TIME_TO_MOVE_BETWEEN_TILES)
	
	await POS_TWEEN.finished
	
	# Store movement to loop file
	if save:
		LoopHandler.STORED_MOVEMENTS.append(dir)
		
	completed.emit()
	return completed
	
func _play_anim(dir: Vector2) -> void:
		PLAYER_SPRITE.stop()
		PLAYER_SPRITE.flip_h = false
		if dir == Vector2(0, -1):
			PLAYER_SPRITE.play("Walk_Up")
		elif dir == Vector2(0, 1):
			PLAYER_SPRITE.play("Walk_Down")
		elif dir == Vector2(1, 0):
			PLAYER_SPRITE.play("Walk_Side")
		else:
			PLAYER_SPRITE.play("Walk_Side")
			PLAYER_SPRITE.flip_h = true
