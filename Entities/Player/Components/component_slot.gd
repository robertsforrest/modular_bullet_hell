class_name ComponentSlot
extends Node2D

# Component slot properties
@export var max_size: Enum.component_size
@export var conn_line: Line2D
@export var max_conn_dist: float = 30.0

# Check whether this slot has found a valid connection point onto another component
func has_valid_connection() -> bool:
	return (!conn_line.points.is_empty()) # TODO: is this too hacky? it works so who gaf

# Link this to another slot on another component
func set_connected_slot(conn_slot: ComponentSlot) -> void:
	conn_line.global_rotation_degrees = 0 # Set ONLY in here, NOT in gameplay loop
	var target_point = (conn_slot.global_position-global_position)*Vector2(1,get_parent().scale.x)
	conn_line.points = [Vector2(0,0), target_point]

# Seeks nearest connection point
func seek_connections() -> void:
	var slot_found: bool = false
	for conn_point in get_tree().get_nodes_in_group("component_slots"):
		if (conn_point.get_parent().is_in_group("player_components") and conn_point.get_parent() != get_parent()):
			# Valid point: check distance
			if (conn_point.global_position.distance_to(global_position) <= max_conn_dist
				and conn_point.max_size >= get_parent().component_size):
					set_connected_slot(conn_point)
					slot_found = true
	# No slots detected - get rid of the connection line altogether
	if (!slot_found):
		conn_line.clear_points()
