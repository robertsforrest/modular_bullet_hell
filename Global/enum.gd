extends Node

enum inv_item_types {
	RESOURCE,
	COMPONENT,
}

enum component_size {
	ONE_WAY, # Special 0 size that only allows connections FROM the slot, not TO it
	SMALL,
	MEDIUM,
	LARGE,
}

enum asteroid_size {
	SMALL,
	MEDIUM,
	LARGE,
}

# Enumerates the types of logic nodes available to enemies
enum enemy_logic_types {
	AIM_AT_PLAYER,
	CHASE_PLAYER,
}
