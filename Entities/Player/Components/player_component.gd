class_name PlayerComponent
extends ShipComponent

# Wrappers for frame update code; rather than getting called from the engine, these get called
# from the engine update loops in the component's parent for more control over component code
# Copied here to pass super calls up to the ShipComponent parent for any shared behavior
func process(delta: float) -> void:
	super(delta)
func physics_process(delta: float) -> void:
	super(delta)

# Check for area_entered signal from player bullets
# TODO: add code when a part is destroyed to set it adrift in space as a simple Sprite node
func _on_area_entered(area: Area2D) -> void:
	if (area.is_in_group("enemy_bullets")):
		self.take_damage(area.get_damage_amount())
		area.queue_free()
