extends Control
class_name InventoryManager

@export var inventory : Array[ItemResource]
@export var draggable : Sprite2D
@onready var slot : PackedScene = preload("res://scenes/inventory/slot.tscn")
@export var inventory_container : GridContainer
@export var hotbar_container : HBoxContainer
@export var slots_amount_h : int = 8
@export var slots_amount_v : int = 6
var dragged_item : ItemResource
var dragged_stack : int = 0
var slots : Array[Slot]

func _ready() -> void:
	generate_slots()
	load_inventory()

func _process(delta: float) -> void:
	on_drag()

func generate_slots() -> void:
	## HotBar
	for a in range(slots_amount_h):
		var _slot : Slot = slot.instantiate()
		hotbar_container.add_child(_slot)
		_slot.pressed.connect(handle_slot_pressed.bind(_slot))
		slots.append(_slot)
	## Inventory
	for a in range(slots_amount_h):
		for b in range(slots_amount_v):
			var _slot : Slot = slot.instantiate()
			inventory_container.add_child(_slot)
			_slot.pressed.connect(handle_slot_pressed.bind(_slot))
			slots.append(_slot)

func load_inventory() -> void:
	## Go through the whole inventory and add it to the slots
	for item in inventory:
		add_item(item)

func add_item(item : ItemResource) -> bool:
	## Add items together if it exists
	for slot in slots:
		if not item.stackable:
			continue
		if slot.held_item == null:
			continue
		if slot.held_item.item_name != item.item_name:
			continue
		if slot.stack < slot.held_item.max_stackable:
			slot.stack += 1
			return true
	## Add item to the inventory if there is space
	for slot in slots:
		if slot.held_item == null:
			spawn_item(item,slot)
			return true
	return false

## Adds the item into the slot
func spawn_item(item : ItemResource,slot : Slot) -> void:
	var new_item : ItemResource = item.duplicate()
	slot.set_held_item(new_item)

## When a button is pressed we handle that press and decide what to do with it
func handle_slot_pressed(slot : Slot) -> void:
	if slot.held_item != null and dragged_item == null:
		on_drag_start(slot)
	elif slot.held_item == null and dragged_item != null:
		on_drag_end(slot)
	elif slot.held_item != null and dragged_item != null:
		if slot.held_item.item_name == dragged_item.item_name:
			combine_item(slot)
		else:
			swap_draggable(slot)


func on_drag_start(slot : Slot) -> void:
	dragged_item = slot.held_item
	dragged_stack = slot.stack
	slot.clear_data()
	set_draggable_texture(true,dragged_item.item_texture)

func on_drag() -> void:
	if draggable.visible:
		draggable.global_position = get_global_mouse_position()

func on_drag_end(slot : Slot) -> void:
	slot.set_held_item(dragged_item)
	slot.stack = dragged_stack
	dragged_item = null
	dragged_stack = 0
	set_draggable_texture(false)

func combine_item(slot : Slot) -> void:
	if not slot.held_item.stackable:
		return
	elif slot.stack < slot.held_item.max_stackable:
		slot.stack += 1
		dragged_item = null
		set_draggable_texture(false)

func swap_draggable(slot : Slot) -> void:
	## Temp save the slot item and stack
	var slot_item : ItemResource = slot.held_item
	var slot_stack : int = slot.stack
	## Drop the currently dragged item
	on_drag_end(slot)
	## Set the temp save into the draggable
	dragged_item = slot_item
	dragged_stack = slot_stack
	## Show the draggable
	set_draggable_texture(true,dragged_item.item_texture)

func set_draggable_texture(show : bool,_texture : Texture2D = null) -> void:
	draggable.texture = _texture
	draggable.visible = true
