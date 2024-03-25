extends CharacterBody2D
class_name Player

signal gun_shot(bullet, pos, direction, damage)

@onready var stat = $Stats
const Speed = 100

func _ready():
	$AnimatedSprite2D.play()

func _physics_process(delta):
	var movedir := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		).normalized()
	velocity = movedir * Speed
	move_and_collide(velocity * delta)
	if velocity.x == 0 && velocity.y == 0:
		$AnimatedSprite2D.animation = "stand"
		$AnimatedSprite2D.speed_scale = 1
	else:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.speed_scale = 5
	$AnimatedSprite2D.flip_h = get_node("../Cursor").global_position.x < position.x

func _unhandled_input(event):
	if event.is_action_pressed("shoot"):
		$Gun.shoot()

func handle_bullet(bullet, pos, direction, damage):
	emit_signal("gun_shot", bullet, pos, direction, damage)
	
func handle_hit():
	stat.health -= 1
