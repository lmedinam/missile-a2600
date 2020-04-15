extends Node

var resources := {
	"bonus": "res://bonus.ogg",
	"player_missile_explosion": "res://player_missile_explosion.ogg",
	"player_missile_launch": "res://player_missile_launch.ogg",
	"game_over": "res://game_over.ogg",
	"game_start": "res://game_start.ogg"
}

var loop_resources := {
	"smart_missile": "res://smart_missile.ogg"
}

var loops: Dictionary

func _ready() -> void:
	loops = {}
	
	for res_k in loop_resources:
		var player := AudioStreamPlayer.new()
		player.stream = load(loop_resources[res_k])
		loops[res_k] = player
		LevelManager.main.call_deferred("add_child", player)

func play_loop(res_name: String, volume_db = 0) -> void:
	var player = loops[res_name]

	player.volume_db = volume_db
	
	if not player.playing:
		player.play()

func stop_loop(res_name: String) -> void:
	loops[res_name].stop()

func play(resource_name, volume_db = 0) -> void:
	var stream = load(resources[resource_name])
	stream.set_loop(false)
	
	var player: AudioStreamPlayer = AudioStreamPlayer.new()
	player.connect("finished", self, "_remove_player", [player])
	player.volume_db = volume_db
	player.stream = stream
	player.play(0.0)
	
	LevelManager.main.call_deferred("add_child", player)

func _remove_player(node: Node) -> void:
	LevelManager.main.call_deferred("remove_child", node)
	node.queue_free()
