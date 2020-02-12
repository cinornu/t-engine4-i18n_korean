// uniform sampler2D tex; 
// uniform vec2 texSize;
// uniform vec2 playerPos;
// uniform float innerRadius;
// uniform float outerRadius;
// uniform float tick_start;
// uniform float tick_real;
// uniform float growSpeed;

// float wave(float x)
// {
// 	return (-x*x*x / 3.0 + x*x / 2.0) * 6.0;
// }

// vec4 ConvertGrayscale(vec4 color)
// {
// 	float val = color.r * 0.299 + color.g * 0.587 + 0.114 * color.b;
// 	return vec4(val, val, val, color.a);
// }
// void main(void)
// {
// 	float growRatio = clamp((tick_real - tick_start) * growSpeed, 0.0, 1.0);
// 	growRatio = 1.0 - pow(1.0 - growRatio, 2.0);

// 	// float circleRatio = clamp((length(gl_FragCoord.xy - playerPos) - innerRadius) / (outerRadius - innerRadius), 0.0, 1.0);
// 	float circleRatio = clamp((length(gl_FragCoord.xy - vec2(playerPos.x, texSize.y - playerPos.y)) - innerRadius) / (outerRadius - innerRadius), 0.0, 1.0);

// 	float scale = growRatio * wave(circleRatio);

// 	vec4 backgroundColor = texture2D(tex, gl_FragCoord.xy / texSize);
// 	vec4 grayscaleColor = ConvertGrayscale(backgroundColor);
// 	gl_FragColor = scale * grayscaleColor + (1.0 - scale) * backgroundColor;
// 	return;
// }

uniform sampler2D tex; 
uniform vec2 texSize;
uniform vec2 playerPos;
uniform float innerRadius;
uniform float outerRadius;
uniform float tick_start;
uniform float tick_real;
uniform float growSpeed;

float wave(float x)
{
	return (-x*x*x / 3.0 + x*x / 2.0) * 6.0;
}

vec4 ConvertGrayscale(vec4 color, vec4 lowColor, vec4 highColor)
{
	float val = color.r * 0.299 + color.g * 0.587 + 0.114 * color.b;
	return highColor * val + lowColor * (1.0 - val);
}
void main(void)
{
	float growRatio = clamp((tick_real - tick_start) * growSpeed, 0.0, 1.0);
	growRatio = 1.0 - pow(1.0 - growRatio, 2.0);

	float _innerRadius = innerRadius + innerRadius * 0.1 * sin(tick_real * growSpeed / 3.0);
	float _outerRadius = outerRadius + outerRadius * 0.1 * cos(tick_real * growSpeed / 3.0);
	float circleRatio = clamp((length(gl_FragCoord.xy - vec2(playerPos.x, texSize.y - playerPos.y)) - _innerRadius) / (_outerRadius - _innerRadius), 0.0, 1.0);
	float scale = growRatio * wave(circleRatio);

	vec4 backgroundColor = texture2D(tex, gl_FragCoord.xy / texSize);

	vec4 highColor = vec4(243.0/255.0, 234.0/255.0, 255.0/255.0, 1.0);
	vec4 lowColor  = vec4(6.0/255.0  , 0.0  /255.0, 15.0 /255.0, 1.0);
	/*vec4 highColor = vec4(1.0, 1.0, 1.0, 1.0);
	vec4 lowColor  = vec4(0.0, 0.0, 0.0, 1.0);*/

	vec4 grayscaleColor = ConvertGrayscale(backgroundColor, lowColor, highColor);
	gl_FragColor = scale * grayscaleColor + (1.0 - scale) * backgroundColor;
	return;
}
