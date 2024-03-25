extends Node

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	
func _process(_delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()
