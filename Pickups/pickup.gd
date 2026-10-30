extends Area2D

# Editor variables
@export var inv_item: InventoryItem
@export var item_amount: int = 1
@export var direction: Vector2 = Vector2.RIGHT
@export var move_spd: float = 0.0 # Default behavior - no movement

# Internal variables
@onready var grabbed: bool = false # Used to avoid double-pickup scenarios with overlapping components

# Initialize
func _ready() -> void:
	area_entered.connect(_on_area_entered)

# Game loop
func _physics_process(delta: float) -> void:
	position += direction * move_spd * delta

# Area entered: check for pickup from player
func _on_area_entered(area: Area2D) -> void:
	if (area is PlayerComponent and !grabbed):
		var is_success = area.get_parent().inventory.add_item(inv_item, item_amount)
		# Get rid of the pickup on successful inventory addition
		if (is_success):
			grabbed = true
			queue_free()
