extends Node2D

@export var player: Node2D # TODO: this will eventually be handled programmatically
@onready var part_selected: ShipComponent = null
@export var grid_snap: bool = false
@export var rot_spd: float = 100.0
@export var snap_rot_deg: float = 45.0

func _ready() -> void:
	player.is_paused = true
	player.rotation = 0 # Get rid of rotation while in the editor to make line physics not a nightmare
	# Set viewport picking parameters so that only the "top" (by z-index) node gets grabbed on click
	get_viewport().physics_object_picking_first_only = true
	get_viewport().physics_object_picking_sort = true
	# Hook player component part_selected signals up to editor logic
	player.ship_core.part_selected.connect(_on_part_selected)
	for component in player.components:
		component.part_selected.connect(_on_part_selected)

# Game loop
func _process(delta) -> void:
	# Check for grid snap toggle
	if (Input.is_action_just_pressed("toggle_editor_snap")):
		grid_snap = !grid_snap
	# Run part_selected code if applicable
	if (part_selected != null):
		# Set part position to mouse position
		if (grid_snap):
			# Grid-snapped mouse position
			part_selected.global_position = get_global_mouse_position().snappedf(Global.GRID_SNAP_STEPS)
			# Snapped rotational input
			if (Input.is_action_just_pressed("rotate_part_left")):
				part_selected.rotation_degrees = snapped(part_selected.rotation_degrees - snap_rot_deg,snap_rot_deg)
			elif (Input.is_action_just_pressed("rotate_part_right")):
				part_selected.rotation_degrees = snapped(part_selected.rotation_degrees + snap_rot_deg,snap_rot_deg)
		else:
			# Freeform movement
			part_selected.global_position = get_global_mouse_position() # TODO: add grid snap
			# Freeform rotational input
			var rot_axis = Input.get_axis("rotate_part_left","rotate_part_right")
			if (rot_axis != 0):
				part_selected.rotation_degrees += rot_spd * delta * sign(rot_axis)
		# Check for flip input
		if (Input.is_action_just_pressed("flip_part")):
			part_selected.toggle_flip_h()
		# Run update code on ALL components in the player
		# NOTE: this shit is like O(n^15) with all these loops lmao
		for component in player.components:
			component.run_slots_for_editor()

# Handle input for mouse button released
func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and Input.is_action_just_released("select")):
		part_selected = null

# Handle selection signal from player ship components
func _on_part_selected(part: ShipComponent) -> void:
	part_selected = part
