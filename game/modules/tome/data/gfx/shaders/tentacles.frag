uniform sampler2D tex;
uniform float tick;
uniform float tick_start;
uniform float time_factor;
uniform float noup;
uniform float wobblingType;
uniform float appearTime; //normalized appearence time. min: 0.01, max: 3.0, default: 1.0f
uniform float backgroundLayersCount;

vec2 Rotate(vec2 point, float ang)
{
	return vec2(
		point.x * cos(ang) - point.y * sin(ang),
		point.x * sin(ang) + point.y * cos(ang));
}

vec4 Uberblend(vec4 col0, vec4 col1)
{
//  return vec4((1.0 - col0.a) * (col1.rgb) + col0.a * (col1.rgb * col1.a + col0.rgb * (1.0 - col1.a)), min(1.0, col0.a + col1.a));
//  return vec4((1.0 - col1.a) * (col0.rgb) + col1.a * (col1.rgb * col1.a + col0.rgb * (1.0 - col1.a)), min(1.0, col0.a + col1.a));
	return vec4(
		(1.0 - col0.a) * (1.0 - col1.a) * (col0.rgb * col0.a + col1.rgb * col1.a) / (col0.a + col1.a + 1e-1) +
		(1.0 - col0.a) * (0.0 + col1.a) * (col1.rgb) +
		(0.0 + col0.a) * (1.0 - col1.a) * (col0.rgb * (1.0 - col1.a) + col1.rgb * col1.a) +
		(0.0 + col0.a) * (0.0 + col1.a) * (col1.rgb),
		min(1.0, col0.a + col1.a));
}

float GetDistortionRange(const int layerIndex, vec2 texPos)
{
	vec2 layerOffsets[4];
	layerOffsets[0] = vec2(0.0, 0.0);
	layerOffsets[1] = vec2(0.5, 0.0);
	layerOffsets[2] = vec2(0.0, 0.5);
	layerOffsets[3] = vec2(0.5, 0.5);

	return texture2D(tex, (texPos * 0.5 + layerOffsets[layerIndex]) * vec2(0.5, 1.0) + vec2(0.5, 0.0)).r;
}

vec4 GetColor(const int layerIndex, vec2 texPos)
{
	vec2 layerOffsets[4];
	layerOffsets[0] = vec2(0.0, 0.0);
	layerOffsets[1] = vec2(0.5, 0.0);
	layerOffsets[2] = vec2(0.0, 0.5);
	layerOffsets[3] = vec2(0.5, 0.5);

	return texture2D(tex, (texPos * 0.5 + layerOffsets[layerIndex]) * vec2(0.5, 1.0));
}

vec2 GetDistortion(vec2 texPos, int layerIndex, int distortionType, float deformRate)
{
	float layerIndexF = float(layerIndex);
	if (distortionType == 0) {
		float alpha = 0.2 * sin(tick / time_factor * (layerIndexF * 0.5 + 1.0) + layerIndexF * 100.0) * deformRate;
		mat2 rotation = mat2(cos(alpha), sin(alpha), -sin(alpha), cos(alpha));

		return clamp(rotation * (texPos - vec2(0.5)) + vec2(0.5), 0.01, 0.99);
	} else if (distortionType == 1) {
		float phase = length(texPos - vec2(0.5));
		float alpha = 0.2 * sin(-tick / time_factor * (layerIndexF * 0.5 + 1.0) + phase * 30.0 + layerIndexF * 100.0) * deformRate;
		mat2 rotation = mat2(cos(alpha), sin(alpha), -sin(alpha), cos(alpha));

		return clamp(rotation * (texPos - vec2(0.5)) + vec2(0.5), 0.01, 0.99);

		return clamp(texPos, 0.01, 0.99);
	}
	return clamp(texPos, 0.01, 0.99);
}


float snoise( vec3 v );

