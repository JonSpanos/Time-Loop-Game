extends CharacterBody2D

const TILE_SIZE : int = 16
const TIME_TO_MOVE_BETWEEN_TILES : float = 0.15
@onready var PLAYER_SPRITE : AnimatedSprite2D = $Sprite
var POS_TWEEN : Tween

# Saving/Loop Data
const STORED_LOOP_PATH : String = "user://loopFile1.loop"
var LOOP_FILE : FileAccess
var stored_movements : Array[Vector2]


func _ready():
	LOOP_FILE = FileAccess.open(STORED_LOOP_PATH, FileAccess.WRITE)
	
	
func _physics_process(delta: float) -> void:
	if !POS_TWEEN or !POS_TWEEN.is_running(): # If not already moving.
		_handle_movement_inputs()

func _handle_movement_inputs() -> void:
	if Input.is_action_just_pressed("move_up"):
		_move(Vector2(0, -1))
		PLAYER_SPRITE.stop()
		PLAYER_SPRITE.play("Walk_Up")
	elif Input.is_action_just_pressed("move_down"):
		_move(Vector2(0, 1))
		PLAYER_SPRITE.stop()
		PLAYER_SPRITE.play("Walk_Down")
	elif Input.is_action_just_pressed("move_left"):
		_move(Vector2(-1, 0))
		PLAYER_SPRITE.stop()
		PLAYER_SPRITE.play("Walk_Side")
		PLAYER_SPRITE.flip_h = true
	elif Input.is_action_just_pressed("move_right"):
		_move(Vector2(1, 0))
		PLAYER_SPRITE.stop()
		PLAYER_SPRITE.play("Walk_Side")
		PLAYER_SPRITE.flip_h = false

func _move(dir: Vector2) -> void:
	# Move
	var pos_to_tween : Vector2 = global_position + (dir * TILE_SIZE)
	POS_TWEEN = create_tween()
	POS_TWEEN.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	POS_TWEEN.tween_property(self, "global_position", pos_to_tween, TIME_TO_MOVE_BETWEEN_TILES)
	
	# Store movement to loop file
	stored_movements.append(dir)
	print(stored_movements)
