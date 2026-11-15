shader_type canvas_item;

void fragment() {
	vec4 c = texture(TEXTURE, UV);
	float l = dot(c.rgb, vec3(0.3, 0.59, 0.11));
	vec3 lush = vec3(l * 0.6, l * 1.1 + 0.05, l * 0.5);
	COLOR = vec4(mix(c.rgb, lush, 0.8), c.a);
}
