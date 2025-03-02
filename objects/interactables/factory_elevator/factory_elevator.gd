extends AnimatableBody3D
class_name FactoryElevator


@export var final_y := 0.0
@export var rise_time := 3.0

@onready var sfx_player : AudioStreamPlayer3D = $SFXPlayer

var can_rise := true
var rise_tween : Tween

signal s_activated
signal s_destination_reached


func body_entered(body : Node3D) -> void:
	if body is Player and can_rise:
		can_rise = false
		rise()

func rise(to := final_y, time := rise_time) -> void:
	if rise_tween and rise_tween.is_running():
		rise_tween.kill()
	
	rise_tween = create_tween()
	rise_tween.tween_callback(sfx_player.play)
	rise_tween.set_trans(Tween.TRANS_QUAD)
	rise_tween.tween_property(self, 'position:y', to, time)
	rise_tween.finished.connect(
	func():
		rise_tween.kill()
		sfx_player.stop()
	)
	rise_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
