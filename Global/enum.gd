extends Node

enum component_size {
	ONE_WAY, # Special 0 size that only allows connections FROM the slot, not TO it
	SMALL,
	MEDIUM,
	LARGE,
}
