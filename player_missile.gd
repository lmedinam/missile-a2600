extends "res://missile.gd"

const Explosion = preload("res://explosion.tscn")

# Never will have a exact destroy at position, so we need a margin
const DESTROY_MARGIN := 4.0

# Where the missile should explote
var destroy_at: Vector2

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if position.distance_to(destroy_at) < DESTROY_MARGIN:
		explode()

func explode() -> void:
	var explosion := Explosion.instance()
	explosion.position = destroy_at
	
	SoundsManager.play("player_missile_explosion", -15.0)
	
	get_parent().add_child(explosion)
	queue_free()

func destroy():
	queue_free()