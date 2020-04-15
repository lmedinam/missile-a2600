tool
extends Node

signal score_updated
signal level_color_updated

const COLORS := [
	{
		"enviroment": Color("#669044"),
		"background": Color("#2A39BC"),
		"detail": Color("#946B29"),
		"enemy": Color("#FC928C")
	},
	{
		"enviroment": Color("#784715"),
		"background": Color("#000000"),
		"detail": Color("#222A8F"),
		"enemy": Color("#D04D49")
	},
	{
		"enviroment": Color("#5F7C3C"),
		"background": Color("#000000"),
		"detail": Color("#20298E"),
		"enemy": Color("#A3DBAB")
	},
	{
		"enviroment": Color("#1E2986"),
		"background": Color("#000000"),
		"detail": Color("#789149"),
		"enemy": Color("#C66964")
	},
	{
		"enviroment": Color("#912E23"),
		"background": Color("#000000"),
		"detail": Color("#4957B5"),
		"enemy": Color("#D0D67A")
	}
]

const DEFAULT_POINTS = 50

var active_color: int = 0
var level_difficulty: int = 1

var main: Node
var level: Node

var score := 0

func _ready():
	# Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	main = get_node("/root/Main")
	level = main.get_node("ViewportContainer/Viewport/Level")

func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func get_color(name: String) -> Color:
	return COLORS[active_color][name]

func randomize_active_color() -> void:
	randomize()
	active_color = randi() % COLORS.size()
	emit_signal("level_color_updated")

func missiles_count() -> int:
	return 10

func smart_missiles_count() -> int:
	var count = level_difficulty-1
	return count if count <= 4 else 4

func planes_count() -> int:
	return smart_missiles_count()

func speed_multiplier() -> float:
	var temp_level = level_difficulty - 5
	
	if temp_level > 0:
		return 1.00 + (temp_level * 0.25)
	
	return 1.00

func level_up() -> void:
	if (level_difficulty-1) % 2:
		randomize_active_color()
	
	if level_difficulty < 8:
		level_difficulty += 1

func add_score(points):
	score += points
	emit_signal("score_updated", score)

func reset_score():
	score = 0
	emit_signal("score_updated", score)
