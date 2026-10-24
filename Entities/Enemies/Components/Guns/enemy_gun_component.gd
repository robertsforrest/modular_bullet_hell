class_name EnemyGunComponent
extends EnemyComponent

@export var bullet_tscn: PackedScene
@export var cooldown_timer: Timer
@export var shoot_cooldown: float = 1.0

func process(delta: float) -> void:
	# TODO: add more robust behaviors than just automatically shooting whenever cooldown
	# is off? On the other hand it is a bullet hell not a nothing heaven
	if (cooldown_timer.is_stopped()):
		cooldown_timer.start(shoot_cooldown)
		var bullet = bullet_tscn.instantiate()
		bullet.direction = Vector2.DOWN.rotated(get_parent().global_rotation)
		bullet.global_position = global_position
		get_tree().get_current_scene().add_child(bullet)
	super(delta)
