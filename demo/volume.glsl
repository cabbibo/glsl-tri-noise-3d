precision mediump float;

uniform float time;
uniform vec2  resolution;

const float INTERSECTION_PRECISION = .01;
const float MAX_TRACE_DISTANCE     = 10.;
const int NUM_TRACE_STEPS          = 100;

#pragma glslify: noise  = require('../triNoise3D.glsl')
#pragma glslify: hsv    = require('glsl-hsv2rgb')

void doCamera( out vec3 camPos , out vec3 camTar , in float time ){

  float an = .3 + 10. * sin( time * .1 );
  camPos = vec3( 3.5 * sin( an ) , 0. , 3.5 * cos( an ));
  camTar = vec3( 0. );

}

void setCol( out vec3 col ){

  col = vec3( 1. , 1. , 0. );

}

mat3 calcLookAtMatrix( vec3 camPos , vec3 camTar , float roll ){

  vec3 up = vec3( sin( roll ) ,cos( roll ) , 0. );
  vec3 ww = normalize( camTar - camPos );
  vec3 uu = normalize( cross( ww , up ) );
  vec3 vv = normalize( cross( uu , ww ) );

  return mat3( uu , vv , ww );

}


vec2 map( vec3 pos ){

  float d = noise( pos * .1 , 1.1  , time );

  return vec2( length( pos ) - (d * .5 + .5) , 1. );


}


// res = result;
vec2 calcIntersection( in vec3 ro , in vec3 rd ){

  float h     = INTERSECTION_PRECISION * 2.;
  float t     = 0.;
  float res   = -1.;
  float id    = -1.;

  for( int i = 0; i < NUM_TRACE_STEPS; i++ ){
      
    if( h < INTERSECTION_PRECISION || t > MAX_TRACE_DISTANCE ) break;
    
    vec2 m = map( ro + rd * t );
  
    h  = m.x;
    t += h;
    id = m.y;

  }

  if( t < MAX_TRACE_DISTANCE ) res = t;
  if( t > MAX_TRACE_DISTANCE ) id = -1.;

  return vec2( res , id ); 

}



vec3 calcNormal( vec3 pos ){  

  vec3 eps = vec3( 0.01 , 0. , 0. );
  
  vec3 nor = vec3(  
    map( pos + eps.xyy ).x - map( pos - eps.xyy ).x,
    map( pos + eps.yxy ).x - map( pos - eps.yxy ).x,
    map( pos + eps.yyx ).x - map( pos - eps.yyx ).x
  );

  return normalize( nor );
  

}

vec3 calcFog( in vec3 ro , in vec3 rd ){

  vec3 col = vec3( 0.);

  float h     = INTERSECTION_PRECISION * 2.;
  float t     = 0.;

  for( int i = 0; i < NUM_TRACE_STEPS; i++ ){
    //col += vec3( noise( pos ) );
    vec3 pos =  ro + rd * t ;
    float n = noise( pos * .1 , 1.1  , time  );
    col += hsv( vec3(abs(sin(n * 7.)) , 1. , 1.) ) * n;
    t += .1;

  } 

  col /= float( NUM_TRACE_STEPS );

  return col;

}


void main(){

  vec2 p = ( -resolution + 2.0 * gl_FragCoord.xy ) / resolution.y;
    
  vec3 ro , ta;
  
  doCamera( ro , ta , time  );

  mat3 camMat = calcLookAtMatrix( ro , ta , 0. ); 
 
  // z = lens length 
  vec3 rd = normalize( camMat * vec3( p.xy , 2. ) ); 
  vec3 col =  calcFog( ro , rd );

  gl_FragColor = vec4( col , 1. );

}
