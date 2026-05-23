class_name Player
extends CharacterBody2D

@export var MOVE_TICK_RATE : int = 1

@onready var PLAYER_SPRITE : AnimatedSprite2D = $Sprite
@onready var STATS : Stats = $StatManager

const TILE_SIZE : int = 16
const TIME_TO_MOVE_BETWEEN_TILES : float = 0.15
var POS_TWEEN : Tween
var INPUT_LOCK = false

var HAS_MANA = true

# Signals
signal completed

func _physics_process(_delta: float) -> void:
	if HAS_MANA and (!INPUT_LOCK or !POS_TWEEN or !POS_TWEEN.is_running()): # If not already moving.
		_handle_movement_inputs()

func _handle_movement_inputs() -> void:
	var dir = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		dir = Vector2(0, -1)
	elif Input.is_action_pressed("move_down"):
		dir = Vector2(0, 1)
	elif Input.is_action_pressed("move_left"):
		dir = Vector2(-1, 0)
	elif Input.is_action_pressed("move_right"):
		dir = Vector2(1, 0)
	
	if dir == Vector2.ZERO or INPUT_LOCK: # Check for INPUT_LOCK as well incase an physics process gets called somehow before finishing
		return
	
	# Await doesn't stop the next physics process call, so we need to lock the input before the call to ensure
	INPUT_LOCK = true
	await _move(dir)
	INPUT_LOCK = false

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
		print("Manually moving... HAS_MANA: " + str(HAS_MANA))
		LoopHandler.STORED_MOVEMENTS.append(dir)
	
	HAS_MANA = STATS._tick(MOVE_TICK_RATE)
	
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

# For use in other scripts, such as the Loop Handler or Stat Manager.
func LOCK(state : bool) -> void:
	INPUT_LOCK = state

func SET_HAS_MANA(state : bool) -> void:
	HAS_MANA = state
