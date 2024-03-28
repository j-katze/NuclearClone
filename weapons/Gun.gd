extends Area2D
class_name Gun

signal gun_shot(bullet, pos, direction, damage)
signal state_changed(new)

enum State{
	HELD_PLAYER,
	HELD_ENEMY,
	DROPPED
}

@export var PlayerBullet = preload("res://weapons/Bullet.tscn")
@export var EnemyBullet = preload("res://weapons/EnemyBullet.tscn")
@onready var gun_hole = $GunHole
@onready var cooldown = $Cooldown
var cooldown_time = 0
var lookdir = Vector2(1, 0)
var state = State.DROPPED: set = set_state

func _ready():
	pass

func _process(_delta):
	look_at(global_transform.origin + lookdir)
	$AnimatedSprite2D.flip_v = global_rotation_degrees < -90 || global_rotation_degrees > 90
	if global_rotation < 0 || state == State.DROPPED:
		z_index = -1
	else:
		z_index = 1
	match state:
		State.HELD_PLAYER:
			cooldown_time = 0.13
		State.HELD_ENEMY:
			cooldown_time = 0.2
		

func shoot(body):
	var bullet_instance
	var aim_dir
	var damage
	if cooldown.is_stopped():
		$AnimatedSprite2D.animation = "shoot"
		$AnimatedSprite2D.speed_scale = 3
		$AnimatedSprite2D.play()
		match state:
			State.HELD_PLAYER:
				bullet_instance = PlayerBullet.instantiate()
				bullet_instance.shooter = body
				var target = get_node("../../../Cursor").global_position
				aim_dir = gun_hole.global_position.direction_to(target).normalized()
				damage = 3
			State.HELD_ENEMY:
				bullet_instance = EnemyBullet.instantiate()
				aim_dir = lookdir
				damage = 1
		emit_signal("gun_shot", bullet_instance, gun_hole.global_position, aim_dir, damage)
		cooldown.start(cooldown_time)

func set_state(new_state):
	if new_state == state:
		return
	state = new_state
	emit_signal("state_changed", state)
	
func despawn():
	queue_free()
