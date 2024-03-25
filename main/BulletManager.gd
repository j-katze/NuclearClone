extends Node2D

func _ready():
	pass # Replace with function body.

func _process(_delta):
	pass

func handle_bullet(bullet, pos, direction, damage):
	add_child(bullet)
	bullet.global_position = pos
	bullet.set_direction(direction)
	bullet.set_damage(damage)
	bullet.z_index = 2
