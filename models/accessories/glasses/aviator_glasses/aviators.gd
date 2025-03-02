extends Node3D

var resource: Item

func setup(item: Item):
	resource = item
	# Reroll aviators if we don't have proxies unlocked
	# Its effect is only valid for proxy cogs
	if not SaveFileService.progress_file.proxies_unlocked:
		item.reroll()
		print('Rerolling aviators because proxy cogs not unlocked')
