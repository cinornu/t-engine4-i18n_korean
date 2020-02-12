uniform sampler2D tex;

void main(void)
{
	vec4 p = texture2D(tex, gl_TexCoord[0].xy);

	float v = gl_TexCoord[0].x;
	v = min(clamp(v * 2.0, 0.0, 1.0), clamp((1.0 - v) * 2.0, 0.0, 1.0));
	p.a *= v * v;

	gl_FragColor = p * gl_Color;
}
