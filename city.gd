extends Area2D
class_name City

signal destroyed

var destroyed := false

func _process(delta: float) -> void:
	$Sprite.frame = 0 if not destroyed else 1

func _on_city_body_entered(body: Node):
	if body.is_in_group("enemies") and not body.is_in_group("player_missiles"):
		if body.has_method("destroy"):
			body.destroy()
		
		if not destroyed:
			destroyed = true
			emit_signal("destroyed")
