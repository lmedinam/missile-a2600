extends Node

var resources = {
	"city_bonus": "res://city_bonus.ogg",
	"player_missile_bonus": "res://player_missile_bonus.ogg",
	"player_missile_explosion": "res://player_missile_explosion.ogg",
	"player_missile_launch": "res://player_missile_launch.ogg"
}

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
