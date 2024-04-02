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
@onready var chase_radius = $ChaseRadius
@onready var flee_radius = $FleeRadius

@export var accuracy = 45

var state = State.IDLE: set = set_state
var actor = null
var player:Player = null
var gun:Gun = null
var panic = Vector2.ZERO
var shot_count = 0
var player_angle
var aim_angle

func _process(_delta):
	if player:
		player_angle = actor.global_position.direction_to(player.global_position)
		aim_angle = actor.global_position.direction_to(player.global_position + (player.movedir * accuracy))
		actor.lookdir = actor.lookdir.lerp(aim_angle, 0.3).normalized()
	match state:
		State.IDLE:
			pass
		State.ENGAGE:
			if $AttackTimer.is_stopped():
				$AttackTimer.start(randf_range(1, 10))
			if $MoveTimer.is_stopped():
				$MoveTimer.start(randf_range(1, 2))
			if player != null && gun != null:
				if flee_radius.overlaps_body(player):
					actor.movedir = actor.movedir.lerp((player_angle * -1) + panic, 0.1)
				elif !chase_radius.overlaps_body(player) || randi() % 100 < 30:
					actor.movedir = actor.movedir.lerp(player_angle + panic, 0.1)
				else:
					actor.movedir = actor.movedir.lerp(panic, 0.1)
			else:
				print("enemy in attack state but target or gun missing")
		State.ATTACK:
			actor.movedir = Vector2.ZERO
			gun.shoot(null)
			if shot_count >= 3:
				shot_count = 0
				set_state(State.ENGAGE)
		State.HURT:
			if shot_count:
				shot_count = 0
		State.DEAD:
			actor.movedir = Vector2.ZERO
			set_process(false)
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
	if state == State.IDLE && body.is_in_group("player"):
		set_state(State.ENGAGE)
		player = body
		actor.alert.show()
		await get_tree().create_timer(1).timeout
		actor.alert.hide()
	if state == State.ENGAGE && body.is_in_group("enemies")  && body.ai.state == body.ai.State.IDLE:
		body.ai._on_detection_area_body_entered(player)

func _on_attack_timer_timeout():
	if state != State.DEAD:
		state = State.ATTACK

func _on_gun_gun_shot():
	shot_count += 1

func _on_move_timer_timeout():
	panic = Vector2(randf_range(-1, 1), randf_range(-1, 1))
