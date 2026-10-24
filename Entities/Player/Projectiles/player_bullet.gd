class_name PlayerBullet
extends Area2D

@onready var direction: Vector2
@export var speed: float = 3400.0
@export var base_damage: float = 1.0

func _physics_process(delta: float) -> void:
	rotation = direction.angle()
	position += direction * speed * delta

# Accessor for bullet damage; apply relevant modifiers here
func get_damage_amount() -> float:
	return base_damage
