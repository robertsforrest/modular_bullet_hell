extends Node2D

# Editor variables
@export var ship_core: ShipComponent

# Gameplay variables
@export var max_speed: float = 800.0
@export var move_speed: float = 300.0
@export var accel_spd: float = 600.0
@export var max_accel: float = 1000.0
@export var max_velocity: float = 1500.0
@onready var velocity: Vector2 = Vector2.ZERO
@onready var accel: Vector2 = Vector2.ZERO
@export var components: Array[ShipComponent] = [] # TODO: this should be programmatic, not exposed to the editor

# Internal variables
@onready var is_paused: bool = false

# Gameplay loop
# Hard-coded pause variable in player allows movement to be halted without
# interrupting processing on child ShipComponents in the ship editor
func _physics_process(delta: float) -> void:
	if (!is_paused):
		# Look towards mouse position
		look_at(get_global_mouse_position())
		rotation_degrees -= 90 # Offset to point straight - TODO: magic number naughty naughty!
		do_movement_with_accel(delta)
		#do_movement_no_accel(delta)
		
func _process(delta: float) -> void:
	if (!is_paused):
		for component in components:
			component.process(delta)

# Try movement w/ no fancy accel - thrusters just influence max speed
func do_movement_no_accel(delta: float) -> void:
	velocity = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized() * move_speed
	for component in components:
		component.physics_process(delta)
	velocity = velocity.limit_length(max_velocity)
	position += velocity * delta
	
# Wrap this in a specialty function for prototyping
func do_movement_with_accel(delta: float) -> void:
	# Parse movement input
	accel = Vector2.ZERO
	accel.x = Input.get_axis("move_left", "move_right")
	accel.y = Input.get_axis("move_up", "move_down")
	accel = accel.normalized() * accel_spd
	# Call physics update in component nodes
	for component in components:
		component.physics_process(delta)
	# Apply acceleration to velocity
	accel = accel.limit_length(max_accel)
	if (accel == Vector2.ZERO):
		pass # TODO: add damping here?
	velocity += accel * delta
	# Apply velocity to position
	velocity = velocity.limit_length(max_velocity)
	position += velocity * delta

# Add a new component to the player
func add_ship_component(new_component) -> void:
	add_child(new_component)
	components.append(new_component)
