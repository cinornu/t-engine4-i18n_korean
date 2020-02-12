uniform sampler2D tex;
float antialiasingRadius = 0.99; //1.0 is no antialiasing, 0.0 - fully smoothed(looks worse)
uniform float tick;
uniform float tick_start;
uniform float side;
uniform float coneAngle;
uniform float topTransperency;
uniform float twist;
uniform float isSphere;
uniform float growSpeed;

uniform float cylinderRadius;
uniform float cylinderHeight;

uniform float scrollingSpeed;

uniform float shininess;
uniform float density;
#define stepSize 5e-3


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

float noise1d(float x)
{
  return texture2D(tex, vec2(mod(x, 1.0) * 0.4 + 0.55, 0.25)).r;
}

void main(void)
{

  vec2 pos = vec2(0.5, 0.5) - gl_TexCoord[0].xy;

  vec4 resultColor = vec4(0.0, 0.0, 0.0, 0.0);

  float absorb = 1.0;

  vec3 emittedColor = vec3(0.0, 0.0, 0.0);



  float dist = 2.0;
  vec3 rayDir = normalize(vec3(0.0, -0.5, 1.0));
  vec3 xVector = normalize(cross(vec3(0.0, 1.0, 0.0), rayDir));
  vec3 yVector = cross(rayDir, xVector);

  vec3 rayPoint = vec3(0.0, dist * 0.5 + cylinderHeight * 0.5, -dist) + xVector * pos.x + yVector * pos.y;

  float alpha = tick * scrollingSpeed;
  mat2 rotation = mat2(
    cos(alpha), sin(alpha),
    -sin(alpha), cos(alpha));

  float tangent = tan(coneAngle);

  if(abs(pos.x) < cylinderRadius)
  {
    float localWidth = sqrt(cylinderRadius * cylinderRadius - pos.x * pos.x);
    vec3 startPoint = rayPoint + rayDir * (-localWidth - rayPoint.z) / rayDir.z;
    vec3 endPoint = rayPoint + rayDir * ( localWidth - rayPoint.z) / rayDir.z;
    if (startPoint.y < 0.0)
    {
      startPoint = rayPoint + rayDir * (0.0 - rayPoint.y) / rayDir.y;
    }
    if (endPoint.y < 0.0)
    {
      endPoint = rayPoint + rayDir * (0.0 - rayPoint.y) / rayDir.y;
    }
    float height = cylinderHeight * clamp((tick - tick_start) * growSpeed, 0.0, 1.0);
    if (startPoint.y > height)
    {
      startPoint = rayPoint + rayDir * (height - rayPoint.y) / rayDir.y;
    }
    if (endPoint.y > height)
    {
      endPoint = rayPoint + rayDir * (height - rayPoint.y) / rayDir.y;
    }


    if(side == 1.0)
    {
      if(endPoint.z > 0.0)
        endPoint = rayPoint + rayDir * (0.0 - rayPoint.z) / rayDir.z;
      if(startPoint.z > 0.0)
        startPoint = rayPoint + rayDir * (0.0 - rayPoint.z) / rayDir.z;
    }

    if(side == 2.0)
    {
      if(endPoint.z < 0.0)
        endPoint = rayPoint + rayDir * (0.0 - rayPoint.z) / rayDir.z;
      if(startPoint.z < 0.0)
        startPoint = rayPoint + rayDir * (0.0 - rayPoint.z) / rayDir.z;
    }


    int samplesCount = int(length(endPoint - startPoint) / stepSize);
    if(samplesCount > 0)
    {
      vec3 travelDir = normalize(endPoint - startPoint);


      for(int i = 0; i < samplesCount; i++)
      {
        vec3 point = startPoint + travelDir * stepSize * float(i);

        float beta = alpha + point.y * twist;
        mat2 rotation = mat2(
          cos(beta), sin(beta),
          -sin(beta), cos(beta));

        vec2 planePoint = rotation * point.xz;
        planePoint *= (1.0 + (cylinderHeight - point.y) * tangent);
        float normCoord = (point.y - cylinderHeight * 0.5) / (cylinderHeight * 0.5);
        if(isSphere > 0.5)
        {
          float sqrMult = 1.0 - normCoord * normCoord;
          if(sqrMult < 0.0) continue;
          planePoint /= sqrt(sqrMult);
        }
        vec2 texPos = clamp(planePoint / cylinderRadius * 0.5 + vec2(0.5, 0.5), 0.0, 1.0);
        vec4 sampleColor = texture2D(tex, texPos);

        float ratio = clamp(1.0 - point.y / cylinderHeight, 0.0, 1.0);
        sampleColor *= topTransperency * (1.0 - ratio) + 1.0 * ratio;

        float sampleLen = stepSize;

        float sampleDensity = density * sampleColor.a;

        float shininessMult = absorb * (1.0 - exp(-(sampleDensity + 1e-2) * sampleLen)) / (sampleDensity + 1e-2);
//				float shininessMult = absorb * (1.0 - exp(-(sampleDensity + 1e-5) * sampleLen)) / (sampleDensity + 1e-5) * sampleColor.a;

        emittedColor += sampleColor.rgb * shininessMult * shininess;
        absorb *= exp(-sampleLen * sampleDensity);
      }
      gl_FragColor = vec4(emittedColor.rgb, 1.0 - absorb);
//      gl_FragColor = vec4(emittedColor.rgb * (1.0 - absorb + shininess), 1.0 - absorb);
//			gl_FragColor = vec4(emittedColor.rgb, 1.0 - absorb + (emittedColor.r + emittedColor.g + emittedColor.b) * shininessOpacity);
      return;
    }
  }
  gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
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

