extends FloorModifier

var loadout : GagLoadout


func modify_floor() -> void:
	var player := Util.get_player()
	
	if not player:
		return
	
	# Save a copy of the base gag loadout
	loadout = player.stats.character.gag_loadout.duplicate()
	
	# Shuffle the player's current loadout
	RandomService.array_shuffle_channel('anomaly_reorg',player.stats.character.gag_loadout.loadout)

func clean_up() -> void:
	if not loadout:
		return
	# Restore previous loadout
	var player := Util.get_player()
	player.stats.character.gag_loadout = loadout

func get_mod_name() -> String:
	return "Reorganization"

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/Reorganization.png")

func get_description() -> String:
	return "Gag tracks are randomly shuffled"
