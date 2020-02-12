uniform sampler2D tex; 
uniform float tick;
uniform float tick_start;
uniform float timeScale;

uniform float isPermanent;
uniform float side;

float shrinkPhase;

float snoise( vec3 v );
float rand(int offset)
{
  return snoise(vec3(float(offset) * 0.5 + 0.7, 0.0, 0.0)) * 0.5 + 0.5;
}

vec4 Uberblend(vec4 col0, vec4 col1);

struct Ray
{
  vec3 point;
  vec3 dir;
};
struct Plane
{
  vec3 point;
  vec3 normal;
};
vec3 GetRayPlaneIntersection(Ray ray, Plane plane)
{
  float mult = 1.0 / dot(ray.dir, plane.normal);
  return ray.point + ray.dir * (dot(plane.point, plane.normal) - dot(ray.point, plane.normal)) * mult;
}

struct Intersection
{
  vec4 color;
  float depth;
};

vec4 GetCheckboardColor(vec2 pos);

struct FireSettings
{
  float freqMult;
  float stretchMult;
  float ampMult;
  vec2 scrollSpeed; //3.0
  float evolutionSpeed; //0.1
};

vec4 GetFireColor(float currTime, vec2 pos, float palettePos, FireSettings settings);


float GetHeight(vec2 pos)
{
  /*float len = dot(pos, pos);
  return 0.3-len * 3.0;*/
  float len = length(pos) * 15.0;
  return (len * len / 15.0 - len * len * len * len / 650.0) / 15.0 + pos.y * 0.1;
  /*float len = length(pos);
  if(len > 0.2)
  {
    len -= 0.2;
    return 0.05 + -(len * len * len * len) * 15.0 + pos.y * 0.1;
  }else
  {
    float ratio = len / 0.2;
    return 0.05 - (ratio - 1.0) * (ratio - 1.0) * 0.2 + pos.y * 0.1;
  }*/
}



Intersection GetVortexIntersection(float currTime, Ray eyeRay)
{
  vec3 point = vec3(0.05, 0.0, -0.25);
  float startMin = -1.1;
  float startMax = 2.0;
  float minLen = startMin;
  float maxLen = startMax;
  float phase = 0.5 + clamp(currTime * 1.0, 0.0, 0.5);
  for(int i = 0; i < 15; i++)
  {
    /*g(x) = 0; 
    f(x) = g(x) + x;
    x = f(x) -> g(x) = 0;*/
    float midLen = (minLen + maxLen) / 2.0;
    vec3 rayPoint = eyeRay.point + eyeRay.dir * midLen - point;
    vec3 surfacePoint = vec3(rayPoint.x, GetHeight(rayPoint.xz), rayPoint.z);
    if(rayPoint.y > surfacePoint.y) 
    {
      /*Intersection res;
      res.depth = 0.0;
      res.color = GetCheckboardColor((eyeRay.point + eyeRay.dir * res.depth).xz);
      return res;*/

      minLen = midLen;
    }
    else
    {
      /*Intersection res;
      res.depth = 10.0;
      res.color = GetCheckboardColor((eyeRay.point + eyeRay.dir * res.depth).xz);
      return res;*/
      maxLen = midLen;
    }
  }
  Intersection res;
  res.depth = (minLen + maxLen) / 2.0;
  vec3 surfacePoint = (eyeRay.point + eyeRay.dir * res.depth - point);
  if(surfacePoint.z > 0.0 && side == 1.0 || surfacePoint.z < 0.0 && side == 2.0)
  {
    res.depth = 1e5;
    res.color = vec4(0.0, 0.0, 0.0, 0.0);
    return res;
  }
  if(abs(res.depth - startMin) < 1e-2 || abs(res.depth - startMax) < 1e-2)
  {
    res.depth = 1e5;
    res.color = vec4(0.0, 0.0, 0.0, 0.0);
  }else
  {
    float pi = 3.1415;
    vec2 polarPoint = vec2(atan(surfacePoint.z, surfacePoint.x) / (2.0 * pi) + 0.5, length(surfacePoint.xz) * 1.6);
    polarPoint.y /= phase;
    float shrinkMult = 1.0 - pow(clamp(1.0-shrinkPhase, 0.01, 0.99), 10.0);
    //polarPoint.y /= shrinkMult * 0.3 + 0.7;

    polarPoint.y = (polarPoint.y - 0.45) / 0.55;
    res.color = GetCheckboardColor(polarPoint);

    FireSettings fireSettings;
    fireSettings.freqMult = 10.0;
    fireSettings.stretchMult = 7.0;
    fireSettings.ampMult = 0.4;
    fireSettings.scrollSpeed = vec2(5.0*0.0, 1.0);
    fireSettings.evolutionSpeed = 1.0;
    polarPoint.y = (polarPoint.y + 0.0) / 1.0;
    if(polarPoint.y < 0.02) polarPoint.y = 0.02;
    polarPoint.y = 1.0 - polarPoint.y;
    res.color = GetFireColor(currTime, polarPoint, 0.25, fireSettings);
    res.color.a *= 1.0 - pow(clamp(1.0-shrinkPhase, 0.0, 1.0), 10.0);
//    res.color = GetCheckboardColor(polarPoint);
  }
  return res;
}


