extends CharacterBody2D

const SPEED := 300.0
const FRAME_TIME := 0.1
const NAMES := ["right", "down_right", "down", "down_left", "left", "up_left", "up", "up_right"]

@onready var sprite: Sprite2D = $Sprite2D
@onready var camera: Camera2D = $Camera2D
@onready var sword: Sprite2D = $Sword

var frames := {}
var facing := "down"
var anim_time := 0.0
var attack_cooldown := 0.0
var hurt_cooldown := 0.0


func _ready() -> void:
	for n in NAMES:
		var arr := []
		for i in range(1, 5):
			arr.append(load("res://assets/player/%s_%d.png" % [n, i]))
		frames[n] = arr
	sprite.texture = frames["down"][0]


func feet() -> Vector2:
	return global_position + $FeetShape.position


func _physics_process(delta: float) -> void:
	attack_cooldown -= delta
	hurt_cooldown -= delta
	var v := Vector2.ZERO
	if not Game.busy():
		v = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		if Input.is_action_just_pressed("interact"):
			interact()
		if Input.is_action_just_pressed("attack") and Game.has("sword") and attack_cooldown <= 0.0:
			attack()
	velocity = v * SPEED
	move_and_slide()
	animate(v, delta)


func animate(v: Vector2, delta: float) -> void:
	if v == Vector2.ZERO:
		return
	var d: String = NAMES[posmod(roundi(v.angle() / (PI / 4.0)), 8)]
	if d != facing:
		facing = d
		anim_time = 0.0
	else:
		anim_time += delta
	sprite.texture = frames[facing][int(anim_time / FRAME_TIME) % 4]


func nearest_spot():
	var best = null
	var best_dist := INF
	for s in get_tree().get_nodes_in_group("spot"):
		var d := feet().distance_to(s.global_position)
		if s.usable() and d < s.reach and d < best_dist:
			best = s
			best_dist = d
	return best


func interact() -> void:
	var s = nearest_spot()
	if s:
		s.use()


func attack() -> void:
	attack_cooldown = 0.45
	var a: float = NAMES.find(facing) * PI / 4.0
	sword.rotation = a - 1.0
	sword.visible = true
	Sound.sfx("swing")
	var tw := create_tween()
	tw.tween_property(sword, "rotation", a + 1.0, 0.18)
	tw.tween_callback(sword.hide)
	for b in get_tree().get_nodes_in_group("boss"):
		if b.global_position.distance_to(feet()) < 130.0:
			b.hit()


func hurt(amount: int) -> void:
	if hurt_cooldown > 0.0:
		return
	hurt_cooldown = 1.0
	Sound.sfx("hurt")
	Game.damage(amount)
	var tw := create_tween()
	for i in 4:
		tw.tween_property(sprite, "modulate:a", 0.4, 0.1)
		tw.tween_property(sprite, "modulate:a", 1.0, 0.1)
