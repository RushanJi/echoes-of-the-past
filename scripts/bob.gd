extends Sprite2D

@export var amplitude := 2.0
@export var speed := 3.0

var base_y := 0.0
var time := randf() * TAU


func _process(delta: float) -> void:
	time += delta
	position.y = base_y + sin(time * speed) * amplitude
