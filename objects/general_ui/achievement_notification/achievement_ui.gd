extends Control

const UI_ANIMATION := preload("res://objects/general_ui/achievement_notification/achievement_notification.tscn")

var achievement_queue: Array[Achievement] = []
var playing := false


func queue_achievement_get(achievement: Achievement) -> void:
	achievement_queue.append(achievement)
	if not playing:
		_play_queue()

func _play_queue() -> void:
	playing = true
	while achievement_queue.size() > 0:
		await play_animation(achievement_queue.pop_front())
	playing = false 

func play_animation(achievement: Achievement) -> void:
	var animation := UI_ANIMATION.instantiate()
	animation.get_node("CanvasLayer/Origin/PanelMask/Panel/Title").set_text(achievement.achievement_name)
	animation.get_node('CanvasLayer/Origin/PanelMask/Panel/Summary').set_text(achievement.achievement_summary)
	if achievement.achievement_icon:
		animation.get_node('CanvasLayer/Origin/IconOrigin/Icon').set_texture(achievement.achievement_icon)
	add_child(animation)
	await animation.s_animation_finished
