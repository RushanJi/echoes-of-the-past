extends "res://scripts/region.gd"

@onready var chest: Sprite2D = $Chest
@onready var exit_line: Marker2D = $ExitLine


func setup() -> void:
	$Spots/ChestSpot.used.connect(open_chest)
	$Present/Elder.used.connect(talk_elder)


func _process(_delta: float) -> void:
	if Game.busy():
		return
	var p: Vector2 = player.feet()
	if p.y < exit_line.global_position.y and absf(p.x - exit_line.global_position.x) < 90.0:
		main.go("DESERT")


func talk_elder() -> void:
	await talk("cave_1_gem" if Game.has("timegem") else "cave_1")


func open_chest() -> void:
	if Game.flag("chest_open"):
		await talk("chest_empty")
		return
	Game.set_flag("chest_open")
	Game.lock()
	Sound.sfx("chest")
	var tw := create_tween()
	tw.tween_property(chest, "scale", chest.scale * 1.15, 0.1)
	tw.tween_property(chest, "scale", chest.scale, 0.1)
	await tw.finished
	chest.modulate = Color(0.7, 0.7, 0.7)
	var from: Vector2 = main.screen_pos(chest.global_position + Vector2(0, -50))
	await main.hud.fly("minimap", from)
	Game.give("minimap")
	await main.hud.fly("timegem", from)
	Game.give("timegem")
	Game.unlock()
	await talk("chest_open")
