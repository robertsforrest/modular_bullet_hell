extends Control

# Editor nodes
@export var cost_label: Label

# Gameplay variables
@export var cost_per_point_repaired: float = 10.0

# Internal variables
@onready var player: Node2D # Snag a player to reparent and work on
@onready var component_mouse_over: ShipComponent = null # Tracks the currently hovered ShipComponent from a loop

# Handle inputs
func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and Input.is_action_just_pressed("select")):
		print("Input event in repair screen yippee!")
		if (component_mouse_over != null):
			if (can_afford_repair(component_mouse_over)):
				player.inventory.money -= get_repair_cost(component_mouse_over)
				component_mouse_over.hp = component_mouse_over.max_hp
				set_damage_indicators()

# Game loop
func _process(delta: float) -> void:
	# Update the cost label around the mouse
	cost_label.global_position = get_global_mouse_position()
	cost_label.visible = false
	component_mouse_over = null
	for component in player.components:
		if (component.mouse_over and component.hp < component.max_hp):
			# Track this component for input handling
			component_mouse_over = component
			print("Mouse over: " + str(component_mouse_over))
			# Calculate repair cost
			var repair_cost = get_repair_cost(component)
			#print("Repair " + str(component) + " for $" + str(repair_cost))
			cost_label.set_text("$" + str(repair_cost))
			cost_label.visible = true
			# Highlight red if this repair is too expensive for the player to afford
			if (repair_cost > player.inventory.money):
				cost_label.add_theme_color_override("font_color", Color.DARK_RED)
			else:
				cost_label.add_theme_color_override("font_color", Color.FOREST_GREEN)
			# Break loop to avoid issues with overlapping components;
			# TODO: make this order less arbitrary in the future?
			break

# Called when closing the screen; resets properties as needed
func screen_closed() -> void:
	player.reparent(get_tree().get_current_scene()) # Add player back to Main
	# Reset damage indicators
	for component in player.components:
		component.sprite.set_warning(false)

# Determines whether the player can afford to repair the specified ShipComponent
func can_afford_repair(component: ShipComponent) -> bool:
	return (get_repair_cost(component) <= player.inventory.money)

# Determines the cost of repairing a component
func get_repair_cost(component: ShipComponent) -> float:
	return (component.max_hp - component.hp) * cost_per_point_repaired

# Sets components sprites to indicate damage as needed
func set_damage_indicators() -> void:
	for component in player.components:
		if (component.hp < component.max_hp):
			component.sprite.set_warning(true)
		else:
			component.sprite.set_warning(false)

# Initialize properties when this tab is selected
func set_active_tab() -> void:
	print("Repair tab selected!")
	player.ship_core.take_damage(5)
	player.components[0].take_damage(1)
	set_damage_indicators()
	player.rotation = 0
	# Reparent the player to this node for repair logic
	player.reparent(self)
	player.position = Vector2(0,0)
	print(player.get_parent())
