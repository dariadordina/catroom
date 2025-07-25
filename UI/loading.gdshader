shader_type canvas_item;

uniform float time_scale = 1.0;
uniform vec4 color = vec4(0.4, 1.0, 0.4, 1.0); // hellgrün
uniform float thickness = 0.2;
uniform float size = 0.9;

void fragment() {
	vec2 uv = (UV - vec2(0.5)) * 2.0; // Zentrum bei (0,0)
	float r = length(uv);
	float angle = atan(uv.y, uv.x);

	// Zeitabhängige Rotation (angle range: -PI bis PI)
	float t = TIME * time_scale;
	float arc = mod(angle - t, 6.283); // 2*PI

	// Spinner-Effekt: zeige nur ein Segment
	if (r < size && r > size - thickness && arc < 1.5) {
		COLOR = color;
	} else {
		COLOR = vec4(0.0);
	}
}
