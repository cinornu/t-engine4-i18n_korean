uniform sampler2D tex;
float antialiasingRadius = 0.99; //1.0 is no antialiasing, 0.0 - fully smoothed(looks worse)
uniform float tick;

float snoise( vec3 v );

vec4 Uberblend(vec4 col0, vec4 col1)
{
//  return vec4((1.0 - col0.a) * (col1.rgb) + col0.a * (col1.rgb * col1.a + col0.rgb * (1.0 - col1.a)), min(1.0, col0.a + col1.a));
//  return vec4((1.0 - col1.a) * (col0.rgb) + col1.a * (col1.rgb * col1.a + col0.rgb * (1.0 - col1.a)), min(1.0, col0.a + col1.a));
  return vec4(
    (1.0 - col0.a) * (1.0 - col1.a) * (col0.rgb * col0.a + col1.rgb * col1.a) / (col0.a + col1.a + 1e-2) +
    (1.0 - col0.a) * (0.0 + col1.a) * (col1.rgb) +
    (0.0 + col0.a) * (1.0 - col1.a) * (col0.rgb * (1.0 - col1.a) + col1.rgb * col1.a) +
    (0.0 + col0.a) * (0.0 + col1.a) * (col1.rgb),
    min(1.0, col0.a + col1.a));
}

#define samplesCount 80
void main(void)
{
	vec2 radius = vec2(0.5, 0.5) - gl_TexCoord[0].xy;
	float outerScale = 0.95 + sin(tick / 1000.0) * 0.05;
	float innerScale = 0.5;
	float shininess = 35.0;
	float density = 20.0;

	vec4 resultColor = vec4(0.0, 0.0, 0.0, 0.0);

	//sampleShine * len - simple
	//sampleShine * int[0, len](exp(-l*sampleAbsorb*)*dl ) = sampleShine * (1 - exp(-sampleAbsorb * len))/sampleAbsorb
	vec3 emittedColor = vec3(0.0, 0.0, 0.0);
	float absorb = 1.0;
	for(int i = 0; i < samplesCount; i++)
	{
		float scale = outerScale - float(i) / float(samplesCount) * (outerScale - innerScale);

		vec2 texPos = clamp(vec2(0.5, 0.5) + radius / scale, 0.0, 1.0);

		vec4 sampleColor = texture2D(tex, texPos);
		float sampleLen = 1.0 / float(samplesCount);

		float layerMult = float(i) / float(samplesCount);
		float shininessMult = 0.0;

		float sampleDensity = density * sampleColor.a * layerMult;
		shininessMult = absorb * (1.0 - exp(-sampleDensity * sampleLen)) / (sampleDensity + 1e-5);
		//shininessMult = absorb * sampleLen;

		emittedColor += sampleColor.rgb * (1.0 - pow(1.0 - sampleColor.a, 1.0)) * shininess * layerMult * shininessMult;

		absorb *= exp(-sampleLen * sampleDensity);
	}
	float shininessOpacity = 0.0;
	gl_FragColor = vec4(emittedColor.rgb, 1.0 - absorb + (emittedColor.r + emittedColor.g + emittedColor.b) * shininessOpacity);
	gl_FragColor.a *= gl_Color.a;
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

