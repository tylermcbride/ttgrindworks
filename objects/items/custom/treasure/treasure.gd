extends Sprite3D

var item : Resource
var heal_perc := 0.1

func setup(res : Item) -> void:
	item = res
	if item.arbitrary_data.has('heal_perc'):
		item.big_description = "Heals " + str(item.arbitrary_data['heal_perc']) + "% of your max laff."
		heal_perc = float(item.arbitrary_data['heal_perc']) / 100.0
	if item.arbitrary_data.has('texture'):
		texture = item.arbitrary_data['texture']

func collect() -> void:
	if is_instance_valid(Util.get_player()):
		Util.get_player().quick_heal(get_heal_value())

func modify(ui_asset : Sprite3D) -> void:
	ui_asset.texture = texture

func get_heal_value() -> int:
	if not Util.get_player() or not Util.get_player().stats:
		return 5
	return ceili(Util.get_player().stats.max_hp * heal_perc)
