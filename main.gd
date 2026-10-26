extends Node2D

@export var player: Node2D
@export var camera: Camera2D
@export var enemy_factory: Node
@export var player_edit: Node2D

func _process(delta: float) -> void:
	# Regular input
	if (Input.is_action_just_pressed("toggle_editing")):
		player_edit.toggle_editing()
	# Debug input
	if (Input.is_action_just_pressed("debug_2")):
		var new_enemy = enemy_factory.generate_enemy()
		add_child(new_enemy)

# Accessor for player
func get_player() -> Node2D:
	return player
