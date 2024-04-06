extends Area2D
class_name Gun

signal gun_shot()
signal state_changed(new)

enum State{
	HELD_PLAYER,
	HELD_ENEMY,
	DROPPED
}

@export var damage = 3
@export var spread = 3
@export var reload_time = 0.13
@export var bullet_amount = 1
@export var PlayerBullet = preload("res://weapons/Bullet.tscn")
@export var EnemyBullet = preload("res://weapons/EnemyBullet.tscn")

@onready var gun_hole = $GunHole
@onready var cooldown = $Cooldown
var lookdir = Vector2(1, 0)
var state = State.DROPPED: set = set_state

func _ready():
	pass

func _process(_delta):
	var behind_wall
	look_at(global_transform.origin + lookdir)
	$AnimatedSprite2D.flip_v = global_rotation_degrees < -90 || global_rotation_degrees > 90
	for body in get_overlapping_bodies():
			behind_wall = body.is_in_group("wall")
	if global_rotation < 0 || state == State.DROPPED || (behind_wall && global_rotation_degrees < 120 && global_rotation_degrees > 60):
		z_index = get_parent().z_index
	else:
		z_index = get_parent().z_index + 1
	match state:
		State.HELD_ENEMY:
			reload_time = 0.2

func shoot(body):
	var bullet_instance
	var aim_dir
	if cooldown.is_stopped():
		$AnimatedSprite2D.animation = "shoot"
		$AnimatedSprite2D.speed_scale = 3
		$AnimatedSprite2D.play()
		match state:
			State.HELD_PLAYER:
				bullet_instance = PlayerBullet.instantiate()
				bullet_instance.shooter = body
				var target = Cursor.global_position
				aim_dir = gun_hole.global_position.direction_to(target).normalized()
			State.HELD_ENEMY:
				bullet_instance = EnemyBullet.instantiate()
				aim_dir = lookdir
		emit_signal("gun_shot")
		GlobalSignals.emit_signal("gun_shot", bullet_instance, gun_hole.global_position, aim_dir, damage)
		cooldown.start(reload_time)

func set_state(new_state):
	if new_state == state:
		return
	state = new_state
	emit_signal("state_changed", state)
	
func despawn():
	queue_free()
