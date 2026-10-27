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

# Wrappers for frame update code; rather than getting called from the engine, these get called
# from the engine update loops in the component's parent for more control over component code
func process(delta: float) -> void:
	pass
func physics_process(delta: float) -> void:
	pass

# Called from the editor to run modular update logic on component slots
func run_slots_for_editor() -> void:
	for slot in connection_points:
		slot.seek_connections()
		slot.draw_connection_lines()

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

# Handle area entered code; override in child nodes
func _on_area_entered(area: Area2D) -> void:
	pass

# Handle input events for player ship component click'n'drag
# TODO: add more checks here to ensure shit isn't grabbed erroneously in combat
func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and Input.is_action_just_pressed("select") and mouse_over):
		get_viewport().set_input_as_handled() # Stop input signal from propagating to overlapping parts
		part_selected.emit(self) # Signal part selection to the editor node

# Handle mouse-over for player parts in the editor
func _on_mouse_entered() -> void:
	mouse_over = true
func _on_mouse_exited() -> void:
	mouse_over = false
