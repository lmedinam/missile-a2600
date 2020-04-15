extends KinematicBody2D

signal destroyed

export(Vector2) var direction := Vector2()
export(float) var speed := 1.0

var initial_position
var from_plane = false

func _ready():
	initial_position = position
	$Line2D.modulate = LevelManager.get_color("enemy")

func _process(delta: float):
	$Line2D.set_point_position(0, initial_position - position)
	move_and_collide((direction - position).normalized() * speed * delta)

func destroy():
	emit_signal("destroyed")
	queue_free()
