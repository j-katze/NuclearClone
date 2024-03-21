extends Area2D

@export var speed = 400
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movedir = Vector2.ZERO
	#var velocity = Vector2.ZERO
	movedir.y = - Input.get_action_strength("move_up") + Input.get_action_strength("move_down")
	movedir.x = - Input.get_action_strength("move_left") + Input.get_action_strength("move_right")
	var velocity = movedir.limit_length(1) * speed 
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	if velocity.x == 0 && velocity.y == 0:
		$AnimatedSprite2D.animation = "stand"
	elif velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "walk"
