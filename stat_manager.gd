class_name Stats

extends Node2D

@onready var PLAYER : CharacterBody2D = self.get_parent()

var MANABAR : ProgressBar

var MANA = 100 # Starting value

func _ready() -> void:
	MANABAR = get_tree().get_first_node_in_group("ManaBar")
	MANABAR.value = MANA 

func _new_loop():
	MANA = 100
	MANABAR.value = MANA
	PLAYER.SET_HAS_MANA(true)

func _tick(val : int) -> bool:
	if MANA <= 0:
		return false
		
	MANA -= val
	MANABAR.value = MANA
	print("MANA: " + str(MANA))
	return MANA > 0 # True if above 0
	
