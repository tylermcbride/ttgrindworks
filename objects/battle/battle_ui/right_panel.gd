extends Control

# Child References
@onready var gag_info := $GagInfo
@onready var gag_name := $GagInfo/GagName
@onready var gag_stats := $GagInfo/GagStats
@onready var gag_icon := $GagInfo/GagIcon

func preview_gag(gag: BattleAction):
	if not gag:
		clear_display()
		return
	gag_info.show()
	gag_name.text = gag.action_name
	gag_stats.text = gag.get_stats()
	gag_icon.texture = gag.icon

func clear_display() -> void:
	gag_info.hide()
