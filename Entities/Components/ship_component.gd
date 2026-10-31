class_name ShipComponent
extends Area2D

# Signals
signal part_destroyed(part: ShipComponent)
signal part_selected(part: ShipComponent)

# Editor variables
@export var hp: float = 1.0
@onready var max_hp = hp
@export var connection_points: Array[ComponentSlot]
@export var component_size: Enum.component_size
@export var collision_shape: CollisionShape2D
@export var sprite: ComponentSprite
@export var inv_item_path: String

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

# Call this to apply damage to the component; will handle defenses,
# particle effects, death checks, etc.
func take_damage(amount: float) -> void:
	hp -= amount # For now just take flat damage
	# Check for death
	if (hp <= 0):
		get_destroyed()

# Destroy this component; called from HP checks in child types
func get_destroyed() -> void:
	# Emit destruction signal
	part_destroyed.emit(self)
	# Clear out line graphics (but this shouldn't be necessary??)
	for slot in connection_points:
		for line in slot.connection_lines:
			line.clear_points()
	# Remove from the scene tree
	queue_free()

# Handle area entered code; override in child nodes
func _on_area_entered(area: Area2D) -> void:
	pass

# Recursively parses all node connections to determine whether a path exists from
# this node to the ship's core; used for detecting orphaned parts in combat to break
# them off from the ship and to validate player ship designs in the editor
# Takes an array of components to exclude from the recursive search as an argument; this defaults to
# nothing for the initial call but gets expanded as we recurse down the nodes to avoid circular
# recursion logic where a part is connected to another part by more than one anchor node
# TODO: This does have a miss case - if a component is GRABBED BY (not ATTACHED TO) another component
# that IS connected to the core, but this part cannot reciprocate the connection (due to a shorter max_distance)
# it will be considered orphaned! This is going to be enough of a pain in the dick I'm willing to put it down
# for the time being for further prototyping of the actual gameplay before I get further into the weeds on this shit
func is_connected_to_core(exclude: Array[ShipComponent] = []) -> bool:
	if (is_in_group("ship_cores")):
		return true
	else:
		# Add this node to the exclusions for recursion
		exclude.append(self)
		var recurse_components = get_all_connected_components()
		# Filter out the exclusion list from the recursion tree
		recurse_components = recurse_components.filter(func(comp): return !exclude.has(comp))
		for component in recurse_components:
			if (component.is_connected_to_core(exclude)):
				return true
	# Base return case to allow stack to unwind after attacking all possible paths
	return false

# Get all other components connected to ANY component slot on this part
func get_all_connected_components() -> Array[ShipComponent]:
	var all_components: Array[ShipComponent] = []
	for slot in connection_points:
		for component in slot.get_connected_components():
			if (!all_components.has(component)):
				all_components.append(component)
	return all_components

# Handle input events for player ship component click'n'drag
# TODO: add more checks here to ensure shit isn't grabbed erroneously in combat
func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and Input.is_action_just_pressed("select") and mouse_over
	# NOTE: pause mode is hard-coded here since control nodes will operate on components differently when the game is paused
		and get_tree().paused == false):
			get_viewport().set_input_as_handled() # Stop input signal from propagating to overlapping parts
			part_selected.emit(self) # Signal part selection to the editor node

# Handle mouse-over for player parts in the editor
func _on_mouse_entered() -> void:
	mouse_over = true
	print("Mouse over part: " + str(self))
func _on_mouse_exited() -> void:
	print("Mouse not over part: " + str(self))
	mouse_over = false
