class_name Inventory
extends Node2D

# Inventory is managed as a 2D array, with every element following the pattern [item: Resource, amount: int]
@onready var inventory: Array[Array] = []
@onready var money: float = 100.0 # Track money seperately as a static counter

# The maximum amount of stuff that can go into the inventory
@export var max_cargo_space: float = 100.0

# Add an item to the inventory
# Returns a boolean value indicating success or failure
func add_item(item: InventoryItem, amount: int) -> bool:
	var added: bool = false
	# Check if the inventory has space
	if (get_cargo_amount() + (item.cargo_space * amount) <= max_cargo_space):
		# Iterate to see if the item is already in the inventory
		for i in range(inventory.size()):
			if (inventory[i][0] == item):
				inventory[i][1] += amount
				added = true
		# If this item is not in the inventory, append it to the end
		# TODO: check max slots? Might be overkill in conjunction with the load limit
		if (!added):
			inventory.append([item, amount])
			added = true
	# Debug - output the inventory to the console
	print(inventory)
	# Indicate success/failure
	return added

# Remove an item from the inventory
# Returns a boolean indicating success or failure; i.e. whether amount of item was found in inventory
func remove_item(item: InventoryItem, amount: int) -> bool:
	var removed: bool = false
	for i in range(inventory.size()):
		if (inventory[i][0] == item and inventory[i][1] >= amount):
			inventory[i][1] -= amount
			removed = true
			# TODO: if amount gets set to 0, remove from array? Could just keep as placeholder idk
	return removed

# Get the total amount of cargo in the inventory
func get_cargo_amount() -> float:
	var total_amt: float = 0.0
	for item in inventory:
		total_amt += item[0].cargo_space * item[1]
	return total_amt
