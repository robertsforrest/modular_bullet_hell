class_name ComponentSlot
extends Node2D

# Component slot properties
@export var max_size: Enum.component_size # Maximum supported component size for the slot
@onready var component: ShipComponent # Maintain a reference to the slotted component; altered externally
