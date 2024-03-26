extends Area2D

var distance = 100
var lookdir := Vector2.ZERO
var last_dir := Vector2(1, 0)
var input_mode = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#lookdir.x = 1

func _mouse_input():
	if (Input.is_action_pressed("look_down_controller") || Input.is_action_pressed("look_up_controller")
		|| Input.is_action_pressed("look_right_controller") || Input.is_action_pressed("look_left_controller")): 
		input_mode = 1;
	position = get_global_mouse_position()

func _controller_input():
	if Input.get_last_mouse_velocity() > Vector2.ZERO:
		input_mode = 0
	lookdir = Vector2(
		Input.get_action_strength("look_right_controller") - Input.get_action_strength("look_left_controller"),
		Input.get_action_strength("look_down_controller") - Input.get_action_strength("look_up_controller")
		)
	if lookdir.length() < 0.55:
		lookdir = last_dir.limit_length(0.55)
	position = get_node("../TileMap/Player").position + (lookdir.limit_length(1) * distance)
	last_dir = lookdir

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if input_mode:
		_controller_input()
	else:
		_mouse_input()
