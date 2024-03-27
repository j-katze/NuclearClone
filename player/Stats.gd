extends Node2D

@export var health = 8: set = set_health
@export var ammo = 30: set = set_ammo

func set_health(new):
	health = clamp(new, 0, 8)
	
func set_ammo(new):
	ammo = clamp(new, 0, 100)
