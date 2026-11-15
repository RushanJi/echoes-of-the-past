extends Node

signal health_changed(value)
signal player_died

enum Era { PRESENT, PAST }

const MAX_HEALTH := 100

var region := "CAVE"
var timeline := Era.PRESENT
var visited := {"CAVE": true}
var items := {}
var flags := {}
var locks := 0
var health := MAX_HEALTH:
	set(v):
		health = clampi(v, 0, MAX_HEALTH)
		health_changed.emit(health)


func _ready() -> void:
	bind("move_left", [KEY_A, KEY_LEFT])
	bind("move_right", [KEY_D, KEY_RIGHT])
	bind("move_up", [KEY_W, KEY_UP])
	bind("move_down", [KEY_S, KEY_DOWN])
	bind("interact", [KEY_SPACE])
	bind("time", [KEY_T])
	bind("map", [KEY_M])
	bind("attack", [KEY_X, KEY_J])
	var click := InputEventMouseButton.new()
	click.button_index = MOUSE_BUTTON_LEFT
	InputMap.action_add_event("attack", click)


func bind(action: String, keys: Array) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	for k in keys:
		var ev := InputEventKey.new()
		ev.physical_keycode = k
		InputMap.action_add_event(action, ev)


func reset() -> void:
	region = "CAVE"
	timeline = Era.PRESENT
	visited = {"CAVE": true}
	items = {}
	flags = {}
	locks = 0
	health = MAX_HEALTH


func has(id: String) -> bool:
	return items.get(id, false)


func give(id: String) -> void:
	items[id] = true


func take(id: String) -> void:
	items.erase(id)


func flag(id: String) -> bool:
	return flags.get(id, false)


func set_flag(id: String, value := true) -> void:
	flags[id] = value


func lock() -> void:
	locks += 1


func unlock() -> void:
	locks = maxi(locks - 1, 0)


func busy() -> bool:
	return locks > 0


func is_past() -> bool:
	return timeline == Era.PAST


func damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		player_died.emit()
