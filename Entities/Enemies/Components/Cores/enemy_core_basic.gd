extends EnemyComponent

func physics_process(delta: float) -> void:
	# Pursue the player
	var player = get_tree().get_current_scene().get_player()
	# Call superclass
	super(delta)
