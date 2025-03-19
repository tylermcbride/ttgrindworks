extends ItemScript

const DEBUFF := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_aftershock.tres")

var movie = create_tween()
var shaking: bool = false

func on_collect(_item: Item, _model: Node3D) -> void:
	setup()
 
func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_battle_started.connect(on_battle_start)

func on_battle_start(manager: BattleManager) -> void:
	manager.s_action_added.connect(action_injected)

# pasted from BattleStartMovie because I'm not sure how to call that function here lol
func shake_camera(cam : Camera3D, time : float, offset : float, taper := true, x := true, y := true, z := true) -> void:
	var base_pos := cam.global_position
	var shaking := true
	
	var timer := cam.get_tree().create_timer(time)
	
	while shaking:
		await Util.s_process_frame
		var new_offset : float
		if taper:
			new_offset = offset * timer.time_left/time
		else:
			new_offset = offset
		if x:
			cam.global_position.x = base_pos.x + RandomService.randf_range_channel('true_random', -new_offset,new_offset)
		if y:
			cam.global_position.y = base_pos.y + RandomService.randf_range_channel('true_random', -new_offset,new_offset)
		if z:
			cam.global_position.z = base_pos.z + RandomService.randf_range_channel('true_random', -new_offset,new_offset)
		
		if timer.time_left <= 0:
			shaking = false


func action_injected(action: BattleAction, manager: BattleManager) -> void:
	if action is GagDrop:
		var cogs: Array[Cog] = manager.cogs
		var target: Cog = action.targets[0]
		var cogPos: int
		var hitCogs: Array[Cog]
		for i in range(cogs.size()):
			if cogs[i] == target:
				cogPos = i
				print(cogPos)
		# get cogs directly left & right of the target (a bit ugly, but works!)
		for i in range(cogs.size()):
			if i == cogPos + 1 or i == cogPos - 1:
				hitCogs.append(cogs[i])
		await action.s_hit
		movie.tween_callback(shake_camera.bind(get_viewport().get_camera_3d(), 0.5, 0.2, true, false, true, false))
		movie.play()
		await Task.delay(0.25)
		for i in range(hitCogs.size()):
			var cog = hitCogs[i]
			var new_effect: StatEffectAftershock = DEBUFF.duplicate()
			cog.set_animation('slip-backward')
			match cog.dna.suit:
				CogDNA.SuitType.SUIT_A:
					cog.animator_seek(2.43)
				CogDNA.SuitType.SUIT_B:
					cog.animator_seek(1.94)
				CogDNA.SuitType.SUIT_C:
					cog.animator_seek(2.58)
			new_effect.amount = roundi(action.damage * 0.5) # full aftershock is a bit strong on 3 targets
			new_effect.description = "%d damage per round" % new_effect.amount
			new_effect.target = cog
			if action.user.stats.get_stat("drop_aftershock_round_boost") != 0:
				new_effect.rounds += action.user.stats.get_stat("drop_aftershock_round_boost")
			manager.add_status_effect(new_effect)
		await Task.delay(1)	
		for i in range(hitCogs.size()):
			var cog = hitCogs[i]
			manager.battle_text(cog, "Quake!", Color('ff7438'), Color('d65527'), 0)
