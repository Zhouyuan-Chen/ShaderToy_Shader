/*
着色器输入
uniform vec3      iResolution;           // viewport resolution (in pixels)
uniform float     iTime;                 // shader playback time (in seconds)
uniform float     iTimeDelta;            // render time (in seconds)
uniform int       iFrame;                // shader playback frame
uniform float     iChannelTime[4];       // channel playback time (in seconds)
uniform vec3      iChannelResolution[4]; // channel resolution (in pixels)
uniform vec4      iMouse;                // mouse pixel coords. xy: current (if MLB down), zw: click
uniform samplerXX iChannel0..3;          // input channel. XX = 2D/Cube
uniform vec4      iDate;                 // (year, month, day, time in seconds)
uniform float     iSampleRate;           // sound sample rate (i.e., 44100)
*/

float hash21(vec2 p){
    float seed = dot(p,vec2(3325.1,7765.2));
    return -1.0 + 2.0*fract(sin(seed + 3333.1)*cos(seed*9666.4 + 663.1));
}

float remap(t){
    return sin(t);
}

float noiseValue(vec2 uv){
    vec2 base = floor(uv);
    float v_00 = hash21(uv);
    float v_10 = hash21(uv+vec2(1.0,0.0));
    float v_01 = hash21(uv+vec2(0.0,1.0));
    float v_11 = hash21(uv+vec2(1.0,1.0));
    return mix(mix(v_00,v_10,remap(fract(uv.x))),mix(v_01,v_11,remap(fract(uv.x))),remap(fract(uv.y)));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;

    // Time varying pixel color
    vec2 col = vec2(noiseValue(uv),noiseValue(uv));

    // Output to screen
    fragColor = vec4(col,1.0,1.0);
}