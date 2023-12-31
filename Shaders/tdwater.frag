uniform sampler2D baseMap; 
uniform sampler2D extraMap;
varying vec4 Texcoord2;
uniform float time;
uniform float zoomscale;

//pixellate stuff
uniform float vx_offset;
uniform float screenWidth;
uniform float screenHeight;
uniform float pixel_w = 4.0;
uniform float pixel_h = 4.0;

//wave stuff
uniform vec2 WaveScale = vec2(3.25,3.3);
uniform float TimeScale = 30.0;
uniform float DistanceScale = 0.03;

void main()
{
  vec2 Texcoord = gl_TexCoord[0].xy;
  vec4 sample = texture2D(baseMap, Texcoord);

  if (sample.rgb == 0.0)
  {   
    //pixellate stuff     
    float dx = pixel_w*(zoomscale/screenWidth);
    float dy = pixel_h*(zoomscale/screenHeight);
    vec2 pixelcoord = vec2(dx*floor(Texcoord2.x/dx), dy*floor(Texcoord2.y/dy));
    Texcoord2.x = (pixelcoord.x);
    Texcoord2.y = (pixelcoord.y);

    Texcoord2.x /= zoomscale;
    Texcoord2.y /= zoomscale;
    Texcoord2 *= 8; // texture scale

    // wave stuff
    vec2 Wave1;
    Wave1.x = sin((time/TimeScale)+(Texcoord2.x+Texcoord2.y)*WaveScale.x)*DistanceScale,
    Wave1.y = cos((time/TimeScale)+(Texcoord2.x+Texcoord2.y)*WaveScale.y)*DistanceScale;

    vec4 wavesample1 = texture(extraMap, Texcoord2 + Wave1 );
    wavesample1.rgb += (Wave1.x-Wave1.y)*0.2;     

    //vec2 Wave2;
    //Wave2.x = sin((time/TimeScale)+(Texcoord2.x+Texcoord2.y)*WaveScale.x)*DistanceScale,
    //Wave2.y = cos((time/TimeScale)+(Texcoord2.x+Texcoord2.y)*WaveScale.y)*DistanceScale;
    //vec4 wavesample2 = texture(extraMap, Texcoord2 - Wave2 );
    //wavesample2.rgb += (Wave2.x+Wave1.y)*0.5;
    //sample.rgba = mix(wavesample1,wavesample2, 0.5);

    sample = wavesample1;
  }
  gl_FragColor = sample;
}

