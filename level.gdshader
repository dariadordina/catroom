shader_type canvas_item;

uniform float time;
uniform float intensity = 0.002; // Schwache Wellen
uniform sampler2D screen_tex : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 uv = UV;

    // 1. Subtile Wellen
    uv.y += sin(uv.x * 0.5 + time * 1.5) * intensity;
    uv.x += sin(uv.y * 0.5 + time * 1.2) * intensity * 0.5;

    // 2. Distanz zum Bildzentrum (0.5, 0.5)
    float dist_to_center = distance(uv, vec2(0.5));
    float blur_strength = smoothstep(0.0, 0.6, dist_to_center); // 0 nahe Kamera, 1 am Rand

    // 3. Blur auf Basis der Entfernung
    vec4 col = texture(screen_tex, uv);
    col += texture(screen_tex, uv + vec2(0.001, 0.001) * blur_strength);
    col += texture(screen_tex, uv - vec2(0.001, 0.001) * blur_strength);
    col += texture(screen_tex, uv + vec2(-0.001, 0.001) * blur_strength);
    col += texture(screen_tex, uv + vec2(0.001, -0.001) * blur_strength);
    col /= 5.0;

    // 4. Farbfilter für "Katzenblick"
    float r = dot(col.rgb, vec3(0.2, 0.6, 0.2)); // Rot schwächer
    float g = dot(col.rgb, vec3(0.3, 0.6, 0.1));
    float b = dot(col.rgb, vec3(0.2, 0.3, 0.5));
    COLOR = vec4(r, g, b, col.a);
}
