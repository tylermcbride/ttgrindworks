extends ActionScript
class_name FinalBossPhaseTwoCutscene

var directory : FinalBossScene

func action() -> void:
	directory = user
	var boss_cog: Cog = directory.boss_cog
	manager.add_cog(boss_cog)
	
	# Movie Start
	var movie := manager.create_tween()
	
	# Boss focus
	movie.tween_callback(set_cam_angle.bind('DeskFocus'))
	movie.tween_callback(boss_cog.speak.bind("How disappointing."))
	movie.tween_interval(3.0)
	movie.tween_callback(boss_cog.speak.bind("And to think, I was going to promote them."))
	movie.tween_interval(6.0)
	
	# Boss flies away
	movie.tween_callback(boss_cog.speak.bind("Regardless..."))
	movie.tween_callback(boss_cog.fly_out)
	movie.tween_callback(boss_cog.battle_start)
	movie.tween_interval(4.0)
	
	# Boss flies back in 
	movie.tween_callback(boss_cog.set_global_position.bind(Vector3.ZERO))
	movie.tween_callback(battle_node.face_battle_center.bind(boss_cog))
	movie.tween_callback(boss_cog.fly_in)
	movie.tween_callback(battle_node.focus_cogs)
	movie.tween_callback(func(): battle_node.battle_cam.position.z += 2.0)
	movie.set_trans(Tween.TRANS_QUAD)
	movie.tween_property(battle_node.battle_cam, "position:y", 2.5, 5.0)
	movie.parallel().tween_callback(boss_cog.speak.bind("It's only fitting I give you the fight you're looking for. After all...")).set_delay(2.0)
	movie.set_trans(Tween.TRANS_LINEAR)
	movie.tween_interval(2.0)
	
	# Boss flies back in
	movie.tween_callback(battle_node.focus_character.bind(boss_cog))
	movie.tween_callback(boss_cog.speak.bind("I'm the boss."))
	movie.tween_interval(6.0)
	
	await movie.finished
	movie.kill()

func set_cam_angle(angle : String) -> void:
	battle_node.battle_cam.global_transform = get_camera_angle(angle)

func get_camera_angle(angle : String) -> Transform3D:
	return directory.get_node('CameraAngles/' + angle).global_transform

func get_char_position(pos : String) -> Vector3:
	return directory.get_node('CharPositions/'+ pos).global_position
