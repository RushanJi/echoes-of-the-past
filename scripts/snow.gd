extends "res://scripts/region.gd"


func setup() -> void:
	$Present/LakeSpot.used.connect(dive)
	$Past/SaplingSpot.used.connect(uproot)
	$Spots/FortressDoor.used.connect(enter_fortress)
	if Game.flag("sapling_removed"):
		remove_tree()


func remove_tree() -> void:
	$Present/Tree.queue_free()
	$Past/Sapling.queue_free()
	$Past/SaplingSpot.queue_free()


func uproot() -> void:
	Game.set_flag("sapling_removed")
	Sound.sfx("pickup")
	remove_tree()
	await talk("sapling")


func dive() -> void:
	if Game.has("key") or Game.flag("key_used"):
		await talk("lake_done")
	else:
		await main.dive()


func enter_fortress() -> void:
	if Game.has("icegem"):
		await talk("fortress_quiet")
	elif Game.has("key"):
		await talk("fortress_open")
		Game.take("key")
		Game.set_flag("key_used")
		main.hud.remove_item("key")
		Sound.sfx("door")
		main.go("SNOW_ARENA")
	else:
		await talk("fortress_locked")
