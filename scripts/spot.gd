extends Node2D

signal used

@export var dialogue := ""
@export var reach := 80.0
@export var texture: Texture2D
@export var height := 90.0


func _ready() -> void:
	add_to_group("spot")
	var sprite := get_node_or_null("Sprite2D") as Sprite2D
	if sprite and texture:
		var k := height / texture.get_height()
		sprite.texture = texture
		sprite.scale = Vector2(k, k)
		sprite.offset = Vector2(0, -texture.get_height() / 2.0)


func usable() -> bool:
	return is_visible_in_tree()


func use() -> void:
	used.emit()
