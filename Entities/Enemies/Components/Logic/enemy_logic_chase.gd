extends EnemyLogicComponent

# The enemy will pursue the player to this distance and then apply reverse thrust
@onready var target_distance: float = 300.0

# TODO: lots of get_parent() calls in this bad boy - maybe add an initialized with a pointer
# to component's parent in the superclass to keep it in a variable instead?
func physics_process(delta: float) -> void:
	# Snag a reference to the player for processing
	var player = get_tree().get_current_scene().get_player()
	var targ_direction: Vector2 = get_parent().global_position.direction_to(player.global_position)
	# Reverse thrust when the player is within target_distance
	if (get_parent().global_position.distance_to(player.global_position) <= target_distance):
		targ_direction *= -1
	get_parent().accel = targ_direction.normalized() * get_parent().accel_spd
