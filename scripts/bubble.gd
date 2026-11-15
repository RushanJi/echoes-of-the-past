extends Sprite2D

var speed := 40.0


func _ready() -> void:
	speed = randf_range(25.0, 55.0)


func _process(delta: float) -> void:
	position += Vector2(sin(position.y * 0.05) * 0.3, -speed * delta)
