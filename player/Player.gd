extends CharacterBody2D
class_name Player

@onready var stat = $Stats
@onready var gun = $Gun
var lookdir := Vector2.ZERO
var movedir := Vector2.ZERO
const Speed = 100

func _ready():
	hide()
	set_physics_process(false)
	gun.set_state(gun.State.HELD_PLAYER)
	$AnimatedSprite2D.play()

func _physics_process(_delta):
	lookdir = Cursor.position - position
	gun.lookdir = self.lookdir
	movedir = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		).normalized()
	velocity = movedir * Speed
	#var collision = move_and_collide(velocity * delta)
	#if collision:
		#velocity = velocity.slide(collision.get_normal())
	move_and_slide()
	if velocity.x == 0 && velocity.y == 0:
		$AnimatedSprite2D.animation = "stand"
		$AnimatedSprite2D.speed_scale = 1
	else:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.speed_scale = 5
	$AnimatedSprite2D.flip_h = lookdir.x < 0

func _unhandled_input(event):
	if event.is_action_pressed("shoot"):
		gun.shoot(self)

#func handle_bullet(bullet, pos, direction, damage):
	#GlobalSignals.emit_signal("gun_shot", bullet, pos, direction, damage)
	
func handle_hit(_damage, _velocity):
	stat.health -= 1
