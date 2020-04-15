extends KinematicBody2D

signal destroyed

var speed: float = 33.0
var direction: Vector2

func _process(delta: float):
	move_and_collide((direction - position).normalized() * speed * delta)

func destroy():
	emit_signal("destroyed")
	queue_free()
