extends CanvasLayer

signal travel_requested(region)
signal advanced

const HEALTH := {
	10: "res://assets/ui/health_10.png", 9: "res://assets/ui/health_9.png",
	8: "res://assets/ui/health_8.png", 7: "res://assets/ui/health_7.png",
	6: "res://assets/ui/health_6.png", 5: "res://assets/ui/health_5.png",
	4: "res://assets/ui/health_4.png",
}
const MAP_NAMES := {"SNOW": "Snow Region", "DESERT": "Desert Region", "CAVE": "The Cave"}
const FLY_SIZE := Vector2(52, 52)

var homes := {}
var sizes := {}
var typing: Tween

@onready var health_bar: Sprite2D = $HealthBar
@onready var region_label: Label = $RegionLabel
@onready var hint: Label = $Hint
@onready var status: Label = $Status
@onready var toast_label: Label = $Toast
@onready var box: ColorRect = $Dialogue
@onready var speaker: Label = $Dialogue/Speaker
@onready var text: Label = $Dialogue/Text
@onready var map_view: Control = $MapView
@onready var tint: ColorRect = $Tint
@onready var fade: ColorRect = $Fade
@onready var white: ColorRect = $White
@onready var slots := {
	"timegem": $Inventory/TimeGem, "firegem": $Inventory/FireGem, "icegem": $Inventory/IceGem,
	"key": $Inventory/Key, "minimap": $Inventory/Minimap,
}
@onready var map_buttons := {
	"SNOW": $MapView/SnowButton, "DESERT": $MapView/DesertButton, "CAVE": $MapView/CaveButton,
}


func _ready() -> void:
	for id in slots:
		homes[id] = slots[id].position
		sizes[id] = slots[id].size
	for id in map_buttons:
		map_buttons[id].pressed.connect(on_map_pressed.bind(id))
	Game.health_changed.connect(on_health)


func _process(_delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	hint.visible = player != null and not Game.busy() and player.nearest_spot() != null
	if hint.visible:
		hint.position = get_viewport().get_canvas_transform() * (player.global_position + Vector2(-20, -70))


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("map") and Game.has("minimap"):
		if map_view.visible:
			close_map()
		elif not Game.busy() and not Game.flag("trial_active"):
			open_map()
	elif box.visible and event.is_action_pressed("interact"):
		if typing and typing.is_running():
			typing.kill()
			text.visible_ratio = 1.0
		else:
			advanced.emit()


func open_map() -> void:
	Game.lock()
	for id in map_buttons:
		var open: bool = Game.visited.get(id, false)
		map_buttons[id].disabled = not open
		map_buttons[id].modulate = Color.WHITE if open else Color(0.25, 0.25, 0.25, 0.8)
	map_view.visible = true


func close_map() -> void:
	map_view.visible = false
	Game.unlock()


func on_map_pressed(id: String) -> void:
	close_map()
	travel_requested.emit(id)


func on_health(h: int) -> void:
	var f := 10
	if h < 100:
		f = 9
	if h <= 80:
		f = 8
	if h <= 60:
		f = 7
	if h <= 40:
		f = 6
	if h <= 20:
		f = 5
	if h <= 0:
		f = 4
	health_bar.texture = load(HEALTH[f])


func set_region(id: String) -> void:
	region_label.text = MAP_NAMES.get(id.get_slice("_", 0), id)
	region_label.visible = Game.has("minimap") or slots["minimap"].visible


func say(who: String, lines: Array) -> void:
	Game.lock()
	speaker.text = who
	box.visible = true
	for line in lines:
		text.text = line
		text.visible_ratio = 0.0
		typing = create_tween()
		typing.tween_property(text, "visible_ratio", 1.0, line.length() * 0.015 + 0.05)
		await advanced
	box.visible = false
	await get_tree().create_timer(0.15).timeout
	Game.unlock()


func toast(message: String) -> void:
	toast_label.text = message
	var tw := create_tween()
	tw.tween_property(toast_label, "modulate:a", 1.0, 0.2)
	tw.tween_interval(2.2)
	tw.tween_property(toast_label, "modulate:a", 0.0, 0.5)


func fly(id: String, from: Vector2) -> void:
	Sound.sfx("pickup")
	var slot: TextureRect = slots[id]
	slot.modulate.a = 1.0
	slot.size = FLY_SIZE
	slot.position = from - FLY_SIZE / 2.0
	slot.visible = true
	var tw := create_tween()
	tw.tween_property(slot, "position:y", slot.position.y - 40.0, 0.45).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.tween_interval(0.3)
	tw.tween_property(slot, "position", homes[id], 0.9).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tw.parallel().tween_property(slot, "size", sizes[id], 0.9)
	await tw.finished
	if id == "minimap":
		set_region(Game.region)


func remove_item(id: String) -> void:
	var slot: TextureRect = slots[id]
	var tw := create_tween()
	tw.tween_property(slot, "modulate:a", 0.0, 0.5)
	tw.tween_callback(slot.hide)


func merge_gems() -> void:
	var a: TextureRect = slots["firegem"]
	var b: TextureRect = slots["icegem"]
	for id in slots:
		if id != "firegem" and id != "icegem":
			slots[id].visible = false
	var tw := create_tween().set_parallel(true)
	tw.tween_property(a, "size", Vector2(90, 90), 1.2)
	tw.tween_property(b, "size", Vector2(90, 90), 1.2)
	tw.tween_property(a, "position", Vector2(130, 135), 1.2).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(b, "position", Vector2(260, 135), 1.2).set_trans(Tween.TRANS_CUBIC)
	await tw.finished
	Sound.sfx("time")
	var join := create_tween().set_parallel(true)
	join.tween_property(a, "position", Vector2(195, 135), 1.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	join.tween_property(b, "position", Vector2(195, 135), 1.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	join.tween_property(a, "size", Vector2(130, 130), 1.0)
	join.tween_property(b, "size", Vector2(130, 130), 1.0)
	await join.finished


func fade_to(alpha: float, duration: float) -> void:
	var tw := create_tween()
	tw.tween_property(fade, "color:a", alpha, duration)
	await tw.finished


func tint_to(alpha: float, duration: float) -> void:
	var tw := create_tween()
	tw.tween_property(tint, "color:a", alpha, duration)
	await tw.finished


func white_to(alpha: float, duration: float) -> void:
	var tw := create_tween()
	tw.tween_property(white, "color:a", alpha, duration)
	await tw.finished


func flash(peak := Callable()) -> void:
	Sound.sfx("flash")
	white.color.a = 1.0
	if peak.is_valid():
		peak.call()
	await white_to(0.0, 0.9)
