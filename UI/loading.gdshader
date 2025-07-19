shader_type canvas_item;

uniform float time = 0.0;
uniform vec4 spinner_color : source_color = vec4(1.0);
uniform float thickness = 0.08;
uniform float radius = 0.4;
uniform float angle_range = 0.7; // zwischen 0.0 und 1.0

void fragment() {
    vec2 uv = UV * 2.0 - 1.0;
    float r = length(uv);
    float a = atan(uv.y, uv.x);
    a = mod(a + time * 4.0, 6.2831); // Dreht sich

    float arc = 6.2831 * angle_range;

    float inside = smoothstep(radius, radius - thickness, r);
    float outside = smoothstep(radius + thickness, radius, r);
    float arc_mask = step(0.0, a) * step(a, arc);

    float mask = inside * outside * arc_mask;

    COLOR = spinner_color * mask;
}
