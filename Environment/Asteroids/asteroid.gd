extends Area2D

const asteroid_tscn: PackedScene = preload("res://Environment/Asteroids/Asteroid.tscn")
const asteroid_textures: Dictionary = {
	Enum.asteroid_size.SMALL: preload("res://Environment/Assets/asteroid_small.png"),
	Enum.asteroid_size.MEDIUM: preload("res://Environment/Assets/asteroid_medium.png"),
	Enum.asteroid_size.LARGE: preload("res://Environment/Assets/asteroid_large.png"),
}
const collision_radius: Dictionary = {
	Enum.asteroid_size.SMALL: 12.0,
	Enum.asteroid_size.MEDIUM: 20.0,
	Enum.asteroid_size.LARGE: 36.0,
}
const hp_amounts: Dictionary = {
	Enum.asteroid_size.SMALL: 2,
	Enum.asteroid_size.MEDIUM: 4,
	Enum.asteroid_size.LARGE: 6,
}

# Editor variables
@export var sprite: Sprite2D
@export var collision_shape: CollisionShape2D
@export var hp: float = 10.0
@export var size: Enum.asteroid_size
@export var direction: Vector2 = Vector2.RIGHT
@export var move_spd: float = 50.0
@export var num_chunks: int = 3

# Initialize
func _ready() -> void:
	self.sprite.set_texture(asteroid_textures[self.size])
	self.collision_shape.shape.radius = collision_radius[self.size]
	self.hp = hp_amounts[self.size]

# Game loop
func _physics_process(delta: float) -> void:
	# Drift through space
	position += direction.normalized() * move_spd * delta

# Check for collisions with other Area2D nodes
func _on_area_entered(area: Area2D) -> void:
	# Check for bullet hits
	if (area.is_in_group("enemy_bullets") or area.is_in_group("player_bullets")):
		hp -= area.get_damage_amount()
		# Check for death
		if (hp <= 0):
			get_destroyed()
		area.queue_free()
	# Check for collisions with an entity
	elif (area.get_parent().is_in_group("enemies") or area.get_parent().name == "Player"):
		var hit_entity = area.get_parent() # Get the relevant entity containing the collided component
		# Apply some damage to the component
		area.take_damage(1.0) # TODO: magic number naughty naughty!
		hit_entity.velocity = hit_entity.velocity.bounce(self.global_position.direction_to(area.global_position))
		self.direction = self.direction.bounce(area.global_position.direction_to(self.global_position))

# Called when the asteroid gets killed
func get_destroyed() -> void:
	# Small asteroids just get yoinked, simple as
	if (size == Enum.asteroid_size.SMALL):
		queue_free()
	else:
		# Break up into chunks with varying directions & speeds
		for i in range(num_chunks):
			var new_asteroid = asteroid_tscn.instantiate()
			new_asteroid.global_position = self.global_position
			new_asteroid.size = self.size - 1 # Decrement size of chunks
			new_asteroid.move_spd = randf_range(30.0, 60.0) # TODO: magic number naughty naughty!
			new_asteroid.direction = Vector2.from_angle(deg_to_rad(randf_range(0,360)))
			get_tree().get_current_scene().add_child(new_asteroid)
		queue_free()
