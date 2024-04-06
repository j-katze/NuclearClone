extends Camera2D

@onready var player = $"/root/World/Ground/Player"

func get_camera_rect() -> Rect2:
	var pos = get_screen_center_position() # Camera's center
	var half_size = get_viewport_rect().size * 0.5
	return Rect2(pos - half_size, pos + half_size)

func _process(_delta):
	var cursor_relative = Cursor.position - player.position
	position = position.lerp(player.position + cursor_relative / 4, 0.5)


func _on_player_player_shot(lookdir):
	pass
