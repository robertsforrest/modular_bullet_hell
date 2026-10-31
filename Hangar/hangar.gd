extends Control

# Constants
const JOHNNY_WIDTH = 700

# Editor nodes
@export var johnny: TextureRect
@export var player: Node2D
@export var repair_screen: Control

# Scene resources
@export var repair_screen_tscn: PackedScene = preload("res://Hangar/Repairs/RepairScreen.tscn")

# Initialize
func _ready() -> void:
	print(player)
	repair_screen.player = player
	print(repair_screen.player)

# Called when the hangar is first "opened" as the player enters
func open_hangar() -> void:
	# Pause the player
	player.is_paused = true
	# Animate Johnny :)
	var johnny_tween: Tween = get_tree().create_tween()
	johnny_tween.bind_node(johnny)
	johnny.position.x = -JOHNNY_WIDTH
	johnny_tween.tween_property(johnny, "position:x", 24, 0.2) # TODO: magic number naughty naughty!

# Called when the hangar is "closed" - by button press, hotkey, or otherwise
func close_hangar() -> void:
	player.is_paused = false

# Propagates signal down to the active tab
# TODO: handle this in a more robust manner than just if (tab==n) - keyword this stuff out somehow
func _on_tab_container_tab_selected(tab: int) -> void:
	if (tab == 1):
		repair_screen.set_active_tab()
