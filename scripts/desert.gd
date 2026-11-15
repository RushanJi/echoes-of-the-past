extends "res://scripts/region.gd"

const SCORPION := preload("res://scenes/scorpion.tscn")

var scorpions := []
var time_left := 0.0

@onready var cave_exit: Marker2D = $CaveExit


func setup() -> void:
	$Present/Merchant.used.connect(talk_merchant)
	$Past/Ancestor.used.connect(talk_ancestor)
	$Spots/CastleDoor.used.connect(enter_castle)


func _process(delta: float) -> void:
	var feet: Vector2 = player.feet()
	if Game.flag("trial_active"):
		if not Game.busy():
			time_left -= delta
		for s in scorpions.duplicate():
			if s.global_position.distance_to(feet) < 45.0:
				scorpions.erase(s)
				s.queue_free()
				Sound.sfx("pop")
		main.hud.status.text = "Scorpions %d/5   %ds" % [5 - scorpions.size(), ceili(time_left)]
		if scorpions.is_empty():
			end_trial(true)
		elif time_left <= 0.0:
			end_trial(false)
	elif not Game.busy() and feet.y > cave_exit.global_position.y and absf(feet.x - cave_exit.global_position.x) < 70.0:
		main.go("CAVE", "exit")


func talk_merchant() -> void:
	if Game.has("sword"):
		await talk("merchant_after")
	elif Game.flag("trial_done"):
		await talk("merchant_win")
		Game.give("sword")
		Sound.sfx("pickup")
		main.hud.toast("You received the Sword! Press X or click to attack.")
	elif Game.flag("warned"):
		await talk("merchant_retry" if Game.flag("trial_tried") else "merchant_trial")
		start_trial()
	else:
		await talk("merchant_refuse")


func talk_ancestor() -> void:
	if Game.flag("warned"):
		await talk("ancestor_2")
		return
	await talk("ancestor_1")
	Game.set_flag("warned")
	main.hud.toast("The sword will be kept for the hero.")


func start_trial() -> void:
	Game.set_flag("trial_active")
	Game.set_flag("trial_tried")
	time_left = 60.0
	Sound.music("minigame")
	for point in $ScorpionPoints.get_children():
		var s = SCORPION.instantiate()
		s.position = point.position
		$Scorpions.add_child(s)
		scorpions.append(s)


func end_trial(won: bool) -> void:
	Game.set_flag("trial_active", false)
	for s in scorpions:
		s.queue_free()
	scorpions.clear()
	main.hud.status.text = ""
	Sound.music(music)
	if won:
		Game.set_flag("trial_done")
		main.hud.toast("Trial complete! Return to the merchant.")
	else:
		main.hud.toast("Time is up! Talk to the merchant to try again.")


func enter_castle() -> void:
	if Game.has("firegem"):
		await talk("castle_quiet")
	elif not Game.has("sword"):
		await talk("castle_locked")
	else:
		Sound.sfx("door")
		main.go("DESERT_ARENA")
