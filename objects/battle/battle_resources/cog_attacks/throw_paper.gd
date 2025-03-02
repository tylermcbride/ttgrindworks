extends CogAttack
class_name ThrowPaper

# Config
@export var prop : PackedScene
@export var wait_time := 3.2
@export var custom_method : String

# Locals
var held_prop : Node3D
var hit : bool

func action():
	hit = manager.roll_for_accuracy(self)
	user.face_position(targets[0].global_position)
	# Hold the prop
	if prop: 
		held_prop = prop.instantiate()
	user.body.right_hand_bone.add_child(held_prop)
	user.set_animation('throw-paper')
	
	
	if has_method(custom_method):
		await Callable(self,custom_method).call()
	
	if is_instance_valid(held_prop):
		held_prop.queue_free()

func pink_slip():
	manager.s_focus_char.emit(user)
	held_prop.rotation_degrees = Vector3(90.0,180.0,90.0)
	held_prop.scale*=7.5
	var target = targets[0]
	
	
	if hit:
		await manager.sleep(wait_time-0.2)
		target.set_animation('happy')
		await manager.sleep(0.2)
	else:
		await manager.sleep(wait_time)
	
	held_prop.top_level = true
	var throw_tween : Tween = held_prop.create_tween()
	throw_tween.set_parallel(true)
	throw_tween.tween_property(held_prop,'global_position',target.global_position,0.8)
	throw_tween.tween_property(held_prop,'rotation_degrees',Vector3(0.0,-180.0,-180.0),0.5)
	AudioManager.play_snippet(load("res://audio/sfx/battle/cogs/attacks/SA_pink_slip.ogg"),0.0,1.0)
	manager.s_focus_char.emit(target)
	
	# When missed, jump late
	if not hit:
		target.set_animation('happy')
		manager.battle_text(target,'MISSED')
	
	await throw_tween.finished
	if hit:
		manager.affect_target(target,'hp',damage,false)
		target.set_animation('slip_forwards')
	
	await manager.barrier(target.animator.animation_finished, 4.0)
	
	await manager.check_pulses(targets)
