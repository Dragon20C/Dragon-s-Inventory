extends Button
class_name Slot

@export var item_rect : TextureRect
@export var stack_label : Label
var held_item : ItemResource
var stack : int = 0:
	set(value):
		stack = value
		stack_label.text = str(stack) if stack > 1 else ""

func set_held_item(item : ItemResource) -> void:
	held_item = item
	stack = 1
	item_rect.texture = held_item.item_texture
	stack_label.text = str(stack) if stack > 1 else ""
	

func clear_data() -> void:
	held_item = null
	item_rect.texture = null
	stack_label.text = ""
