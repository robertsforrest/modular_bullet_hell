extends Node2D

# Editor variables
@export var ship_core: ShipComponent

# Gameplay variables
@export var max_speed: float = 800.0
@export var accel_spd: float = 200.0
@export var max_accel: float = 800.0
@export var max_velocity: float = 1200.0
@onready var velocity: Vector2 = Vector2.ZERO
@onready var accel: Vector2 = Vector2.ZERO
@onready var components: Array[ShipComponent] = []

# Gameplay loop
func _physics_process(delta: float) -> void:
	# Look towards mouse position
	look_at(get_global_mouse_position())
	rotation_degrees -= 90 # Offset to point straight - TODO: magic number naughty naughty!
	# Parse mouse input
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
func add_component(new_component) -> void:
	add_child(new_component)
	components.append(new_component)
