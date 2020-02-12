uniform sampler2D tex;
uniform float intensity;
uniform float fade;
uniform float tick;

void main(void)
{
	vec2 pos = gl_TexCoord[0].xy;
	vec4 c = texture2D(tex, pos);

	float v = gl_TexCoord[0].x;
	v = min(clamp(v * 2.0, 0.0, 1.0), clamp((1.0 - v) * 2.0, 0.0, 1.0));
	c.a *= v * v * intensity;
	if (intensity < 1.0) c.a *= v;
	c *= gl_Color;

	if (fade > 0.0) {
		c.a *= fade;
	}

	gl_FragColor = c;
}
