extends CharacterBody2D

signal gun_shot(bullet, pos, direction)

const speed = 100
var lookdir := Vector2(1, 0)
var health = 9

func _ready():
		$AnimatedSprite2D.play()

func _physics_process(delta):
	#var movedir := Vector2(
		#Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		#Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		#).normalized()
	var movedir = Vector2(0, 0)
	velocity = movedir * speed 
	move_and_collide(velocity * delta)
	if velocity.x == 0 && velocity.y == 0:
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.speed_scale = 1
	else:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.speed_scale = 5
	$AnimatedSprite2D.flip_h = lookdir.x < 0

func handle_bullet(bullet, pos, direction, damage):
	emit_signal("gun_shot", bullet, pos, direction, damage)

func handle_hit(damage):
	health -= damage
	#set_process(false)
	$AnimatedSprite2D.animation = "hurt"
	$AnimatedSprite2D.speed_scale = 2
	#knockback()
	#await get_tree().create_timer(0.5).timeout
	if health <= 0:
		die()
	else:
		set_process(true)

#func knockback():
	

func die():
	set_physics_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
	$Gun.despawn()
	$AnimatedSprite2D.animation = "dead"
