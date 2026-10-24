class_name Enemy
extends Node2D

@export var ship_core: EnemyComponent

@onready var components: Array[EnemyComponent] = []

# Game loop - just pass along to component code
func _physics_process(delta: float) -> void:
	for component in components:
		component.physics_process(delta)
func _process(delta: float) -> void:
	for component in components:
		component.process(delta)

# Add a new component to the enemy
func add_ship_component(new_component) -> void:
	add_child(new_component)
	components.append(new_component)
