class_name ComponentSprite
extends Sprite2D

@export var anim_player: AnimationPlayer
@onready var flash_warning: bool = false

func set_warning(do_warning: bool) -> void:
	flash_warning = do_warning
	if (flash_warning):
		anim_player.play("flash_warning")
	else:
		anim_player.play("RESET")
