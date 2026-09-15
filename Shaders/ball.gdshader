shader_type canvas_item;
uniform vec4 color : source_color;
uniform vec4 gold : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 pixel = texture(TEXTURE, UV);
	if(pixel.rgb == vec3(1, 1, 1))
	{
		COLOR = vec4(color.r, color.g, color.b, pixel.a);
	}
	else
	{
		vec2 scr = SCREEN_UV;
		mat2 rotational = mat2(vec2(sin(1), cos(1)), vec2(-cos(1), sin(1)));
		scr = rotational * scr;
		
		float value = sin(scr.x * 32.0);
		if(value < 0.8)
		{
			COLOR = vec4(gold.rgb, pixel.a);
		}else
		{
			COLOR = vec4(1, 1, 1, pixel.a);
		}

		
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
