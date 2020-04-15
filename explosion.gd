extends Area2D

var _lifetime = 0
var _explode_smart_delay: int

func _ready():
	$AnimationPlayer.play("boom")
	$AnimationPlayer.connect("animation_finished", self, "_remove_explosion")
	
	_explode_smart_delay = $LifetimeTimer.wait_time

func _remove_explosion(anim_name: String) -> void:
	queue_free()

func _on_explosion_body_entered(body: Node):
	if not body.is_in_group("player_missiles"):
		if body.is_in_group("smart_missiles"):
			if _lifetime <= _explode_smart_delay:
				if body.has_method("destroy"):
					body.destroy()
					LevelManager.add_score(LevelManager.DEFAULT_POINTS)
			else:
				body.move_and_collide((body.position - position).normalized() * 1.5)
		else:
			if body.has_method("destroy"):
				body.destroy()
				LevelManager.add_score(LevelManager.DEFAULT_POINTS)


func _on_lifetime_timer_timeout():
	_lifetime += $LifetimeTimer.wait_time
