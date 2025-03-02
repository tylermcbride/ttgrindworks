extends Node3D

@export var splashes : Array[Node3D]

var frame_cooldown := 0.833
var current_splash := 0

func _process(delta : float) -> void:
	frame_cooldown -= delta
	if frame_cooldown < 0.0: 
		frame_cooldown = 0.833
		increment_splash()
	else: return

func increment_splash() -> void:
	current_splash += 1
	if current_splash >= splashes.size():
		current_splash = 0
	set_splash(current_splash)

func set_splash(index : int) -> void:
	for i in splashes.size():
		splashes[i].visible = i == index
