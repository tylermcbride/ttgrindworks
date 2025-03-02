@tool
extends ShaderMaterial
class_name ColorOverlayMaterial

const SHADER = preload("res://general_resources/shaders/color_overlay.gdshader")

@export var test_color: Color = Color.WHITE
@export var test_time: float = 0.15
@export var test_strength: float = 0.75

@warning_ignore("unused_private_class_variable")
@export var _test_flash: bool:
	set(x):
		if Engine.is_editor_hint() and x:
			# Prevent annoying compilation issue
			var editor_interface = Engine.get_singleton("EditorInterface")
			flash(editor_interface.get_edited_scene_root(), test_color, test_time, test_strength)

var _flash_tween: Tween:
	set(x):
		if _flash_tween and _flash_tween.is_valid():
			_flash_tween.kill()
		_flash_tween = x

func _init() -> void:
	shader = SHADER
	set_strength(0.0)

func flash(owner: Node, color := Color.RED, time := 0.15, strength := 0.6) -> void:
	_flash_tween = Sequence.new([
		Func.new(set_color.bind(color)),
		Func.new(set_strength.bind(0.0)),
		LerpFunc.new(set_strength, time * 0.5, 0.0, strength).interp(Tween.EASE_IN, Tween.TRANS_LINEAR),
		LerpFunc.new(set_strength, time * 0.5, strength, 0.0).interp(Tween.EASE_OUT, Tween.TRANS_LINEAR),
	]).as_tween(owner)

func flash_instant(owner: Node, color := Color.RED, time := 0.15, strength := 0.6) -> void:
	_flash_tween = Sequence.new([
		Func.new(set_color.bind(color)),
		Func.new(set_strength.bind(strength)),
		Wait.new(time),
		Func.new(set_strength.bind(0.0)),
	]).as_tween(owner)

func set_strength(value: float) -> void:
	set_shader_parameter(&"strength", value)

func set_color(color: Color) -> void:
	set_shader_parameter(&"color", color)
