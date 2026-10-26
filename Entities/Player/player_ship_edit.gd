extends Node2D

@onready var part_selected: ShipComponent = null
@onready var active: bool = true
@export var grid_snap: bool = false
@export var part_rot_spd: float = 150.0
@export var player: Node2D # TODO: pass this programmatically eventually

func _ready() -> void:
	# Set viewport picking parameters so that only the "top" (by z-index) node gets grabbed on click
	get_viewport().physics_object_picking_first_only = true
	get_viewport().physics_object_picking_sort = true
	# Hook player part_selected signals to signal handler
	player.player_paused = true
	player.ship_core.part_selected.connect(_on_part_selected)
	for component in player.components:
		component.part_selected.connect(_on_part_selected)

func toggle_active() -> void:
	if (active):
		active = false
		player.cull_orphaned_parts()
		player.player_paused = false
	else:
		active = true
		player.player_paused = true

# Game loop
func _process(delta: float) -> void:
	if (part_selected != null):
		# Move to mouse
		part_selected.global_position = get_global_mouse_position()
		# Check rotation input
		if (Input.is_action_pressed("rotate_part_left")):
			part_selected.rotation_degrees += part_rot_spd * delta
		elif (Input.is_action_pressed("rotate_part_right")):
			part_selected.rotation_degrees -= part_rot_spd * delta
		# TODO: constrain rotation to 0-360
		# Check flip input
		if (Input.is_action_just_pressed("flip_component")):
			part_selected.toggle_flip_h()
		# Seek connections in the selected component
		for component in player.components:
			component.seek_connections()

# Input handling
func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and Input.is_action_just_released("select")):
		part_selected = null # Reset selection to nothing

# Signal grabber for part_selected signals
func _on_part_selected(part: ShipComponent) -> void:
	part_selected = part
