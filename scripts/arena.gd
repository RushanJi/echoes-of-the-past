extends "res://scripts/region.gd"

@export var item := ""
@export var next_region := ""
@export var intro := ""

@onready var boss = $Boss


func setup() -> void:
	boss.defeated.connect(on_defeated)


func begin() -> void:
	await main.hud.flash(boss.activate)
	Sound.music("battle")
	await talk(intro)
	main.hud.toast("Press X or click to swing your sword!")


func respawn() -> void:
	super()
	if boss.active and boss.alive:
		boss.reset()
		boss.global_position = $BossSpawn.global_position


func on_defeated(pos: Vector2) -> void:
	Sound.music(music)
	Game.lock()
	await main.hud.fly(item, main.screen_pos(pos))
	Game.give(item)
	Game.unlock()
	if next_region == "END":
		main.ending()
	else:
		main.go(next_region)
