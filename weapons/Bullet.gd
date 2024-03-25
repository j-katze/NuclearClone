extends Area2D

@export var speed = 3
var direction := Vector2.ZERO
var damage = 0

func _ready():
	$Timeout.start()

func _physics_process(_delta):
	if direction != Vector2.ZERO:
		look_at(global_transform.origin + direction)
		var velocity = direction * speed
		position += velocity

func _on_timeout_timeout():
	queue_free()

func _on_body_entered(body):
	if body.has_method("handle_hit"):
		body.handle_hit(damage)
	queue_free()

func set_direction(dir):
	direction = dir

func set_damage(dmg):
	damage = dmg
	
