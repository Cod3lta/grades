shader_type canvas_item;

uniform vec3 color;
uniform sampler2D image;

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 mask_color = texture(image, UV).rgba;
	COLOR = vec4(color.r, color.g, color.b, mask_color.a);
}