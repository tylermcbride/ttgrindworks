extends Node3D

var resource: Item

func setup(item: Item):
	resource = item
	# Reroll oil can if we don't have proxies unlocked
	# Its effect is only valid for proxy cogs
	if not SaveFileService.progress_file.proxies_unlocked:
		item.reroll()
		print('Rerolling oil can because proxy cogs not unlocked')

func collect() -> void:
	# Toon yell. they are scare
	AudioManager.play_sound(Util.get_player().toon.yelp)
