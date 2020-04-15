extends Node2D

func _process(delta: float):
	var aim = get_viewport().get_mouse_position() / OS.window_size * Vector2(284, 160)
	position = aim