void main(void)
{
	vec2 pos = gl_TexCoord[0].xy;
	float appearPhase = clamp((tick - tick_start) / time_factor / appearTime, 0.0, 1.0);
	vec4 resultColor = vec4(0.0, 0.0, 0.0, 0.0);

	const int layersCount = 4;

	int distortionType = int(wobblingType + 0.5);

	int backLayersCount = int(backgroundLayersCount + 0.5);
	for(int layerIndex = 0; layerIndex < 4; layerIndex++)
	{
		if(noup == 1.0 && layerIndex < backLayersCount) continue;
		if(noup == 2.0 && layerIndex >= backLayersCount) continue;
		float deformRate = GetDistortionRange(layerIndex, pos);
		vec2 texPos = GetDistortion(pos, layerIndex, distortionType, deformRate);
		vec4 layerColor = GetColor(layerIndex, texPos);
    //float alphaThreshold = 1.0 - clamp(appearPhase / mix(0.5, 1.0, deformRate), 0.0, 1.0);
    float alphaThreshold = clamp(1.0 - 2.0 * appearPhase + deformRate, 0.0, 1.0);
    layerColor.a = max(0.0, layerColor.a - alphaThreshold) / (1.0 - alphaThreshold + 1e-4);
		resultColor = Uberblend(resultColor, layerColor);
	}
	/*float deformRate = pos.x;
	float alpha = 3.0 * sin(tick / time_factor) * pow(deformRate, 3.0);
	mat2 rotation = mat2(cos(alpha), sin(alpha), -sin(alpha), cos(alpha));
	resultColor = texture2D(tex, vec2(0.5) + (pos - vec2(0.5)) * rotation);*/
	//resultColor = texture2D(tex, pos);

	gl_FragColor = resultColor * gl_Color;
}


vec4 permute( vec4 x ) {

	return mod( ( ( x * 34.0 ) + 1.0 ) * x, 289.0 );

}

vec4 taylorInvSqrt( vec4 r ) {

	return 1.79284291400159 - 0.85373472095314 * r;

}


float snoise( vec3 v ) {

	const vec2 C = vec2( 1.0 / 6.0, 1.0 / 3.0 );
	const vec4 D = vec4( 0.0, 0.5, 1.0, 2.0 );

	// First corner

	vec3 i  = floor( v + dot( v, C.yyy ) );
	vec3 x0 = v - i + dot( i, C.xxx );

	// Other corners

	vec3 g = step( x0.yzx, x0.xyz );
	vec3 l = 1.0 - g;
	vec3 i1 = min( g.xyz, l.zxy );
	vec3 i2 = max( g.xyz, l.zxy );

	vec3 x1 = x0 - i1 + 1.0 * C.xxx;
	vec3 x2 = x0 - i2 + 2.0 * C.xxx;
	vec3 x3 = x0 - 1. + 3.0 * C.xxx;

	// Permutations

	i = mod( i, 289.0 );
	vec4 p = permute( permute( permute(
		i.z + vec4( 0.0, i1.z, i2.z, 1.0 ) )
		+ i.y + vec4( 0.0, i1.y, i2.y, 1.0 ) )
		+ i.x + vec4( 0.0, i1.x, i2.x, 1.0 ) );

	// Gradients
	// ( N*N points uniformly over a square, mapped onto an octahedron.)

	float n_ = 1.0 / 7.0; // N=7

	vec3 ns = n_ * D.wyz - D.xzx;

	vec4 j = p - 49.0 * floor( p * ns.z *ns.z );  //  mod(p,N*N)

	vec4 x_ = floor( j * ns.z );
	vec4 y_ = floor( j - 7.0 * x_ );    // mod(j,N)

	vec4 x = x_ *ns.x + ns.yyyy;
	vec4 y = y_ *ns.x + ns.yyyy;
	vec4 h = 1.0 - abs( x ) - abs( y );

	vec4 b0 = vec4( x.xy, y.xy );
	vec4 b1 = vec4( x.zw, y.zw );


	vec4 s0 = floor( b0 ) * 2.0 + 1.0;
	vec4 s1 = floor( b1 ) * 2.0 + 1.0;
	vec4 sh = -step( h, vec4( 0.0 ) );

	vec4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
	vec4 a1 = b1.xzyw + s1.xzyw * sh.zzww;

	vec3 p0 = vec3( a0.xy, h.x );
	vec3 p1 = vec3( a0.zw, h.y );
	vec3 p2 = vec3( a1.xy, h.z );
	vec3 p3 = vec3( a1.zw, h.w );

	// Normalise gradients

	vec4 norm = taylorInvSqrt( vec4( dot( p0, p0 ), dot( p1, p1 ), dot( p2, p2 ), dot( p3, p3 ) ) );
	p0 *= norm.x;
	p1 *= norm.y;
	p2 *= norm.z;
	p3 *= norm.w;

	// Mix final noise value

	vec4 m = max( 0.6 - vec4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
	m = m * m;
	return 42.0 * dot( m*m, vec4( dot( p0, x0 ), dot( p1, x1 ),
		dot( p2, x2 ), dot( p3, x3 ) ) );
}
