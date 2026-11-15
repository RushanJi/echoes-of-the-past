extends CanvasLayer

signal next

const SLIDES := [
	{"img": "res://assets/ui/forested_big_map.jpg", "gems": false,
	"text": "Long ago, this continent was a vast and thriving forest, green from the shore to the mountain peaks."},
	{"img": "res://assets/ui/forested_big_map.jpg", "gems": true,
	"text": "Then two power-hungry rulers rose, each seizing an elemental gem. One took the Fire Gem. The other took the Ice Gem."},
	{"img": "res://assets/ui/big_map.jpg", "gems": false,
	"text": "Their war was devastating. The smoke and fury polluted the land and split the continent in two."},
	{"img": "res://assets/ui/big_map.jpg", "gems": false,
	"text": "Fire scorched one half into an endless desert. Ice froze the other into a bitter wasteland of snow. The forest was lost."},
	{"img": "res://assets/ui/big_map.jpg", "gems": true,
	"text": "In the Present, one hero must defeat both war rulers, claim the Fire and Ice gems, and merge their power to heal the land and bring back the forest."},
	{"img": "res://assets/maps/cave.jpg", "gems": false,
	"text": "Your story begins in a hidden cave, where a Secret Society swears the outside world is not worth seeing..."},
]

var typing: Tween
var zoom: Tween

@onready var pic: TextureRect = $PicA
@onready var pic2: TextureRect = $PicB
@onready var shade: ColorRect = $Shade
@onready var caption: Label = $Caption
@onready var cover: ColorRect = $Cover
@onready var start_button: TextureRect = $StartButton
@onready var gems := [$GemFire, $GemIce]


func _input(event: InputEvent) -> void:
	var m := event as InputEventMouseButton
	if event.is_action_pressed("interact") or (m != null and m.pressed):
		next.emit()


func title() -> void:
	pic.texture = load("res://assets/ui/title_backdrop.png")
	pic.modulate.a = 1.0
	start_button.visible = true
	var blink := create_tween().set_loops()
	blink.tween_property(start_button, "modulate:a", 0.45, 0.7)
	blink.tween_property(start_button, "modulate:a", 1.0, 0.7)
	await next
	blink.kill()
	start_button.visible = false
	var out := create_tween()
	out.tween_property(pic, "modulate:a", 0.0, 0.6)
	await out.finished


func intro() -> void:
	for s in SLIDES:
		await slide(s)
	cover.color = Color(0, 0, 0, 1)


func slide(s: Dictionary) -> void:
	pic.texture = load(s["img"])
	pic.scale = Vector2.ONE
	if zoom:
		zoom.kill()
	zoom = create_tween()
	zoom.tween_property(pic, "scale", Vector2(1.1, 1.1), 12.0)
	var fade_in := create_tween()
	fade_in.tween_property(pic, "modulate:a", 1.0, 0.8)
	for g in gems:
		g.visible = s["gems"]
	shade.modulate.a = 1.0
	await line(s["text"])
	var out := create_tween()
	out.tween_property(pic, "modulate:a", 0.0, 0.5)
	out.parallel().tween_property(shade, "modulate:a", 0.0, 0.5)
	await out.finished
	caption.text = ""
	for g in gems:
		g.visible = false


func line(t: String) -> void:
	caption.text = t
	caption.visible_ratio = 0.0
	typing = create_tween()
	typing.tween_property(caption, "visible_ratio", 1.0, t.length() * 0.025)
	await next
	if typing.is_running():
		typing.kill()
		caption.visible_ratio = 1.0
		await next


func narrate(t: String, seconds: float) -> void:
	caption.text = t
	caption.visible_ratio = 1.0
	shade.modulate.a = 1.0
	await get_tree().create_timer(seconds).timeout


func ending() -> void:
	pic.texture = load("res://assets/ui/big_map.jpg")
	pic.modulate.a = 1.0
	pic2.texture = load("res://assets/ui/forested_big_map.jpg")
	cover.color = Color(1, 1, 1, 1)
	var reveal := create_tween()
	reveal.tween_property(cover, "color:a", 0.0, 1.2)
	await reveal.finished
	await get_tree().create_timer(1.0).timeout
	var heal := create_tween()
	heal.tween_property(pic2, "modulate:a", 1.0, 5.0)
	await narrate("Fire and Ice, joined at last, wash over the land. The smoke clears and the frost melts.", 3.0)
	await narrate("Green returns to every mountain, valley and shore. The forest lives again.", 3.0)
	await heal.finished
	shade.modulate.a = 0.0
	caption.text = ""
	cover.color = Color(0, 0, 0, 0)
	var dark := create_tween()
	dark.tween_property(cover, "color:a", 1.0, 0.8)       
	await dark.finished
	pic.modulate.a = 0.0
	pic.texture = load("res://assets/ui/youwin.jpg")
	var win := create_tween()
	win.tween_property(cover, "color:a", 0.0, 0.8)
	await win.finished
	shade.modulate.a = 1.0
	caption.text = "YOU WON!  Press SPACE to play again."
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	await next
	Game.reset()
	get_tree().reload_current_scene()
