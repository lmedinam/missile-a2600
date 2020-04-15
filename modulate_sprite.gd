tool
extends Sprite
class_name ModulateSprite

const MODULATE_COLORS = [
	Color("#AF431D"),
	Color("#77D178"),
	Color("#474400"),
	Color("#000000"),
	Color("#4350BF"),
	Color("#9653CB"),
	Color("#A72F26")
]

export(String, "Enviroment", "Background", "Detail", "Enemy") var modulate_color := "Enviroment"
export(bool) var random := false
export(float) var random_tick := 0.05

func _ready() -> void:
	if random:
		var timer = Timer.new()
		timer.connect("timeout", self, "_random_tick")
		timer.wait_time = random_tick
		timer.start()
		
		_random_tick()
		add_child(timer)

# warning-ignore:unused_argument
func _process(delta: float) -> void:
	if not random:
		modulate = LevelManager.get_color(modulate_color.to_lower())

func _random_tick():
	modulate = MODULATE_COLORS[randi() % MODULATE_COLORS.size()]
