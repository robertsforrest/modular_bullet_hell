class_name ShipComponent
extends Area2D

# Signals
signal part_destroyed(part: ShipComponent)

# Editor variables
@export var hp: float = 1.0
@export var connection_points: Array[ComponentSlot]
@export var component_size: Enum.component_size
@export var collision_shape: CollisionShape2D

# Initialize
func _ready() -> void:
	self.area_entered.connect(_on_area_entered)

# Accessor for sprite's h_flip value
func set_flip_h(val: bool):
	self.scale.x = -1.0

# Wrappers for frame update code; rather than getting called from the engine, these get called
# from the engine update loops in the component's parent for more control over component code
func process(delta: float) -> void:
	pass
func physics_process(delta: float) -> void:
	pass

# Adds a new component to this one at the specified connection point
# Takes conn_point_index as an index into the connection_points array - is there a better way?
# Returns a pointer to the component
func add_component(new_component: ShipComponent, conn_point_index: int) -> ShipComponent:
	# Check to ensure the component is of the right size to add to the slot
	if (new_component.component_size <= connection_points[conn_point_index].max_size):
		# Parent the new component to this component's own parent
		get_parent().add_ship_component(new_component)
		# Set the new component's position based on the connection point
		# NOTE: this is a core design decision - sprite position relative to the origin of the node
		# will determine the connection point for the new component & the origin of flip_h, where applicable
		# Multiply scale to apply negative offset to left-side placements
		new_component.position = self.position + Vector2(connection_points[conn_point_index].position.x * self.scale.x,
			connection_points[conn_point_index].position.y * self.scale.y)
		# Set hflip on new component based on relative positioning
		if (new_component.position.x < self.position.x):
			new_component.set_flip_h(true)
		return new_component
	# Addition failed - indicate w/ return value
	else:
		print("Component too large!: " + str(new_component))
		return null

# Handle area entered code; override in child nodes
func _on_area_entered(area: Area2D) -> void:
	pass
