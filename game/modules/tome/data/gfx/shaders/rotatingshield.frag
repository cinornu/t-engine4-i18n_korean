uniform sampler2D tex;
uniform float tick;
uniform float tick_start;
uniform float time_factor;
uniform float noup;
uniform float cylinderRotationSpeed; //rotation speed of the aura, min: 0, max: 10, def: 1
uniform float cylinderRadius; //radius of the cylinder aura. min: 0.2, max: 0.5, def: 0.45
uniform float cylinderVerticalPos; //vertical position of the cylinder. 0 is in the middle. min: -0.2, max: 0.2
uniform float cylinderHeight; //height of the cylinder. min: 0.1, max: 1.0, default: 0.4
uniform float appearTime; //normalized appearence time. min: 0.01, max: 3.0, default: 1.0f
uniform float repeatTimes;
uniform float unbalancedSize;

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

void main(void)
{
  vec2 pos = vec2(0.5, 0.5) - gl_TexCoord[0].xy;

  vec4 resultColor = vec4(0.0, 0.0, 0.0, 0.0);

  float dist = 2.0;
  vec3 rayDir = normalize(vec3(0.0, -0.5, 1.0));
  vec3 xVector = normalize(cross(vec3(0.0, 1.0, 0.0), rayDir));
  vec3 yVector = cross(rayDir, xVector);

  vec3 rayPoint = vec3(0.0) - rayDir * dist + xVector * pos.x + yVector * pos.y;

  float normTime = (tick - tick_start) / time_factor;
  float alpha = normTime * cylinderRotationSpeed;

  if(abs(pos.x) < cylinderRadius)
  {
    float localWidth = sqrt(cylinderRadius * cylinderRadius - pos.x * pos.x);
    vec3 startPoint = rayPoint + rayDir * (-localWidth - rayPoint.z) / rayDir.z;
    vec3 endPoint = rayPoint + rayDir * ( localWidth - rayPoint.z) / rayDir.z;

    vec3 cylinderPoint;
    if(noup == 1.0)
    {
      cylinderPoint = startPoint;
    }else
    if(noup == 2.0)
    {
      cylinderPoint = endPoint;
    }
    float farRatio = (cylinderPoint.z - (-cylinderRadius)) / (2.0 * cylinderRadius);
    float farDarkening = mix(1.0, 0.1, farRatio);

    vec2 planarPos;
    planarPos.y = (cylinderPoint.y + cylinderHeight * 0.5 + cylinderVerticalPos) / cylinderHeight;
    planarPos.y = 1.0 - planarPos.y;
    planarPos.y = 0.5 + (planarPos.y - 0.5) * (1.0 + cylinderPoint.z * 0.5);
    planarPos.x = mod((atan(cylinderPoint.z, cylinderPoint.x) + alpha) / (2.0 * 3.1415), 1.0);

    if(planarPos.y < 1.0 && planarPos.y > 0.0)
    {
      float glowMult = 1.0 + mix(3.0, 0.0, clamp(normTime / (appearTime * 1.5 + 1e-4), 0.0, 1.0));
      float alphaSub = 1.0 - clamp(normTime / (appearTime + 1e-4), 0.0, 1.0);;
      planarPos.x *= repeatTimes;
      planarPos.x = clamp(planarPos.x, 0.0, unbalancedSize);
      resultColor = texture2D(tex, planarPos);
      resultColor.rgb *= farDarkening;
      resultColor.rgb *= glowMult;
      resultColor.a = (resultColor.a - alphaSub) / (1.0 - alphaSub + 1e-4);
    }
  }
  gl_FragColor = resultColor * gl_Color;
}
