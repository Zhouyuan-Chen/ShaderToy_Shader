float hash(vec2 p){
    return fract(sin(p.x * 3331.0+6337.6)+cos(p.y * 9946.1+3333.0));
}

float remap(float t){
    return -2.0*t*t*t + 3.0*t;
}

float noise(vec2 p){
    vec2 base = floor(p);
    vec2 t = fract(p);
    t.x = remap(t.x);
    t.y = remap(t.y);
    
    //v0  v1
    //v2  v3
    vec2 cood0 = base;
    vec2 cood1 = base + vec2(1.0,0.0);
    vec2 cood2 = base + vec2(0.0,1.0);
    vec2 cood3 = base + vec2(1.0,1.0);
    
    float val0 = hash(cood0);
    float val1 = hash(cood1);
    float val2 = hash(cood2);
    float val3 = hash(cood3);
    
    float top = mix(val0,val1,t.x);
    float bot = mix(val2,val3,t.x);
    
    return mix(top,bot,t.y);
}

float fbm(vec2 p){
    float n = noise(p*4.0);
    n += noise(p*8.0)*0.5;
    n += noise(p*16.0)*0.25;
    n += noise(p*32.0)*0.125;
    n += noise(p*64.0)*0.0625;
    return n;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;

    // Time varying pixel color
   float tim = iTime * 0.2;
    
    float a = fbm( uv + fbm( uv + mod( tim, 200.0 ) ) );
    
    
    vec3 col = vec3( a );

    // Output to screen
    fragColor = vec4(col,1.0);
}