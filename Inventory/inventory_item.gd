class_name InventoryItem
extends Resource

# Item properties
@export var item_type: Enum.inv_item_types
@export var item_scene: PackedScene
@export var item_name: String
@export var cargo_space: float = 1.0
@export var buy_price: float = 0.0
@export var sell_price: float = 0.0
