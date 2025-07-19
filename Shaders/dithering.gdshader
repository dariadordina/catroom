shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

float get_bayer_threshold(vec2 pos) {
	int x = int(mod(pos.x, 8.0));
	int y = int(mod(pos.y, 8.0));
	int index = y * 8 + x;

	float thresholds[64] = float[](
		0.0, 32.0, 8.0, 40.0, 2.0, 34.0, 10.0, 42.0,
		48.0, 16.0, 56.0, 24.0, 50.0, 18.0, 58.0, 26.0,
		12.0, 44.0, 4.0, 36.0, 14.0, 46.0, 6.0, 38.0,
		60.0, 28.0, 52.0, 20.0, 62.0, 30.0, 54.0, 22.0,
		3.0, 35.0, 11.0, 43.0, 1.0, 33.0, 9.0, 41.0,
		51.0, 19.0, 59.0, 27.0, 49.0, 17.0, 57.0, 25.0,
		15.0, 47.0, 7.0, 39.0, 13.0, 45.0, 5.0, 37.0,
		63.0, 31.0, 55.0, 23.0, 61.0, 29.0, 53.0, 21.0
	);

	return thresholds[index] / 64.0;
}

void fragment() {
	vec2 screen_pos = FRAGCOORD.xy;
	vec2 uv = SCREEN_UV;
	vec4 col = texture(SCREEN_TEXTURE, uv);

	float t = get_bayer_threshold(screen_pos);

	vec3 result;
	result.r = col.r < t ? 0.0 : 1.0;
	result.g = col.g < t ? 0.0 : 1.0;
	result.b = col.b < t ? 0.0 : 1.0;

	COLOR = vec4(result, 1.0);
}
