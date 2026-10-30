extends Control

# Constants
const JOHNNY_WIDTH = 700

# Editor nodes
@export var johnny: TextureRect
@export var player: Node2D

# Scene resources
@export var repair_screen_tscn: PackedScene = preload("res://Hangar/Repairs/RepairScreen.tscn")

# Called when the hangar is first "opened" as the player enters
func open_hangar() -> void:
	# Animate Johnny :)
	var johnny_tween: Tween = get_tree().create_tween()
	johnny_tween.bind_node(johnny)
	johnny.position.x = -JOHNNY_WIDTH
	johnny_tween.tween_property(johnny, "position:x", 24, 0.2) # TODO: magic number naughty naughty!

# Called when the hangar is "closed" - by button press, hotkey, or otherwise
func close_hangar() -> void:
	pass

# Button signals
# Open the shop
func _on_button_shop_pressed() -> void:
	print("Opening shop!")

# Open the repair screen
func _on_button_repair_pressed() -> void:
	# Apply tweens to the other UI elements
	# Add the repair screen node to the scene
	var repair = repair_screen_tscn.instantiate()
	add_child(repair)

# Open the ship editor
func _on_button_edit_pressed() -> void:
	print("Opening editor!")
