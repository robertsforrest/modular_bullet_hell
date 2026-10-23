class_name PlayerBullet
extends Area2D

@onready var direction: Vector2
@export var speed: float = 3400.0

func _physics_process(delta: float) -> void:
	rotation = direction.angle()
	position += direction * speed * delta
