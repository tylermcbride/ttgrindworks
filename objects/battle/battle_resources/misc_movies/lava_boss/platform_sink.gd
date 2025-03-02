extends ActionScript
class_name BossLavaSink

func action():
	manager.battle_node.battle_cam.global_transform = user.sink_pos.global_transform
	await user.sink_platform(1.0)
