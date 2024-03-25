extends Node2D

@export var health = 8: set = set_health

func set_health(new):
	health = clamp(new, 0, 8)
