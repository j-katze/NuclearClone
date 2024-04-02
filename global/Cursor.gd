extends Area2D

enum InputMode{
	MOUSE,
	CONTROLLER
}

@onready var player = $"/root/World/Ground/Player"
var distance = 100
var lookdir := Vector2.ZERO
var last_dir := Vector2(1, 0)
var input_mode = InputMode.CONTROLLER
var screen_size := Vector2.ZERO
var camera_pos := Vector2.ZERO
var bounds_start := Vector2.ZERO
var bounds_end := Vector2.ZERO

func _ready():
	pass

func _mouse_input():
	screen_size = get_viewport_rect().size
	camera_pos = $"/root/World/Camera".get_screen_center_position()
	bounds_start = (camera_pos - screen_size / 2) + Vector2(2, 2)
	bounds_end= (camera_pos + screen_size / 2) - Vector2(2, 2)
	position = get_global_mouse_position()
	position = position.clamp(bounds_start, bounds_end)

func _controller_input():
	lookdir = Vector2(
		Input.get_action_strength("look_right_controller") - Input.get_action_strength("look_left_controller"),
		Input.get_action_strength("look_down_controller") - Input.get_action_strength("look_up_controller")
		)
	if lookdir.length() < 0.55:
		lookdir = last_dir.limit_length(0.55)
		position = position.lerp(player.position + (lookdir.limit_length(1) * distance), 0.1)
	else:
		position = player.position + (lookdir.limit_length(1) * distance)
	
	last_dir = lookdir

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	match input_mode:
		InputMode.MOUSE:
			_mouse_input()
		InputMode.CONTROLLER:
			_controller_input()

func _input(event):
	if event is InputEventMouse or event is InputEventKey:
		input_mode = InputMode.MOUSE
	elif event is InputEventJoypadButton or (event is InputEventJoypadMotion and event.axis_value > 0.5):
		input_mode = InputMode.CONTROLLER
	else:
		pass
