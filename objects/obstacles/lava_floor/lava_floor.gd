extends Area3D
class_name LavaFloor

signal s_lava_hit

@export var tick_delay := 2.0
@export var base_damage := -1
@export var damage_name: String = "Molten Lava"

var active := true
var timer: Timer
var hp_tick := -1

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = tick_delay
	timer.one_shot = true
	
	hp_tick = Util.get_hazard_damage() + base_damage

func body_entered(body : Node3D) -> void:
	if not body is Player or not active:
		return
	while overlaps_body(Util.get_player()):
		active = false
		hurt_player()
		timer.start()
		await timer.timeout
		active = true

func hurt_player() -> void:
	s_lava_hit.emit()
	var player := Util.get_player()
	player.last_damage_source = damage_name
	player.quick_heal(hp_tick)
	if player.toon.yelp:
		AudioManager.play_sound(player.toon.yelp)

func check_for_player():
	if overlaps_body(Util.get_player()):
		hurt_player()
