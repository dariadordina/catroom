shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

float get_bayer_threshold(vec2 pos) {
	int x = int(mod(pos.x, 4.0));
	int y = int(mod(pos.y, 4.0));
	int index = y * 4 + x;

	float thresholds[16] = float[](
		0.0,  8.0,  2.0, 10.0,
		12.0, 4.0, 14.0, 6.0,
		3.0, 11.0, 1.0, 9.0,
		15.0, 7.0, 13.0, 5.0
	);

	return thresholds[index] / 16.0;
}

void fragment() {
	vec2 uv = SCREEN_UV;
	vec4 col = texture(SCREEN_TEXTURE, uv);

	// Berechne Grauwert
	float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));

	// Hole Threshold aus Bayer-Matrix
	vec2 screen_pos = FRAGCOORD.xy;
	float threshold = get_bayer_threshold(screen_pos);

	// Dithering anwenden
	float dithered = gray < threshold ? 0.0 : 1.0;

	COLOR = vec4(vec3(dithered), 1.0);
}
