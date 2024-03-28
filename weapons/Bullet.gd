extends Area2D

@export var speed = 3
var direction := Vector2.ZERO
var velocity := Vector2.ZERO
var damage = 0
var shooter = null

func _ready():
	$AnimatedSprite2D.play()
	$AnimatedSprite2D.speed_scale = 4
	$AnimatedSprite2D.flip_h = randi_range(0, 1)
	$Timeout.start()

func _physics_process(_delta):
	if direction != Vector2.ZERO:
		look_at(global_transform.origin + direction)
		velocity = direction * speed
		position += velocity

func _on_timeout_timeout():
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.handle_hit(damage, velocity, shooter)
		queue_free()

func set_direction(dir):
	direction = dir

func set_damage(dmg):
	damage = dmg
	
