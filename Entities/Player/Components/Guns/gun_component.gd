class_name GunComponent
extends PlayerComponent

@export var bullet_tscn: PackedScene
@export var cooldown_timer: Timer
@export var shoot_cooldown: float = 0.1

func process(delta: float) -> void:
	if (Input.is_action_pressed("shoot") and cooldown_timer.is_stopped()):
		cooldown_timer.start(shoot_cooldown)
		var bullet = bullet_tscn.instantiate()
		bullet.direction = Vector2.DOWN.rotated(get_parent().global_rotation)
		bullet.rotation = bullet.direction.angle()
		bullet.global_position = global_position
		get_tree().get_current_scene().add_child(bullet)
	# Call parent process
	super(delta)
