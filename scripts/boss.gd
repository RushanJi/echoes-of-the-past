extends CharacterBody2D

signal defeated(position)

const BAR_WIDTH := 70.0

@export var texture: Texture2D
@export var height := 170.0
@export var max_health := 8
@export var speed := 55.0

var health := 8
var target
var alive := true
var active := false
var attack_cooldown := 0.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var bar_back: ColorRect = $BarBack
@onready var bar: ColorRect = $Bar


func _ready() -> void:
	health = max_health
	var k := height / texture.get_height()
	sprite.texture = texture
	sprite.scale = Vector2(k, k)
	sprite.offset = Vector2(0, -texture.get_height() / 2.0)
	bar_back.position = Vector2(-BAR_WIDTH / 2.0 - 1.0, -height - 22.0)
	bar.position = Vector2(-BAR_WIDTH / 2.0, -height - 21.0)
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED


func activate() -> void:
	visible = true
	process_mode = Node.PROCESS_MODE_INHERIT
	active = true
	add_to_group("boss")
	target = get_tree().get_first_node_in_group("player")


func reset() -> void:
	health = max_health
	bar.size.x = BAR_WIDTH


func _physics_process(delta: float) -> void:
	if not alive or target == null:
		return
	attack_cooldown -= delta
	var to: Vector2 = target.feet() - global_position
	sprite.flip_h = to.x > 0.0
	if Game.busy():
		return
	velocity = to.normalized() * speed if to.length() > 10.0 else Vector2.ZERO
	move_and_slide()
	if attack_cooldown <= 0.0 and to.length() < 55.0:
		attack_cooldown = 1.0
		target.hurt(10)


func hit() -> void:
	if not alive or not active:
		return
	health -= 1
	Sound.sfx("hit")
	bar.size.x = BAR_WIDTH * maxf(health, 0) / max_health
	sprite.modulate = Color(3, 3, 3)
	create_tween().tween_property(sprite, "modulate", Color.WHITE, 0.2)
	move_and_collide((global_position - target.feet()).normalized() * 24.0)
	if health <= 0:
		die()


func die() -> void:
	alive = false
	remove_from_group("boss")
	defeated.emit(global_position + Vector2(0, -60))
	var tw := create_tween()
	tw.tween_property(sprite, "modulate:a", 0.0, 0.8)
	tw.tween_callback(queue_free)
