extends CharacterBody2D

enum State{
	ALIVE,
	HURT,
	DEAD
}

@onready var ai = $AI
@onready var gun = $Gun
@onready var sprite = $AnimatedSprite2D
@onready var alert = $Sprite2D

const speed = 60
var lookdir := Vector2(1 * -randi()%2, 0)
var health = 9
var state = State.ALIVE
var	movedir = Vector2.ZERO
var knockback := Vector2.ZERO
var knockback_multiplier = 20

func _ready():
		alert.hide()
		sprite.animation = "idle"
		sprite.play()
		sprite.frame = randi()%11
		gun.set_state(gun.State.HELD_ENEMY)
		ai.initialize(self, gun)
		ai.set_state(ai.State.IDLE)

func _physics_process(_delta):
	if gun:
		gun.lookdir = self.lookdir
	velocity = (movedir * speed) + knockback 
	move_and_slide()
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

func handle_hit(damage, bullet_velocity, shooter):
	ai._on_detection_area_body_entered(shooter)
	state = State.HURT
	ai.state = ai.State.HURT
	health -= damage
	knockback = bullet_velocity * knockback_multiplier
	sprite.animation = "hurt"
	sprite.speed_scale = 2
	$StunTimer.start(0.2)
	await $StunTimer.timeout
	knockback = Vector2.ZERO
	state = State.ALIVE
	ai.state = ai.State.ENGAGE

func die():
	velocity = velocity.lerp(Vector2.ZERO, 0.5)
	state = State.DEAD
	ai.set_state(ai.State.DEAD)
	sprite.animation = "dead"
	if gun:
		gun.despawn()
	gun = null
	await $StunTimer.timeout
	$CollisionShape2D.set_deferred("disabled", true)
	set_physics_process(false)
