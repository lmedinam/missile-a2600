extends Control

var _texture_rect: TextureRect
var _container: HBoxContainer

func _ready():
	_container = $Container
	
	_texture_rect = TextureRect.new()
	_texture_rect.texture = load("res://stack.png")

# Show a number of stacks
func count(items: int) -> void:
	if items < 0:
		return
	
	var child_count := _container.get_child_count()
	
	if items > child_count:
		for i in range(0, items - child_count):
			_container.add_child(_texture_rect.duplicate())
	elif items < child_count:
		for i in range(0, child_count - items):
			var last_child = _container.get_child(get_child_count() - 1)
			_container.remove_child(last_child)
			last_child.queue_free()
