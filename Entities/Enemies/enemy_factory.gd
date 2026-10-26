extends Node

# Load enemy configurations
const enemy_tscn: PackedScene = preload("res://Entities/Enemies/Enemy.tscn")
const enemy_core: PackedScene = preload("res://Entities/Enemies/Components/Cores/EnemyCoreBasic.tscn")
const enemy_wings: PackedScene = preload("res://Entities/Enemies/Components/Wings/EnemyWing1.tscn")
const enemy_gun: PackedScene = preload("res://Entities/Enemies/Components/Guns/EnemyLaserGun.tscn")
const enemy_logic_aim: PackedScene = preload("res://Entities/Enemies/Components/Logic/EnemyLogicAimAtPlayer.tscn")
const enemy_logic_chase: PackedScene = preload("res://Entities/Enemies/Components/Logic/EnemyLogicChase.tscn")

# Create and return a random enemy
# TODO: add parameterization eventually rather than purely random enemies
func generate_enemy() -> Node2D:
	var new_enemy = enemy_tscn.instantiate()
	var new_core = enemy_core.instantiate()
	new_enemy.add_child(new_core)
	new_enemy.ship_core = new_core
	var wing_left = new_core.add_component(enemy_wings.instantiate(), 0)
	var wing_right = new_core.add_component(enemy_wings.instantiate(), 1)
	wing_right.add_component(enemy_gun.instantiate(), 1)
	wing_left.add_component(enemy_gun.instantiate(), 1)
	new_enemy.add_logic_component(enemy_logic_aim.instantiate())
	new_enemy.add_logic_component(enemy_logic_chase.instantiate())
	return new_enemy
