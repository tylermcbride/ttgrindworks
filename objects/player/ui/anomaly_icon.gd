@tool
extends Control

const HOVER_SFX := preload("res://audio/sfx/ui/GUI_rollover.ogg")

const QualityColors := {
	FloorModifier.ModType.POSITIVE: Color(0.488, 1, 0.456),
	FloorModifier.ModType.NEUTRAL: Color(1, 0.539, 0.21),
	FloorModifier.ModType.NEGATIVE: Color(1, 0.336, 0.27),
}

@export var anomaly: GDScript:
	set(x):
		anomaly = x
		await NodeGlobals.until_ready(self)
		if anomaly:
			instantiated_anomaly = anomaly.new()
		else:
			instantiated_anomaly = null
var instantiated_anomaly: FloorModifier:
	set(x):
		instantiated_anomaly = x
		await NodeGlobals.until_ready(self)
		update_anomaly()

var quality: FloorModifier.ModType:
	get:
		if not instantiated_anomaly:
			return FloorModifier.ModType.NEGATIVE
		return instantiated_anomaly.get_mod_quality()

@onready var background: TextureRect = %Background
@onready var icon: TextureRect = %Icon

var hover_seq: Tween:
	set(x):
		if hover_seq and hover_seq.is_valid():
			hover_seq.kill()
		hover_seq = x

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	icon.mouse_entered.connect(hover)
	icon.mouse_exited.connect(stop_hover)

func update_anomaly() -> void:
	if not instantiated_anomaly:
		return

	background.self_modulate = QualityColors[quality]
	icon.texture = instantiated_anomaly.get_mod_icon()
	icon.position = instantiated_anomaly.get_icon_offset()

func hover() -> void:
	if not instantiated_anomaly:
		return

	HoverManager.hover(instantiated_anomaly.get_description(), 18, 0.025, instantiated_anomaly.get_mod_name(), QualityColors[quality].darkened(0.5))
	hover_seq = Sequence.new([
		LerpProperty.new(self, ^"scale", 0.1, Vector2.ONE * 1.15).interp(Tween.EASE_IN_OUT, Tween.TRANS_QUAD),
	]).as_tween(self)
	AudioManager.play_sound(HOVER_SFX, 6.0)

func stop_hover() -> void:
	HoverManager.stop_hover()
	hover_seq = Parallel.new([
		LerpProperty.new(self, ^"scale", 0.1, Vector2.ONE).interp(Tween.EASE_IN_OUT, Tween.TRANS_QUAD),
	]).as_tween(self)
