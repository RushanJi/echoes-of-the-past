extends Node

const TRACKS := {
	"cave": "res://assets/music/Cave Music.mp3",
	"desert": "res://assets/music/Desert Music.ogg",
	"snow": "res://assets/music/Snow Music.mp3",
	"battle": "res://assets/music/Battle Music.ogg",
	"minigame": "res://assets/music/Minigame Music.mp3",
	"win": "res://assets/music/Win Music.mp3",
}

var player := AudioStreamPlayer.new()
var current := ""
var cache := {}


func _ready() -> void:
	player.volume_db = -8.0
	add_child(player)


func music(track: String) -> void:
	if track == current or not TRACKS.has(track):
		return
	current = track
	if player.playing:
		var out := create_tween()
		out.tween_property(player, "volume_db", -40.0, 0.4)
		await out.finished
	if current != track:
		return
	var stream = load(TRACKS[track])
	stream.loop = true
	player.stream = stream
	player.volume_db = -40.0
	player.play()
	create_tween().tween_property(player, "volume_db", -8.0, 0.5)


func sfx(name: String) -> void:
	if not cache.has(name):
		cache[name] = load("res://assets/sfx/%s.wav" % name)
	var p := AudioStreamPlayer.new()
	p.stream = cache[name]
	p.volume_db = -4.0
	add_child(p)
	p.finished.connect(p.queue_free)
	p.play()
