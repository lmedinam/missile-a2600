extends Area2D

signal got_hit
signal shoots

const PlayerMissile = preload("res://player_missile.tscn")

var deactivated = true
var can_shoot = true

func _input(event: InputEvent):
	if event.is_action_pressed("ui_select"):
		shoot()

func shoot():
	if not deactivated and can_shoot:
		can_shoot = false
		
		var missile := PlayerMissile.instance()
	
		missile.position = position
		missile.direction = aim()
		missile.speed = 66.0
		missile.destroy_at = aim()
		
		$RateDelay.start()
		
		SoundsManager.play("player_missile_launch")
		
		get_parent().add_child(missile)
		emit_signal("shoots")

func aim() -> Vector2:
	return get_viewport().get_mouse_position() / OS.window_size * Vector2(284, 160)

func _on_player_body_entered(body: Node):
	if not body.is_in_group("player_missiles"):
		if body.has_method("destroy"):
			body.destroy()
		
		emit_signal("got_hit")

func _on_rate_delay_timeout():
	can_shoot = true
