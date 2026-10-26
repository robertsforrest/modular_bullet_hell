class_name ShipComponent
extends Area2D

# Signals
signal part_destroyed(part: ShipComponent)
signal part_selected(part: ShipComponent)

# Editor variables
@export var hp: float = 1.0
@export var connection_points: Array[ComponentSlot]
@export var component_size: Enum.component_size
@export var collision_shape: CollisionShape2D

# Internal variables
@onready var mouse_over: bool = false

# Initialize
func _ready() -> void:
	self.area_entered.connect(_on_area_entered)
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)

# Accessor for sprite's h_flip value
func set_flip_h(val: bool) -> void:
	self.scale.x = -1.0
func toggle_flip_h() -> void:
	self.scale.x *= -1

# Handle input events to check for mouse-click in editor mode
func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and Input.is_action_just_pressed("select") and mouse_over):
		get_viewport().set_input_as_handled() # Halt the input event on the first instance of this code executing
		part_selected.emit(self) # Signal part selection for player_ship_edit.gd handling
		print("Clicked: " + str(self))

# Wrappers for frame update code; rather than getting called from the engine, these get called
# from the engine update loops in the component's parent for more control over component code
func process(delta: float) -> void:
	pass
func physics_process(delta: float) -> void:
	pass

# Destroy this component; called from HP checks in child types
func get_destroyed() -> void:
	# Emit destruction signal
	part_destroyed.emit(self)
	# Propagate destruction to child components
	for connection_point in connection_points:
		if (connection_point.component != null):
			connection_point.component.get_destroyed()
	# Remove from the scene treeu
	queue_free()

# Seeks valid connection points for this component to latch on to
# This is O^3 lmao - there must be a better way to do this
func seek_connections() -> void:
	for slot in connection_points:
		slot.seek_connections()

# Check whether this component is connected to another part of the ship
func is_part_connected() -> bool:
	for slot in connection_points:
		if (slot.has_valid_connection()):
			return true
	# Default - no success encountered, return false
	return false

# Handle area entered code; override in child nodes
func _on_area_entered(area: Area2D) -> void:
	pass

# Handle mouse over w/ connected signals
func _on_mouse_entered() -> void:
	mouse_over = true
func _on_mouse_exited() -> void:
	mouse_over = false
