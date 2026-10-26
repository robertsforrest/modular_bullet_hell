extends Node2D

@export var player: Node2D
@export var camera: Camera2D
@export var enemy_factory: Node
@export var ship_edit: Node2D

const player_tscn: PackedScene = preload("res://Entities/Player/Player.tscn")
const component_core: PackedScene = preload("res://Entities/Player/Components/PlayerCore.tscn")
const component_wing: PackedScene = preload("res://Entities/Player/Components/Wings/Wing.tscn")
const component_thruster: PackedScene = preload("res://Entities/Player/Components/Thrusters/Thruster.tscn")
const component_machine_gun: PackedScene = preload("res://Entities/Player/Components/Guns/MachineGun.tscn")
const component_laser_gun: PackedScene = preload("res://Entities/Player/Components/Guns/LaserGun.tscn")

func _process(delta: float) -> void:
	# Regular input handling
	if (Input.is_action_just_pressed("toggle_editor")):
		ship_edit.toggle_active()
	# Debug input handling
	if (Input.is_action_just_pressed("debug_2")):
		var new_enemy = enemy_factory.generate_enemy()
		add_child(new_enemy)

# Accessor for player
func get_player() -> Node2D:	
	return player

# Temp method to build a player for passing around
func build_player() -> Node2D:
	player = player_tscn.instantiate()
	return player
