extends Control

var _bullets := []

func _ready():
	for line in $Container.get_children():
		for bullet in line.get_children():
			bullet.modulate = LevelManager.get_color("background")
			_bullets.push_back(bullet)
	
	LevelManager.connect("level_color_updated", self, "_draw_all")

func count(count: int) -> void:
	_draw_all()
	if count < _bullets.size():
		for i in range(count, _bullets.size()):
			_bullets[i].modulate = ColorN("white", 0.0)

func _draw_all() -> void:
	for bullet in _bullets:
		bullet.modulate = LevelManager.get_color("background")
