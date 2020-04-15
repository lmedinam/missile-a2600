extends Control

func _ready():
	LevelManager.connect("score_updated", self, "_on_update_score")

func _process(delta):
	$Container/Label.modulate = LevelManager.get_color("enviroment")
	$Background.modulate = LevelManager.get_color("background")

func _on_update_score(score: int) -> void:
	$Container/Label.text =  String(score)
