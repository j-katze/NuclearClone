extends CharacterBody2D

enum State{
	ALIVE,
	HURT,
	DEAD
}

@onready var ai = $AI
@onready var gun = $Gun
const speed = 70
var lookdir := Vector2(1, 0)
var knockback := Vector2.ZERO
var knockback_multiplier = 20
var health = 9
var state = State.ALIVE
var	movedir = Vector2.ZERO

func _ready():
		$AnimatedSprite2D.play()
		gun.set_state(gun.State.HELD_ENEMY)
		ai.initialize(self, gun)

func _physics_process(delta):
	if gun:
		gun.lookdir = self.lookdir
	velocity = (movedir * speed) + knockback 
	move_and_collide(velocity * delta)
	if state == State.ALIVE:
		if velocity.x == 0 && velocity.y == 0:
			$AnimatedSprite2D.animation = "idle"
			$AnimatedSprite2D.speed_scale = 1
		else:
			$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.speed_scale = 5
		$AnimatedSprite2D.flip_h = lookdir.x < 0
		if health <= 0:
			die()

func handle_bullet(bullet, pos, _direction, damage):
	GlobalSignals.emit_signal("gun_shot", bullet, pos, lookdir, damage)

func handle_hit(damage, bullet_velocity):
	#if state == State.ALIVE:
	state = State.HURT
	health -= damage
	knockback = bullet_velocity * knockback_multiplier
	$AnimatedSprite2D.animation = "hurt"
	$AnimatedSprite2D.speed_scale = 2
	await get_tree().create_timer(0.3).timeout
	knockback = Vector2.ZERO
	state = State.ALIVE

func die():
	state = State.DEAD
	ai.set_state(ai.State.DEAD)
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.animation = "dead"
	if gun:
		gun.despawn()
	gun = null
