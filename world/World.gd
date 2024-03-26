extends Node

@onready var bullet_manager = $BulletManager
@onready var player = get_node("TileMap/Player")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	#GlobalSignals.gun_shot.connect(handle_bullet)

func _process(_delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()

#func handle_bullet(bullet, pos, direction, damage):
	#emit_signal("gun_shot", bullet, pos, direction, damage)
