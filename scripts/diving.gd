extends CanvasLayer

signal finished

const BUBBLE := preload("res://scenes/bubble.tscn")
const NEEDED := 10
const START := Vector2(70, 60)
const GOAL := Vector2(360, 270)

var pops := 0
var spawn_time := 0.5
var done := false
var move: Tween

@onready var diver: Sprite2D = $Diver
@onready var key_icon: Sprite2D = $Key
@onready var label: Label = $Label
@onready var bubbles: Node2D = $Bubbles


func _process(delta: float) -> void:
	if done:
		return
	spawn_time -= delta
	if spawn_time <= 0.0:
		spawn_time = randf_range(0.35, 0.8)
		var b = BUBBLE.instantiate()
		b.position = Vector2(randf_range(30.0, 450.0), 385.0)
		bubbles.add_child(b)
	for b in bubbles.get_children():
		if b.position.y < -20.0:
			b.queue_free()


func _input(event: InputEvent) -> void:
	var m := event as InputEventMouseButton
	if done or m == null or not m.pressed or m.button_index != MOUSE_BUTTON_LEFT:
		return
	for b in bubbles.get_children():
		if b.position.distance_to(m.position) < 24.0:
			pop(b)
			break


func pop(b: Node2D) -> void:
	b.queue_free()
	Sound.sfx("pop")
	pops += 1
	label.text = "Click the bubbles to dive!  %d/%d" % [pops, NEEDED]
	if move:
		move.kill()
	move = create_tween()
	move.tween_property(diver, "position", START.lerp(GOAL, float(pops) / NEEDED), 0.5)
	if pops >= NEEDED:
		done = true
		for r in bubbles.get_children():
			r.queue_free()
		await move.finished
		finished.emit()
