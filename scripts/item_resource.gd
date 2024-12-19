extends Resource
class_name ItemResource

enum item_types {Tool,Weapon,Consumable}

@export var item_name : String
@export var item_texture : Texture2D
@export var item_type : Array[item_types]
@export_multiline var item_description : String
@export var stackable : bool = true
@export var max_stackable : int = 64
