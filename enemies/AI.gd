extends Node2D

signal state_changed(new)

enum State{
	IDLE,
	ENGAGE,
	ATTACK,
	HURT,
	DEAD
}

@onready var detection_area = $DetectionArea
var state = State.IDLE: set = set_state
var actor = null
var player:Player = null
var gun:Gun = null
var panic = Vector2.ZERO
var shot_count = 0

func _process(_delta):
	match state:
		State.IDLE:
			pass
		State.ENGAGE:
			if $AttackTimer.is_stopped():
				$AttackTimer.start(randf_range(1, 4))
			if $MoveTimer.is_stopped():
				$MoveTimer.start(randf_range(1, 2))
			if player != null && gun != null:
				var player_angle = actor.global_position.direction_to(player.global_position)
				var aim_angle = actor.global_position.direction_to(player.global_position + (player.movedir * 55))
				actor.lookdir = actor.lookdir.lerp(aim_angle, 0.1)
				if detection_area.overlaps_body(player):
					actor.movedir = actor.movedir.lerp((player_angle * -1) + panic, 0.1)
				else:
					actor.movedir = actor.movedir.lerp(player_angle + panic, 0.1)
			else:
				print("enemy in attack state but target or gun missing")
		State.ATTACK:
			actor.movedir = Vector2.ZERO
			gun.shoot()
			if shot_count >= 3:
				shot_count = 0
				set_state(State.ENGAGE)
		State.HURT:
			pass
		State.DEAD:
			actor.movedir = Vector2.ZERO
		_:
			print("ERROR: enemy ai state missing")

func initialize(new_actor, new_gun:Gun):
	actor = new_actor
	gun = new_gun

func set_state(new):
	if new == state:
		return
	state = new
	emit_signal("state_changed", state)

func _on_detection_area_body_entered(body):
	if body.is_in_group("player") && state != State.DEAD:
		set_state(State.ENGAGE)
		player = body


func _on_attack_timer_timeout():
	if state != State.DEAD:
		state = State.ATTACK


func _on_gun_gun_shot(_bullet, _pos, _direction, _damage):
	shot_count += 1


func _on_move_timer_timeout():
	panic = Vector2(randf_range(-1, 1), randf_range(-1, 1))
