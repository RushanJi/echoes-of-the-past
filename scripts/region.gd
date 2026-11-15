extends Node2D

const PAST_SHADER := preload("res://shaders/past.gdshader")
const D := preload("res://scripts/dialogue.gd")

@export var music := ""
@export var allow_time := true

var main
var entry := "default"
var past_material := ShaderMaterial.new()

@onready var map: Sprite2D = $Map
@onready var player = $Player
@onready var present: Node2D = $Present
@onready var past: Node2D = $Past


func _ready() -> void:
	past_material.shader = PAST_SHADER
	player.global_position = get_node("SpawnExit" if entry == "exit" else "Spawn").global_position
	var half := map.texture.get_size() * map.scale / 2.0
	player.camera.limit_left = int(-half.x)
	player.camera.limit_top = int(-half.y)
	player.camera.limit_right = int(half.x)
	player.camera.limit_bottom = int(half.y)
	player.camera.make_current()
	player.camera.reset_smoothing()
	for s in get_tree().get_nodes_in_group("spot"):
		if is_ancestor_of(s) and s.dialogue != "":
			s.used.connect(talk.bind(s.dialogue))
	setup()
	apply_time()


func setup() -> void:
	pass


func begin() -> void:
	pass


func respawn() -> void:
	player.global_position = $Spawn.global_position
	player.camera.reset_smoothing()


func talk(id: String) -> void:
	var d: Array = D.LINES[id]
	await main.hud.say(d[0], d[1])


func apply_time() -> void:
	var is_past := Game.is_past()
	map.material = past_material if is_past else null
	toggle(present, not is_past)
	toggle(past, is_past)


func toggle(n: Node2D, on: bool) -> void:
	n.visible = on
	for c in n.find_children("*", "CollisionPolygon2D", true, false):
		c.set_deferred("disabled", not on)
