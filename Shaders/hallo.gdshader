shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

float atan2(float x, float y)
{
	if(y != 0.0)
	{
		float phi = atan(abs(y/x));
		if(x > 0.0)
		{
			return (y>0.0) ? phi : -phi;
		}
		else if (x < 0.0)
		{
			return (y>0.0) ? (PI - phi) : -(PI - phi);
		}
		else
		{
			return (y>0.0) ? (PI/2.0) : -(PI/2.0);
		}
	}else
	{
		if(x>0.0)
		{
			return 0.0;
		}
		else
		{
			return PI;
		}
	}
}

void fragment() {
	vec2 new_uv = UV - vec2(0.5, 0.5);
	float angle = atan2(new_uv.x, new_uv.y);
	float waves = sin((angle + TIME) * 10.0);
	float fall_off = max(0.0, 1.0-((new_uv.x * new_uv.x * 4.0) + (new_uv.y * new_uv.y * 4.0)));
	COLOR = vec4(1, 1, 1, fall_off*waves);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
