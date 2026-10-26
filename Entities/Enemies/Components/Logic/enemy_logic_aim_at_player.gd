extends EnemyLogicComponent

func _ready() -> void:
	print("Logic ready! " + str(self))

func process(delta: float) -> void:
	get_parent().look_at(get_tree().get_current_scene().get_player().global_position)
	get_parent().rotation_degrees -= 90 # TODO: magic number naughty naughty!
	super(delta)
