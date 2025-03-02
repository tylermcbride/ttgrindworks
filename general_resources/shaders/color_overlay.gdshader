shader_type spatial;
render_mode unshaded;

uniform vec3 color = vec3(1.0);
uniform float strength = 0.75;

void fragment() {
	ALBEDO = color;
	ALPHA = strength;
}