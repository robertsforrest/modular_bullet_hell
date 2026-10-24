class_name Enemy
extends Node2D

# Editor nodes
@export var ship_core: EnemyComponent

# Components
@onready var components: Array[EnemyComponent]
@onready var logic_components: Array[EnemyLogicComponent]

# Gameplay variables
@onready var accel: Vector2 = Vector2.ZERO
@onready var velocity: Vector2 = Vector2.ZERO
@onready var accel_spd: float = 500.0
@onready var max_accel: float = 100.0
@onready var max_velocity: float = 400.0

# Game loop - just pass along to component code
func _physics_process(delta: float) -> void:
	# Physical components
	for component in components:
		component.physics_process(delta)
	# Logic components
	for logic_component in logic_components:
		logic_component.physics_process(delta)
	# Apply physics
	velocity += accel * delta
	velocity = velocity.limit_length(max_velocity)
	position += velocity * delta

func _process(delta: float) -> void:
	# Physical components
	for component in components:
		component.process(delta)
	# Logic components
	for logic_component in logic_components:
		logic_component.process(delta)

# Add a new component to the enemy
func add_ship_component(new_component: EnemyComponent) -> void:
	add_child(new_component)
	new_component.part_destroyed.connect(_on_part_destroyed)
	components.append(new_component)

# Add a new logic component to the enemy
func add_logic_component(new_component) -> void:
	add_child(new_component)
	logic_components.append(new_component)

# Hande part_destroyed signal from components
func _on_part_destroyed(part: EnemyComponent) -> void:
	print("Part destroyed: " + str(part))
	# Check whether the core has been destroyed
	if (part == ship_core):
		queue_free()
	else:
		components.erase(part)
