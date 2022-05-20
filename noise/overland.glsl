//https://www.shadertoy.com/view/Nd3cR4

#define delta 0.000001

float differentiate(float t0,float v0,float v1){
   float t1 = t0 + delta;
   float val0 = (v0-v1)*(2.0*t0*t0*t0-3.0*t0*t0);
   float val1 = (v0-v1)*(2.0*t1*t1*t1-3.0*t1*t1);
   return (val1 - val0)/delta;
}

// by morimea
float hash(vec2 p){
	vec3 p3  = fract(vec3(p.xyx) * .1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

float remap(float t){
    return -2.0*t*t*t + 3.0*t*t;
    //return sin(t);
}

vec3 getNormal(vec2 p){
    vec3 normal = vec3(0.0);
    
    //v0  v1
    //v2  v3
    float Amplify = 1.0; 
    float offset = 4.0;
    for(int i=0;i<5;i++){
        vec2 base = floor(p*offset);
        vec2 t = fract(p*offset);
        vec2 cood0 = base;
        vec2 cood1 = base + vec2(1.0,0.0);
        vec2 cood2 = base + vec2(0.0,1.0);
        vec2 cood3 = base + vec2(1.0,1.0);
        
        float val0 = hash(cood0)*Amplify;
        float val1 = hash(cood1)*Amplify;
        float val2 = hash(cood2)*Amplify;
        float val3 = hash(cood3)*Amplify;

        float top = mix(val0,val1,remap(t.x));
        float bot = mix(val2,val3,remap(t.x));
        float lef = mix(val0,val2,remap(t.y));
        float rig = mix(val1,val3,remap(t.y));

        vec3 d_x = vec3(delta,.0,differentiate(t.x,lef,rig));
        vec3 d_y = vec3(delta,.0,differentiate(t.y,top,bot));
        normal += cross(d_x,d_y);
        Amplify /= 2.0;
        offset *= 2.0;
    }

    return normalize(normal);
}

//67 142 219

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    
    // strench the canvas
    uv.y /= iResolution.x / iResolution.y;

    // Time varying pixel color
    float tim = iTime * 0.05;
    
    vec3 n = getNormal(uv+tim);
    
    vec3 col = n;
    col = cross(col,vec3(67.0/255.0,142.0/255.0,219.0/255.0));

    // Output to screen
    fragColor = vec4(col,1.0);
}