struct ArcSettings
{
  float radius;
  float width;
  float length;
  float growthTime;
  Plane plane;
  vec4 color;
};

Intersection GetFireArcIntersection(float currTime, Ray ray, ArcSettings arcSettings)
{
  Intersection res;
  res.depth = 1e5;
  res.color = vec4(0.0, 0.0, 0.0, 0.0);
  vec3 xVector = normalize(cross(arcSettings.plane.normal, vec3(0.0, 1.0, 0.0)));
  vec3 zVector = arcSettings.plane.normal;
  vec3 yVector = cross(xVector, zVector);

  vec3 intersection = GetRayPlaneIntersection(ray, arcSettings.plane);
  if(intersection.y < 0.0) return res;
  if(intersection.z > 0.0 && side == 1.0 || intersection.z < 0.0 && side == 2.0)
    return res;

  vec2 planarIntersection = vec2(dot(xVector, (intersection - arcSettings.plane.point)), dot(yVector, (intersection - arcSettings.plane.point)));
  float radiusLen = length(planarIntersection);	

  float pi = 3.1415;
  vec2 polarPos = vec2(atan(planarIntersection.x, planarIntersection.y), radiusLen);

  //return GetCheckboardColor(polarPos);

  vec2 planarPos;
  float cosAlpha = dot(arcSettings.plane.normal, vec3(0.0, 1.0, 0.0));
  float height = arcSettings.plane.point.y / sqrt(1.0 - cosAlpha * cosAlpha);

  planarPos.x = (polarPos.x + pi) / (2.0 * pi);
  planarPos.y = (polarPos.y - (arcSettings.radius - arcSettings.width)) / arcSettings.width;
  float sideRatio = arcSettings.length * arcSettings.radius / arcSettings.width;


  float yScale = 1.0 - planarPos.x / arcSettings.length;

//  planarPos.y = 1.0 - (1.0 - planarPos.y) / (1.0 - pow(clamp(1.0 - yScale, 0.0, 1.0), 2.0));
  if(yScale < 0.0)
    return res;
  if(planarPos.y > 0.5)
    planarPos.y = 0.5 + (planarPos.y - 0.5) / yScale; 
  else
    planarPos.y = 0.5 - (0.5 - planarPos.y) / yScale; 

  FireSettings fireSettings;
  fireSettings.freqMult = 10.0 * sideRatio * arcSettings.width * 3.1;
  fireSettings.stretchMult = 18.0 * sideRatio;
  fireSettings.ampMult = 0.5;
  fireSettings.scrollSpeed = vec2(5.0*0.0, 3.0);
  fireSettings.evolutionSpeed = 1.5;

  float ratio1 = 0.3;
  float ratio2 = 0.4;


  float timeOffset = 0.0;
  res.depth = dot((intersection - ray.point), ray.dir);
  if(planarPos.y > ratio2)
  {
    planarPos.y -= ratio2;
    planarPos.y /= 1.0 - ratio2;
    timeOffset = 10.0;
  }else
  if(planarPos.y < ratio1)
  {
    planarPos.y = ratio1 - planarPos.y;
    planarPos.y /= ratio1;
    timeOffset = 0.0;
  }else
  if(planarPos.y > ratio1 && planarPos.y < ratio2 && planarPos.x > 0.0 && planarPos.x < 1.0)
  {
    res.color = texture2D(tex, vec2(0.25, 0.99));
    return res;
  }
  //return vec4(0.0, 0.0, 1.0, 1.0);

  planarPos.x -= planarPos.y * 0.02;

  res.color = GetFireColor(currTime + timeOffset, vec2(planarPos.x, 1.0 - planarPos.y), 0.25, fireSettings);
  //res.color = GetCheckboardColor(planarPos);
  return res;
}

