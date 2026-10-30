extends Node2D

@export var player: Node2D
@export var camera: Camera2D
@export var enemy_factory: Node
@onready var player_edit: Node2D = null

const player_edit_tscn = preload("res://PlayerEdit.tscn")
const scrap: InventoryItem = preload("res://Inventory/Items/scrap.tres")

# Game loop
func _process(delta: float) -> void:
	# Real inputs
	if (Input.is_action_just_pressed("toggle_edit")):
		if (player_edit == null):
			player_edit = player_edit_tscn.instantiate()
			player_edit.player = player # Pass reference to player for editing
			add_child(player_edit)
		else:
			player_edit.end_editing()
	# Debug inputs
	if (Input.is_action_just_pressed("debug_2")):
		# Add some junk to the player's inventory
		player.inventory.add_item(scrap, 10)
		print(player.inventory.get_cargo_amount())
		player.inventory.add_item(scrap, 20)
		#var new_enemy = enemy_factory.generate_enemy()
		#add_child(new_enemy)

# Accessor for player
func get_player() -> Node2D:
	return player
