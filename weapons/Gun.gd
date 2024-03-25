extends Area2D

signal gun_shot(bullet, pos, direction)

@export var Bullet = preload("res://weapons/Bullet.tscn")
@onready var gun_hole = $GunHole
@onready var cooldown = $Cooldown
var damage = 3

func _ready():
	pass

func _process(_delta):
	if get_parent().name == "Player":
		look_at(get_node("../../Cursor").global_position)
	elif get_parent().name == "Frorg":
		look_at(global_transform.origin + get_parent().lookdir)
	$AnimatedSprite2D.flip_v = global_rotation_degrees < -90 || global_rotation_degrees > 90
	if global_rotation < 0:
		z_index = -1
	else:
		z_index = 1

func shoot():
	if cooldown.is_stopped():
		$AnimatedSprite2D.animation = "shoot"
		$AnimatedSprite2D.speed_scale = 3
		$AnimatedSprite2D.play()
		var bullet_instance = Bullet.instantiate()
		var target = get_node("../../Cursor").global_position
		var dir_to_mouse = gun_hole.global_position.direction_to(target).normalized()
		emit_signal("gun_shot", bullet_instance, gun_hole.global_position, dir_to_mouse, damage)
		cooldown.start()
		
func despawn():
	queue_free()
