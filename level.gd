extends Node2D
class_name Level

const Missile = preload("res://missile.tscn")
const SmartMissile = preload("res://smart_missile.tscn")
const PlaneEnemy = preload("res://plane.tscn")

var _objetives := []
var _cities := []
var _cities_old_state: Array

var player_bullet_stacks := 2
var player_bullets := 10

var missiles_available := 0
var planes_available := 0
var smarts_available := 0

var enemies_stock := []

var running = false
var game_over := false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	if OS.get_name() != "Android":
		$UI/Messages/Start.text = "Shoot to start"
		$Cursor.visible = true
	
	for objetive in get_tree().get_nodes_in_group("objetives"):
		if not objetive.is_in_group("cities"):
			_objetives.append(objetive.position)
		else:
			_objetives.append(objetive.get_parent().position + objetive.position)
			_cities.append(objetive)
			
			objetive.connect("destroyed", self, "_on_city_destroyed")
	
	$UI/Bullets.count(player_bullets)
	$UI/Stack.count(player_bullet_stacks)

func _input(event):
	if (event.is_action_pressed("ui_select") or event is InputEventScreenTouch)  and not running:
		running = true
		$Player.deactivated = false
		
		_clear_level()
		_start_game()

func _process(delta):
	$UI/Stack.modulate = LevelManager.get_color("background")
	
	if _any_smart_missle():
		SoundsManager.play_loop("smart_missile", -15.0)
	else:
		SoundsManager.stop_loop("smart_missile")

func _any_smart_missle() -> bool:
	for enemy in $Enemies.get_children():
		if enemy.is_in_group("smart_missiles"):
			return true
	
	return false

func reset_level() -> void:
	missiles_available = LevelManager.missiles_count()
	planes_available = LevelManager.planes_count()
	smarts_available = LevelManager.smart_missiles_count()
	
	if _cities_old_state:
		for i in range(0, _cities_old_state.size()):
			_cities[i].destroyed = _cities_old_state[i]
	
	for city in _cities:
		if city.destroyed:
			city.destroyed = false
			break
	
	_restock_enemies()

func _clear_level():
	player_bullet_stacks = 2
	player_bullets = 10
	enemies_stock = []
	
	$UI/Bullets.count(player_bullets)
	$UI/Stack.count(player_bullet_stacks)
	
	if LevelManager.level_difficulty > 1:
		LevelManager.randomize_active_color()
	
	LevelManager.level_difficulty = 1
	LevelManager.reset_score()
	
	
	for enemy in $Enemies.get_children():
		enemy.queue_free()
	
	_cities_old_state = []
	for city in _cities:
		city.destroyed = false
		_cities_old_state.append(city.destroyed)

func spawn_enemy() -> void:
	enemies_stock.shuffle()
	var enemy = enemies_stock.pop_back()
	if enemy:
		$Enemies.add_child(enemy)

func random_objetive() -> Vector2:
	return _objetives[randi() % _objetives.size()]

func _start_game():
	$UI/Messages/GameOver.visible = false
	$SpawnTick.start()
	
	$UI/Messages/Start.visible = false
	$UI/DefendTheCities.visible = false
	
	SoundsManager.play("game_start", -10.0)
	
	$StartGameDelay.start()

# Thanos end this game, but destroy all
func _end_game():
	$SpawnTick.stop()
	$Player.deactivated = true
	$ShowGameOverDelay.start()
	SoundsManager.play("game_over", 5.0)

func _on_enemy_destroyed():
	$AllDestroyedDelay.start()

func _clear_enemies():
	enemies_stock = []
	for enemy in $Enemies.get_children():
		enemy.destroy()

func _count_cities():
	_cities_old_state = []
	for city in _cities:
		_cities_old_state.append(city.destroyed)
	
	$CountCititesTick.start()

func _on_spawn_tick_timeout():
	if enemies_stock.size() <= 0 and $Enemies.get_child_count() <= 0:
		$Player.deactivated = true
		$SpawnTick.stop()
		$CountBulletsTick.start()
	
	spawn_enemy()

func _on_player_shoots():
	player_bullets -= 1
	_restock()

func _on_player_got_hit():
	player_bullets = 0
	_restock()

func _on_city_destroyed():
	var cities_left = 0
	
	for city in _cities:
		if not city.destroyed:
			cities_left += 1
	
	if not cities_left > 0:
		game_over = true
		_end_game()

func _restock():
	if player_bullets <= 0:
		if player_bullet_stacks <= 0:
			$Player.deactivated = true
		else:
			player_bullets = 10
		
		player_bullet_stacks -= 1
	
	$UI/Bullets.count(player_bullets)
	$UI/Stack.count(player_bullet_stacks)

func _restock_enemies():
	for i in range(0, missiles_available):
		var missile := Missile.instance()
		var spawn_position = Vector2(randi() % 284, 0)
		
		missile.position = spawn_position
		missile.direction = random_objetive()
		missile.speed = 22.0
		
		enemies_stock.push_front(missile)
	
	for i in range(0, planes_available):
		var plane := PlaneEnemy.instance()
		plane.position = Vector2(-16, 32)
		plane.objetives = _objetives
		enemies_stock.push_back(plane)
	
	for i in range(0, smarts_available):
		var smart := SmartMissile.instance()
		var spawn_position = Vector2(randi() % 284, 0)
		
		smart.position = spawn_position
		smart.direction = random_objetive()
		smart.speed = 22.0
		
		enemies_stock.push_front(smart)

func _on_Count_citites_tick_timeout():
	var cities_tmp := _cities
	cities_tmp.invert()
	
	for city in cities_tmp:
		if not city.destroyed:
			city.destroyed = true
			
			LevelManager.add_score(LevelManager.DEFAULT_POINTS)
			SoundsManager.play("bonus")
			
			return
	
	$CountCititesTick.stop()
	LevelManager.level_up()
	
	_start_game()

func _on_count_bullets_tick_timeout():
	if not player_bullets > 0:
		$CountBulletsTick.stop()
		_count_cities()
		return
	
	LevelManager.add_score(LevelManager.DEFAULT_POINTS)
	SoundsManager.play("bonus")
	player_bullets -= 1
	_restock()


func _on_show_game_over_delay_timeout():
	running = false
	$UI/Messages/GameOver.visible = true

func _on_start_game_delay_timeout():
	$Player.deactivated = false
	
	player_bullet_stacks = 2
	player_bullets = 10
	_restock()
	
	reset_level()
	
	spawn_enemy()
	spawn_enemy()
	spawn_enemy()
