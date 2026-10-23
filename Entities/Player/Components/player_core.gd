extends ShipComponent

const component_wing: PackedScene = preload("res://Entities/Player/Components/Wing.tscn")
const component_thruster: PackedScene = preload("res://Entities/Player/Components/Thruster.tscn")
const component_machine_gun: PackedScene = preload("res://Entities/Player/Components/MachineGun.tscn")

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("debug_1")):
		print("Adding test components!")
		var wing_left: ShipComponent = add_component(component_wing.instantiate(), 0)
		var wing_right: ShipComponent = add_component(component_wing.instantiate(), 1)
		var thrust_left: ShipComponent = wing_left.add_component(component_thruster.instantiate(), 0)
		var thrust_right: ShipComponent = wing_right.add_component(component_thruster.instantiate(), 0)
		var mg_left: ShipComponent = wing_left.add_component(component_machine_gun.instantiate(), 1)
		var mg_right: ShipComponent = wing_right.add_component(component_machine_gun.instantiate(), 1)
