extends KinematicBody2D
class_name PlaneEnemy

signal destroyed

const Missile := preload("res://missile.tscn")

var _level 

var speed := 22.0
var sprite_width: float
var objetives: Array

func _ready():
	_level = LevelManager.level
	sprite_width = $ModulateSprite.get_rect().size.x

func _process(delta: float):
	if position.x > 284 + sprite_width:
		print(only_planes_on_level())
		if _level.enemies_stock.size() <= 0 and only_planes_on_level():
			destroy()
		else:
			position = Vector2(0 - sprite_width, position.y)
	
	move_and_collide(Vector2(1, 0) * speed * delta)

func _on_shoot_tick_timeout():
	randomize()
	if (randi() % 101) < 25:
		shoot()

func only_planes_on_level() -> bool:
	for enemy in _level.get_node("Enemies").get_children():
		if not enemy as PlaneEnemy:
			if not enemy.get("from_plane"):
				return false
		
	return true

func shoot():
	var missile := Missile.instance()
	
	missile.position = position + $Canon.position
	missile.direction = random_objetive()
	missile.speed = 22.0
	missile.from_plane = true
	
	get_parent().add_child(missile)

func random_objetive() -> Vector2:
	return objetives[randi() % objetives.size()]

func destroy():
	emit_signal("destroyed")
	queue_free()
