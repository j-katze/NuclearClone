extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var cursor_relative = get_node("../Cursor").position - get_node("../Player").position
	position = get_node("../Player").position + cursor_relative / 3
	#position = get_node("../Player").position
