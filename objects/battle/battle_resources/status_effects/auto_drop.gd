@tool
extends StatusEffect
class_name StatusAutoDrop

@export var drop_gag: GagDrop

func apply() -> void:
	manager.s_round_started.connect(round_started)

func cleanup() -> void:
	if manager.s_round_started.is_connected(round_started):
		manager.s_round_started.disconnect(round_started)

func round_started(_actions: Array[BattleAction]) -> void:
	var new_drop: GagDrop = drop_gag.duplicate()
	new_drop.targets = [target]
	new_drop.user = Util.get_player()
	new_drop.special_action_exclude = true
	new_drop.skip_button_movie = true
	manager.inject_battle_action(new_drop, 0)

func get_icon() -> Texture2D:
	return drop_gag.icon

func get_status_name() -> String:
	return "Incoming Drop"

func get_description() -> String:
	return "Will be hit by %s\nDamage: %s" % [drop_gag.action_name, drop_gag.get_true_damage()]
