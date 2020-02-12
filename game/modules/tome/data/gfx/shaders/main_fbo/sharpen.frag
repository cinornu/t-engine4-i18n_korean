uniform float sharpen_power;
uniform vec2 texSize;
uniform sampler2D tex;

void main(void) {
	float step_w = 1.0 / texSize.x;
	float step_h = 1.0 / texSize.y;

	float kernel[9];
	vec2 offset[9];

	offset[0] = vec2(-step_w, -step_h);
	offset[1] = vec2(0.0, -step_h);
	offset[2] = vec2(step_w, -step_h);
	offset[3] = vec2(-step_w, 0.0);
	offset[4] = vec2(0.0, 0.0);
	offset[5] = vec2(step_w, 0.0);
	offset[6] = vec2(-step_w, step_h);
	offset[7] = vec2(0.0, step_h);
	offset[8] = vec2(step_w, step_h);


	/* SHARPEN KERNEL
	 0 -1  0
	-1  5 -1
	 0 -1  0
	*/

	// float power = 2.0;
	float rest = -(sharpen_power - 1.0) / 4.0;

	kernel[0] = 0.;
	kernel[1] = rest;
	kernel[2] = 0.;
	kernel[3] = rest;
	kernel[4] = sharpen_power;
	kernel[5] = rest;
	kernel[6] = 0.;
	kernel[7] = rest;
	kernel[8] = 0.;

	vec4 sum = vec4(0.0);
	int i;

	for (i = 0; i < 9; i++) {
			vec4 color = texture2D(tex, gl_TexCoord[0].xy + offset[i]);
			sum += color * kernel[i];
	}
	gl_FragColor = sum;
}
