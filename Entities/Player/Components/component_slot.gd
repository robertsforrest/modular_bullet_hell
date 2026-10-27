class_name ComponentSlot
extends Node2D

# Component slot properties
@export var max_size: Enum.component_size # Maximum supported component size for the slot
@export var max_distance: float = 0.0 # Maximum supported distance for a connection - defaults to NONE
@export var max_connections: int = 1 # Maximum number of supported connections
@onready var connected_points: Array[ComponentSlot] = []
@export var conn_line: Line2D
@onready var connection_lines: Array[Line2D] = []

# Initialize
func _ready() -> void:
	# Prepare array for holding connections
	connected_points.resize(max_connections)
	# Generate necessary Line2Ds for connection points
	connection_lines.append(conn_line)
	if (max_connections > 1):
		for i in range(max_connections-1):
			print("Looping: " + str(i))
			connection_lines.append(conn_line.duplicate())
	print("Connection line graphics: " + str(connection_lines))

# Get the SHIP (NOT the ShipComponent) this slot belongs to
# TODO: we will NEED a better way to handle this! for now though, this should work, but
# ANY reorganization of parenting will royally FUCK this code
func get_parent_ship() -> Node2D:
	return get_parent().get_parent()

# Code for seeking compatible slots
# Hope you're hungry for a piping hot spaghetti, dear Christ
func seek_connections() -> void:
	for i in range(max_connections):
		connected_points.fill(null) # TODO: this seems like a huge waste of compute? but it do work lmao
		var closest_slot = null
		for slot in get_tree().get_nodes_in_group("component_slots"):
			# Check that the slot belongs to the same SHIP, but NOT the same ShipComponent,
			# AND verify that this slot is NOT YET in the connected_points array,
			# AND verify that the slot CAN HOLD a component of the size this is slotted into
			if (slot.get_parent_ship() == self.get_parent_ship() and slot.get_parent() != self.get_parent()
			and !self.connected_points.has(slot) and self.get_parent().component_size <= slot.max_size):
				# If no closest slot has yet been found, just grab this one as long as it's within range
				if (closest_slot == null):
					if (self.global_position.distance_to(slot.global_position) <= max_distance):
						closest_slot = slot
				# If a closest slot is already grabbed, check distance to the slot against current closest_slot
				else:
					if (self.global_position.distance_to(slot.global_position) < self.global_position.distance_to(closest_slot.global_position)):
						closest_slot = slot
		# With closest slot grabbed, set index in the array
		# If no slot was found, value will be overridden with the NULL from initialization in the loop
		#print("Adding closest slot: " + str(closest_slot) + " at index " + str(i))
		connected_points[i] = closest_slot
		#print(connected_points)

# Called to draw the Line2D connections for all currently connected points
func draw_connection_lines() -> void:
	#if (self.get_parent().name == 'Wing'):
	#	print("Drawing from: " + str(connected_points) + " in entity " + str(self.get_parent()))
	for i in range(max_connections):
		if (connected_points[i] == null):
			# If no connection is present in this slot, clear out the line graphics
			connection_lines[i].clear_points()
		else:
			# Draw a line to the connected point at this index
			# Base target - diff between target position and self position
			var targ_pos: Vector2 = connected_points[i].global_position-self.global_position
			# Apply parent scale to target position
			targ_pos.x *= sign(get_parent().scale.x)
			# Apply parent rotation to target position
			# Don't ask me how the fuck this one works
			targ_pos = targ_pos.rotated(-1*get_parent().scale.x*get_parent().rotation)
			# Draw the line
			connection_lines[i].points = [Vector2(0,0),targ_pos]

# Get all ShipComponents this point has connections to
func get_connected_components() -> Array[ShipComponent]:
	var comp: Array[ShipComponent] = []
	for point in connected_points:
		var add_comp = point.get_parent() # TODO: hard-coded get_parent() naughty naughty naughty!
		if (!comp.has(add_comp)):
			comp.append(add_comp)
	return comp
