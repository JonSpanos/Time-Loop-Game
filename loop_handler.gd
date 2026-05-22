extends Node2D

const STORED_LOOP_PATH : String = "user://loopFile1.loop"
var stored_movements : Array[Vector2]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _save() -> void:
	var file = FileAccess.open(STORED_LOOP_PATH, FileAccess.WRITE)
	
func _load() -> void:
	if FileAccess.file_exists(STORED_LOOP_PATH):
		var file = FileAccess.open(STORED_LOOP_PATH, FileAccess.READ)
		pass
