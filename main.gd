extends Node2D

@export var player: Node2D
@export var camera: Camera2D
@export var enemy_factory: Node
@export var hangar_layer: CanvasLayer
@export var hangar: Control
@onready var player_edit: Node2D = null

const player_edit_tscn = preload("res://PlayerEdit.tscn")
# TODO: enum/global const this shit eventually
const scrap: InventoryItem = preload("res://Inventory/Items/scrap.tres")
const laser_gun: InventoryItem = preload("res://Inventory/Items/laser_gun.tres")

# Game loop
func _process(delta: float) -> void:
	# Debug inputs
	if (Input.is_action_just_pressed("debug_2")):
		# Open the hangar
		if (hangar_layer.visible == true):
			hangar_layer.visible = false
			hangar.close_hangar()
			get_tree().paused = false
		else:
			hangar_layer.visible = true
			get_tree().paused = true
			hangar.open_hangar()
		# Add some junk to the player's inventory
		#player.inventory.add_item(scrap, 10)
		#player.inventory.add_item(laser_gun, 1)
		#print(player.inventory.get_cargo_amount())
		#player.inventory.add_item(scrap, 20)
		#var new_enemy = enemy_factory.generate_enemy()
		#add_child(new_enemy)

# Accessor for player
func get_player() -> Node2D:
	return player
