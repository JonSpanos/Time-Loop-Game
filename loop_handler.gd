class_name LoopHandler
extends Node2D

@export var PLAYER : CharacterBody2D
@export var STARTOFLOOP : Node2D
@export var ENDOFLOOP : Node2D

@onready var GHOST_SPRITE : AnimatedSprite2D = ENDOFLOOP.get_child(0)

const TILE_SIZE : int = 16
const STORED_LOOP_PATH : String = "user://loopFile1.loop"
static var STORED_MOVEMENTS : Array[Vector2]

func _save() -> void:
	var file = FileAccess.open(STORED_LOOP_PATH, FileAccess.WRITE)
	file.store_var(STORED_MOVEMENTS)
	_handle_end_of_loop_marker()

func _wipe() -> void:
	STORED_MOVEMENTS.clear()
	_save()
	
	PLAYER.global_position = STARTOFLOOP.global_position
	

func _load() -> void:
	if FileAccess.file_exists(STORED_LOOP_PATH):
		var file = FileAccess.open(STORED_LOOP_PATH, FileAccess.READ)
		var saved_movements = file.get_var()
		print(saved_movements)
		
		PLAYER.global_position = STARTOFLOOP.global_position
		
		for dir in saved_movements:
			print(dir)
			await PLAYER._move(dir, false)
		

func _handle_end_of_loop_marker() -> void:
	ENDOFLOOP.global_position = STARTOFLOOP.global_position
	if !STORED_MOVEMENTS:
		_face_ghost(Vector2(0, 1))
		return
		
	for dir in STORED_MOVEMENTS:
		ENDOFLOOP.global_position += (dir * TILE_SIZE)
	
	_face_ghost(STORED_MOVEMENTS.back()) # Face the ghost in the correct direction

func _face_ghost(dir: Vector2) -> void:
		GHOST_SPRITE.stop()
		if dir == Vector2(0, -1):
			GHOST_SPRITE.play("Up")
		elif dir == Vector2(0, 1):
			GHOST_SPRITE.play("Down")
		elif dir == Vector2(1, 0):
			GHOST_SPRITE.play("Right")
		else:
			GHOST_SPRITE.play("Left")
