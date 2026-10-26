extends ShipComponent

@export var accel_spd: float = 200.0

func physics_process(delta: float) -> void:
	var add_accel: Vector2 = Vector2.ZERO
	# Add additional thrust to the parent based on input vectors
	add_accel.x = Input.get_axis("move_left", "move_right")
	add_accel.y += Input.get_axis("move_up", "move_down")
	add_accel = add_accel.normalized() * accel_spd
	get_parent().accel += add_accel
	# Call superclass physics_process
	super(delta)
