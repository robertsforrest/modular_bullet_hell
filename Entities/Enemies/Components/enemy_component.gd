class_name EnemyComponent
extends ShipComponent

# Wrappers for frame update code; rather than getting called from the engine, these get called
# from the engine update loops in the component's parent for more control over component code
# Copied here to pass super calls up to the ShipComponent parent for any shared behavior
func process(delta: float) -> void:
	super(delta)
func physics_process(delta: float) -> void:
	super(delta)

# Check for area_entered signal from player bullets
func _on_area_entered(area: Area2D) -> void:
	if (area.is_in_group("player_bullets")):
		# TODO: add spark/damage/smoke/etc particles for visual juice
		hp -= area.get_damage_amount()
		# Check for death
		if (hp <= 0):
			part_destroyed.emit()
			queue_free() # TODO: juj this up with some cool VFX, drifting broken parts, etc.
		area.queue_free()
