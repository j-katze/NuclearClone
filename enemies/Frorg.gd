extends CharacterBody2D

enum State{
	ALIVE,
	HURT,
	DEAD,
	BARK
}

@onready var ai = $AI
@onready var gun = $Gun
@onready var sprite = $AnimatedSprite2D
const speed = 60
var lookdir := Vector2(1 * -randi()%2, 0)
var health = 9
var state = State.ALIVE
var	movedir = Vector2.ZERO
var knockback := Vector2.ZERO
var knockback_multiplier = 20

func _ready():
		sprite.play()
		sprite.frame = randi()%11
		gun.set_state(gun.State.HELD_ENEMY)
		ai.initialize(self, gun)

func _physics_process(delta):
	if gun:
		gun.lookdir = self.lookdir
	velocity = (movedir * speed) + knockback 
	move_and_collide(velocity * delta)
	if state == State.ALIVE:
		if velocity.x == 0 && velocity.y == 0:
			sprite.animation = "idle"
			sprite.speed_scale = 1
		else:
			sprite.animation = "walk"
			sprite.speed_scale = 5
		sprite.flip_h = lookdir.x < 0
		if health <= 0:
			die()

func handle_bullet(bullet, pos, _direction, damage):
	GlobalSignals.emit_signal("gun_shot", bullet, pos, lookdir, damage)

func handle_hit(damage, bullet_velocity, shooter):
	ai._on_detection_area_body_entered(shooter)
	state = State.HURT
	health -= damage
	knockback = bullet_velocity * knockback_multiplier
	sprite.animation = "hurt"
	sprite.speed_scale = 2
	$StunTimer.start(0.3)
	await $StunTimer.timeout
	knockback = Vector2.ZERO
	state = State.ALIVE

func die():
	state = State.DEAD
	ai.set_state(ai.State.DEAD)
	$CollisionShape2D.set_deferred("disabled", true)
	sprite.animation = "dead"
	if gun:
		gun.despawn()
	gun = null
	set_physics_process(false)
