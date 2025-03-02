@tool
extends TextureRect

## Randomize the static every frame
func _process(_delta : float) -> void:
	var static_texture : FastNoiseLite = texture.noise
	if not Engine.is_editor_hint():
		static_texture.seed = RandomService.randi_channel('true_random')
	else:
		static_texture.seed = randi()

func set_alpha(alpha : float) -> void:
	modulate.a = alpha
