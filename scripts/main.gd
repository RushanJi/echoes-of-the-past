extends Node2D

const CUTSCENE := preload("res://scenes/cutscene.tscn")
const DIVING := preload("res://scenes/diving.tscn")
const REGIONS := {
	"CAVE": preload("res://scenes/regions/cave.tscn"),
	"DESERT": preload("res://scenes/regions/desert.tscn"),
	"SNOW": preload("res://scenes/regions/snow.tscn"),
	"DESERT_ARENA": preload("res://scenes/regions/desert_arena.tscn"),
	"SNOW_ARENA": preload("res://scenes/regions/snow_arena.tscn"),
}

var region

@onready var hud = $HUD
@onready var world: Node2D = $World


func _ready() -> void:
	hud.travel_requested.connect(travel)
	Game.player_died.connect(respawn)
	start()


func start() -> void:
	Game.lock()
	Sound.music("cave")
	var c = CUTSCENE.instantiate()
	add_child(c)
	await c.title()
	await c.intro()
	hud.fade.color = Color(0, 0, 0, 1)
	c.queue_free()
	load_region("CAVE")
	await hud.fade_to(0.0, 0.8)
	Game.unlock()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("time"):
		swap_time()


func screen_pos(point: Vector2) -> Vector2:
	return get_viewport().get_canvas_transform() * point


func load_region(id: String, entry := "default") -> void:
	if region:
		region.queue_free()
	Game.region = id
	Game.timeline = Game.Era.PRESENT
	Game.visited[id.get_slice("_", 0)] = true
	region = REGIONS[id].instantiate()
	region.main = self
	region.entry = entry
	world.add_child(region)
	hud.set_region(id)
	Sound.music(region.music)


func go(id: String, entry := "default") -> void:
	Game.lock()
	await hud.fade_to(1.0, 0.4)
	load_region(id, entry)
	await hud.fade_to(0.0, 0.4)
	await region.begin()
	Game.unlock()


func travel(id: String) -> void:
	if id != Game.region:
		go(id)


func swap_time() -> void:
	if region == null or not Game.has("timegem") or not region.allow_time:
		return
	if Game.flag("trial_active"):
		hud.toast("Time cannot be shifted during the trial.")
		return
	if Game.busy():
		return
	Game.lock()
	Sound.sfx("time")
	await hud.tint_to(0.85, 0.35)
	Game.timeline = Game.Era.PRESENT if Game.is_past() else Game.Era.PAST
	region.apply_time()
	await hud.tint_to(0.0, 0.5)
	Game.unlock()


func respawn() -> void:
	Game.lock()
	await hud.fade_to(1.0, 0.4)
	Game.health = Game.MAX_HEALTH
	region.respawn()
	await hud.fade_to(0.0, 0.4)
	Game.unlock()


func dive() -> void:
	Game.lock()
	Sound.music("minigame")
	await hud.fade_to(1.0, 0.4)
	var d = DIVING.instantiate()
	add_child(d)
	await hud.fade_to(0.0, 0.4)
	await d.finished
	d.key_icon.hide()
	await hud.fly("key", d.key_icon.position)
	Game.give("key")
	await hud.fade_to(1.0, 0.4)
	d.queue_free()
	Sound.music(region.music)
	await hud.fade_to(0.0, 0.4)
	Game.unlock()
	hud.toast("You found the Palace Key!")


func ending() -> void:
	Game.lock()
	Sound.music("win")
	await get_tree().create_timer(0.4).timeout
	await hud.merge_gems()
	await hud.white_to(1.0, 0.5)
	hud.visible = false
	var c = CUTSCENE.instantiate()
	add_child(c)
	await c.ending()
