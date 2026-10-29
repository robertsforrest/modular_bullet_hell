extends Node

# Load enemy configurations
const enemy_base: Array[PackedScene] = [
	preload("res://Entities/Enemies/Bases/EnemyBasicA.tscn"),
	preload("res://Entities/Enemies/Bases/EnemyBasicB.tscn"),
	preload("res://Entities/Enemies/Bases/EnemyTankA.tscn"),
	preload("res://Entities/Enemies/Bases/EnemyTankB.tscn"),
]
# Load enemy logic types
const enemy_logic: Dictionary = {
	Enum.enemy_logic_types.AIM_AT_PLAYER: preload("res://Entities/Enemies/Components/Logic/EnemyLogicAimAtPlayer.tscn"),
	Enum.enemy_logic_types.CHASE_PLAYER: preload("res://Entities/Enemies/Components/Logic/EnemyLogicChase.tscn",)
}

# Create and return a random enemy
# TODO: add parameterization eventually rather than purely random enemies
func generate_enemy() -> Node2D:
	var new_enemy = enemy_base[3].instantiate()
	new_enemy.add_logic_component(enemy_logic[Enum.enemy_logic_types.AIM_AT_PLAYER].instantiate())
	new_enemy.add_logic_component(enemy_logic[Enum.enemy_logic_types.CHASE_PLAYER].instantiate())
	return new_enemy
