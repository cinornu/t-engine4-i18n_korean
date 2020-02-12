uniform sampler2D tex; 
uniform float tick;
uniform float tick_start;
uniform float timeScale;

uniform float isPermanent;
uniform float coreRadiusMult;

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

vec4 GetFireWallColor(float currTime, vec2 pos, int layersCount, float layerWidth, float palettePos, float scrollSpeed, FireSettings fireSettings)
{
  float startPos = currTime * scrollSpeed;
  float layerDist = 1.0 / float(layersCount);
  float flameSkip = (floor((1.0 + layerWidth) / (layerDist)) + 1.0) * layerDist;

  vec4 resultColor = vec4(0.0, 0.0, 0.0, 0.0);
  int actualLayersCount = int(flameSkip / layerDist);

  if(pos.y < startPos - layerWidth)
    resultColor = Uberblend(texture2D(tex, vec2(palettePos, 0.99)), resultColor);

  for(int layerNumber = 0; layerNumber < actualLayersCount; layerNumber++)
  {
    int topIndex = int(floor(max(0.0, (startPos - flameSkip) / layerDist + 1.0)));
    int layerIndex = int(mod(float(layerNumber + topIndex), float(actualLayersCount)));
    float flamePos = startPos - float(layerIndex) * layerDist;
//    flamePos = fmod(flamePos + layerDist, 1.0 + layerDist) - layerDist;
    if(flamePos > 0.0)
      flamePos = mod(flamePos, flameSkip);
    vec2 resultPos = vec2(pos.x, 1.0 - (flamePos - pos.y) / layerWidth);
    resultPos.y = 1.0 - resultPos.y;
    vec4 flameColor = GetFireColor(currTime + float(layerIndex) * 10.0, resultPos, 0.25, fireSettings);
    resultColor = Uberblend(resultColor, flameColor);
//    resultColor = Uberblend(resultColor, GetCheckboardColor(resultPos) * (0.2));
  }

  return resultColor;
}


Intersection GetSphereIntersection(float currTime, Ray eyeRay)
{
  vec3 point = vec3(0.0, 0.2, 0.0);
  float radius = 0.17 * coreRadiusMult;

  radius = 0.45;
  point = vec3(0.0, 0.0, 0.0);
  
  vec3 xVector = normalize(cross(eyeRay.dir, vec3(0.0, 1.0, 0.0)));
  vec3 yVector = normalize(cross(eyeRay.dir, xVector));

  float scrollSpeed = 2.0;

  vec2 localCoords = vec2(dot(xVector, eyeRay.point - point), dot(yVector, eyeRay.point - point));
  float sinAng = length(localCoords) / radius;
  if(sinAng < 1.0)
  {
    float ang = asin(sinAng);
    vec2 planarCoords = normalize(localCoords) * ang;

    Intersection res;
    res.depth = dot(eyeRay.dir, point - eyeRay.point) - radius * cos(ang);

    FireSettings fireSettings;
    fireSettings.freqMult = 4.0;
    fireSettings.stretchMult = 2.0;
    fireSettings.ampMult = 0.4;
    fireSettings.scrollSpeed = vec2(5.0*0.0, 0.0);
    fireSettings.evolutionSpeed = 1.5;
//    planarCoords.y = 1.0 - planarCoords.y;
    vec2 flamePos = planarCoords * 0.3 + vec2(0.5, 0.5);
    flamePos.y = 1.0 - flamePos.y;
    res.color = GetFireWallColor(currTime + 0.2, flamePos, 4, 0.6, 0.25, scrollSpeed, fireSettings);
//    res.color = GetCheckboardColor(flamePos);
    vec3 intersectionPoint = eyeRay.point + eyeRay.dir * res.depth;
    res.color.rgb *= 1.0 + abs(intersectionPoint.z) * 1.5;
    if(res.color.a < 0.5) res.depth = 1e5;
      res.color.a *= 1.0 - pow(1.0 - shrinkPhase, 5.0);

    return res;
  }else
  {
    float width = radius * 0.25;
    float pi = 3.1415;
    vec2 polarPoint = vec2((atan(localCoords.x, -localCoords.y)) / (2.0 * pi) + 0.5, (length(localCoords) - radius + width * 0.2) / width);
    float bottomMult = min(polarPoint.x, 1.0 - polarPoint.x);
    bottomMult = 1.0 - pow(1.0 - bottomMult, 10.0);
    {
      float ratio = clamp(currTime * scrollSpeed * 0.8 + 0.1, 0.0, 1.0);
      if(polarPoint.x < 0.5)
      {
        polarPoint.x = 0.0 + (polarPoint.x) / ratio;
        if(polarPoint.x > 0.5)
        {
          Intersection res;
          res.depth = 1e5;
          res.color = vec4(0.0, 0.0, 0.0, 0.0);
          return res;
        }
      }
      else
      {
        polarPoint.x = 1.0 + (polarPoint.x - 1.0) / ratio;
        if(polarPoint.x < 0.5)
        {
          Intersection res;
          res.depth = 1e5;
          res.color = vec4(0.0, 0.0, 0.0, 0.0);
          return res;
        }
      }
      //polarPoint.y /= abs(polarPoint.x - 0.5) + ratio * ratio * ratio;
    }
    //polarPoint.x *= 2.1;

    float ratio = (1.0 - polarPoint.y) * 0.3;
    polarPoint.x = polarPoint.x + (-polarPoint.x + 0.5) * ratio;
    polarPoint.y /= bottomMult;
    polarPoint.y = 1.0 - polarPoint.y;
    
    if(polarPoint.x > 0.0 && polarPoint.x < 1.0 && polarPoint.y > 0.0 && polarPoint.y < 1.0)
    {
      FireSettings fireSettings;
      fireSettings.freqMult = 10.0;
      fireSettings.stretchMult = 20.0;
      fireSettings.ampMult = 0.4;
      fireSettings.scrollSpeed = vec2(5.0*0.0, 1.0);
      fireSettings.evolutionSpeed = 1.0;    

      Intersection res;
      res.color = GetFireColor(currTime, polarPoint, 0.25, fireSettings);
      res.depth = -eyeRay.point.z;
      if(res.color.a < 0.5) res.depth = 1e5;
      res.color.a *= 1.0 - pow(1.0 - shrinkPhase, 5.0);
      return res;
    }else
    {
      Intersection res;
      res.depth = 1e5;
      res.color = vec4(0.0, 0.0, 0.0, 0.0);
      return res;
    }
  }
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
  eyeRay.point.xy = pos - vec2(0.5, 0.5);

  Intersection sphereIntersection;
  sphereIntersection = GetSphereIntersection(currTime * 0.5, eyeRay);
  gl_FragColor = sphereIntersection.color;
  return;
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