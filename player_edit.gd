extends Node2D

@export var player: Node2D
@export var part_rot_spd: float = 100.0
@export var snap_parts: bool = true
@export var snap_distance: float = 20.0
@onready var is_editing: bool = true
@onready var part_selected: ShipComponent = null
@onready var saved_player_rotation = 0

func _ready() -> void:
	# Set viewport picking parameters so that only the "top" (by z-index) node gets grabbed on click
	get_viewport().physics_object_picking_first_only = true
	get_viewport().physics_object_picking_sort = true
	# Hook player part_selected signals to signal handler
	player.is_paused = true
	player.ship_core.part_selected.connect(_on_part_selected)
	for component in player.components:
		component.part_selected.connect(_on_part_selected)

# Game loop
func _process(delta: float) -> void:
	if (part_selected != null and is_editing):
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
		# Check for part connections
		print(part_selected.global_rotation)
		for conn_point in part_selected.connection_points:
			var point_overlap = conn_point.get_overlapping_areas()
			if (!point_overlap.is_empty()):
				if (point_overlap[0].max_size >= part_selected.component_size):
					if (snap_parts):
						var target_position = point_overlap[0].global_position
						target_position -= Vector2(conn_point.position.x*part_selected.scale.x,conn_point.position.y)
						if (get_global_mouse_position().distance_to(target_position) <= snap_distance):
							part_selected.global_position = target_position

# Toggle editing mode
func toggle_editing() -> void:
	if (is_editing):
		is_editing = false
		player.is_paused = false
		player.rotation = saved_player_rotation
	else:
		is_editing = true
		player.is_paused = true
		# Save and overwrite player rotation to stop snapping weirdness
		saved_player_rotation = player.rotation
		player.rotation = 0

# Input handling
func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and Input.is_action_just_released("select")):
		part_selected = null # Reset selection to nothing

# Signal grabber for part_selected signals
func _on_part_selected(part: ShipComponent) -> void:
	part_selected = part
