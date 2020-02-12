uniform sampler2D tex;
uniform float tick;

void main(void)
{
	vec2 xy = gl_TexCoord[0].xy;
	vec4 p = vec4(0.0, 0.0, 0.0, 0.0);

	float kind = gl_TexCoord[0].x;

	// if (kind == 1.0) {
		float time = tick / 1000.0;

		vec2 ts = vec2(1.0, 1.0);
		vec2 tx = vec2(0.0, 0.0);
		vec2 mapCoord = vec2(0.0, 0.0);
		float attenuation = 2.0;
		// vec2 ts = texCoord.zw;
		// vec2 tx = texCoord.xy;
			xy.x = xy.x + sin(time);

		// xy = clamp(xy, texCoord.xy, texCoord.xy + texCoord.zw);
		p = texture2D(tex, xy);
		p.g = 0.0;
	// } else {
	// 	p = texture2D(tex, xy);
	// }

	gl_FragColor = p * gl_Color;
}