#define arcsCount 8
void main(void)
{
  vec2 pos = gl_TexCoord[0].xy;
  pos.y = 1.0 - pos.y;

  float currTime = max(0.0, tick - tick_start) / 1000.0 * timeScale;
  shrinkPhase = 1.0;
  if(isPermanent < 0.5) 
    shrinkPhase = clamp(1.5 - currTime * 1.0, 0.0, 1.0);


  /*FireSettings fireSettings;
  fireSettings.freqMult = 4.0;
  fireSettings.stretchMult = 2.0;
  fireSettings.ampMult = 0.4;
  fireSettings.scrollSpeed = vec2(5.0*0, 0.0);
  fireSettings.scrollSpeed.y = 0.0;
  fireSettings.evolutionSpeed = 1.0;
  gl_FragColor = GetFireWallColor(currTime, pos * 2.0 - 0.5, 4.0, 0.6, 0.25, 0.2, fireSettings);
  return;*/

  if(shrinkPhase < 1e-3)
  {
    gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
    return;
  }
  float pi = 3.1415;
  vec3 groundAxis = normalize(vec3(0.5, -0.6, -0.9));
  vec3 groundPos = vec3(0.0, 0.0, 0.0);

  float defRadius = 0.25;

  Ray eyeRay;
  eyeRay.point.xy = pos - vec2(0.5, 0.5) + vec2(0.0, 0.25); //0.5
  eyeRay.point.z = -2.0;
  eyeRay.dir = normalize(vec3(0.0, -0.0, 0.8));
  Intersection sphereIntersection;
  sphereIntersection.depth = 1e5;
  sphereIntersection.color = vec4(0.0, 0.0, 0.0, 0.0);
  Intersection vortexIntersection = GetVortexIntersection(currTime * 0.5, eyeRay);

  ArcSettings arcs[arcsCount];
  arcs[0].plane.point = vec3(0.27, 0.20, 0.0);
  arcs[0].plane.normal = normalize(vec3(0.3, -0.3, 0.5));
  arcs[0].radius = 1.5 * defRadius;
  arcs[0].width = 1.3 * defRadius;
  arcs[0].length = 0.65;
  arcs[0].growthTime = 0.3;
  arcs[0].color = vec4(0.6, 0.6, 0.6, 1.0);

  arcs[1].plane.point = vec3(0.13, 0.20, 0.0);
  arcs[1].plane.normal = normalize(vec3(0.45, -0.3, 0.5));
  arcs[1].radius = 1.4 * defRadius;
  arcs[1].width = 0.5 * defRadius;
  arcs[1].length = 0.6;
  arcs[1].growthTime = 0.4;
  arcs[1].color = vec4(0.6, 0.6, 0.8, 1.0);

  arcs[7].plane.point = vec3(0.05, 0.20, 0.0);
  arcs[7].plane.normal = normalize(vec3(0.6, -0.3, 0.5));
  arcs[7].radius = 2.7 * defRadius;
  arcs[7].width = 2.8 * defRadius;
  arcs[7].length = 0.6;
  arcs[7].growthTime = 0.0;
  arcs[7].color = vec4(0.6, 0.6, 0.8, 1.0);

  ////////
  arcs[2].plane.point = vec3(-0.2, 0.1, 0.0);
  arcs[2].plane.normal = normalize(vec3(0.12, 0.3, -0.11));
  arcs[2].radius = 1.8 * defRadius;
  arcs[2].width = 1.3 * defRadius;
  arcs[2].length = 0.7;
  arcs[2].growthTime = 0.4;
  arcs[2].color = vec4(0.6, 0.6, 0.8, 1.0);

  arcs[3].plane.point = vec3(-0.2, 0.13, 0.0);
  arcs[3].plane.normal = normalize(vec3(0.2, 0.3, -0.13));
  arcs[3].radius = 2.1 * defRadius;
  arcs[3].width = 2.2 * defRadius;
  arcs[3].length = 0.7;
  arcs[3].growthTime = 0.7;
  arcs[3].color = vec4(0.6, 0.6, 0.8, 1.0);

  arcs[4].plane.point = vec3(-0.2, 0.16, 0.0);
  arcs[4].plane.normal = normalize(vec3(0.23, 0.3, -0.11));
  arcs[4].radius = 1.6 * defRadius;
  arcs[4].width = 0.8 * defRadius;
  arcs[4].length = 0.7;
  arcs[4].growthTime = 0.6;
  arcs[4].color = vec4(0.6, 0.6, 0.8, 1.0);

  arcs[5].plane.point = vec3(-0.0, 0.17, 0.0);
  arcs[5].plane.normal = normalize(vec3(0.25, 0.3, -0.15));
  arcs[5].radius = 2.9 * defRadius;
  arcs[5].width = 3.0 * defRadius;
  arcs[5].length = 0.6;
  arcs[5].growthTime = 0.0;
  arcs[5].color = vec4(0.6, 0.6, 0.8, 1.0);

//  arcs[6].plane.point = vec3(-0.1, 0.25, 0.0);
  arcs[6].plane.point = vec3(-0.1, 0.25, -0.35);
  arcs[6].plane.normal = normalize(vec3(0.35, 0.3, -0.13));
  arcs[6].radius = 1.4 * defRadius;
  arcs[6].width = 0.5 * defRadius;
  arcs[6].length = 0.6;
  arcs[6].growthTime = 0.6;
  arcs[6].color = vec4(0.6, 0.6, 0.8, 1.0);

  vec4 resultColor = sphereIntersection.color;
  float resultDepth = sphereIntersection.depth;
  if(vortexIntersection.depth < sphereIntersection.depth)
  {
    resultColor = Uberblend(resultColor, vortexIntersection.color);
    resultDepth = vortexIntersection.depth;
  }
  float growthTimeMult = 0.7;
  shrinkPhase = 1.0 - pow(1.0 - shrinkPhase, 3.0);
  for(int arcIndex = 0; arcIndex < arcsCount; arcIndex++)
  {
    float phase = clamp((currTime - arcs[arcIndex].growthTime * growthTimeMult) * 1.0, 0.0, 1.0);
    float lengthMult = 1.0 - pow(1.0 - phase, 10.0);
    arcs[arcIndex].length *= lengthMult;
    arcs[arcIndex].radius *= 0.7 + shrinkPhase * 0.3;
    arcs[arcIndex].width *= shrinkPhase;

    Intersection arcIntersection= GetFireArcIntersection(
      currTime * 0.5 + float(arcIndex) * 3.7, 
      eyeRay, 
      arcs[arcIndex])/* * arcs[arcIndex].color*/;
    arcIntersection.color.a *= 1.0 - pow(1.0 - shrinkPhase, 5.0);
    if(arcIntersection.depth < resultDepth && arcIntersection.color.a > 0.5)
    {
      resultDepth = arcIntersection.depth;
      resultColor = Uberblend(resultColor, arcIntersection.color);
    }
  }

  //resultColor.a *= 0.3;
  gl_FragColor = resultColor;
  //gl_FragColor = sphereIntersection.color;
  /*if(abs(vortexIntersection.depth - 2.0) < 1e-2)
    gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
  else
    gl_FragColor = vec4((vortexIntersection.depth - 1.0) * 2.0, 0.0, 0.0, 1.0);*/

  //vec4 color = GetFireColor(tick / 5000.0, pos, 0.25, settings);
  //vec3 shininessColor = color.rgb * color.a * 0.1;
  //gl_FragColor = vec4(color.rgb * color.a + shininessColor, color.a);
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

float GetFireDelta(float currTime, vec2 pos, FireSettings settings)
{
  //firewall
  float delta = 0.0;
//	pos.y += (1.0 - pos.y) * 0.5;
  //pos.y += 0.5;
  pos.y /= settings.stretchMult;
  pos *= settings.freqMult;
  pos += currTime * settings.scrollSpeed;

//	pos.y -= currTime * 3.0;
  delta += snoise(vec3(pos * 1.0, currTime * 1.0 * settings.evolutionSpeed)) * 1.5;
  delta += snoise(vec3(pos * 2.0, currTime * 2.0 * settings.evolutionSpeed)) * 1.5;
  delta += snoise(vec3(pos * 4.0, currTime * 4.0 * settings.evolutionSpeed)) * 1.5;	
  delta += snoise(vec3(pos * 8.0, currTime * 8.0 * settings.evolutionSpeed)) * 1.5;
  delta += snoise(vec3(pos * 16.0, currTime * 16.0 * settings.evolutionSpeed)) * 0.5;

  return delta;
}

vec4 GetFireColor(float currTime, vec2 pos, float palettePos, FireSettings settings)
{
  vec4 fireColor = vec4(0.0, 0.0, 0.0, 0.0);
  if(pos.x > 0.0 && pos.x < 1.0 && pos.y > 0.0 && pos.y < 1.0)
  {
    /*if(mod(pos.x, 0.1) < 0.05 ^ mod(pos.y, 0.1) < 0.05)
      return vec4(pos.x, pos.y, 0, 1);
    else
      return vec4(0, 0, 0, 1);*/
    float delta = GetFireDelta(currTime, pos, settings);
    delta *= min(1.0, max(0.0, 1.0 * (1.0 - pos.y)));
    delta *= min(1.0, max(0.0, 1.0 * (0.0 + pos.y)));
    vec2 displacedPoint = vec2(palettePos, pos.y) + vec2(0, delta * settings.ampMult);
    displacedPoint.y = min(0.99, displacedPoint.y);
    displacedPoint.y = max(0.01, displacedPoint.y);
    
    fireColor = texture2D(tex, displacedPoint);
  }
  return fireColor;
}

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


vec4 GetCheckboardColor(vec2 pos)
{
  vec4 col = vec4(0.0, 0.0, 0.0, 0.0);
  if(pos.x > 0.0 && pos.x < 1.0 && pos.y > 0.0 && pos.y < 1.0)
  {
    if(mod(pos.x, 0.1) < 0.05 ^^ mod(pos.y, 0.1) < 0.05)
      col = vec4(1.0, 1.0, 1.0, 1.0);
    else
      col = vec4(0.5, 0.5, 0.5, 1.0);
  }
  return col;
}