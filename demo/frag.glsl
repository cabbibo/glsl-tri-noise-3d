precision mediump float;

uniform float time;
uniform vec2  resolution;


const float INTERSECTION_PRECISION = .0001;
const float MAX_TRACE_DISTANCE     = 10.;
const int NUM_OF_TRACE_STEPS       = 40;

void doCamera( out vec3 camPos , out vec3 camTar , in float time ){

  float an = .3 + 10. * sin( time * .1 );
  camPos = vec3( 3.5 * sin( an ) , 0. , 3.5 * cos( an ));
  camTar = vec3( 0. );

}

mat3 calcLookAtMatrix( vec3 camPos , vec3 camTar , float roll ){

  vec3 up = vec3( sin( roll ) ,cos( roll ) , 0. );
  vec3 ww = normalize( camTar - camPos );
  vec3 uu = normalize( cross( ww , up ) );
  vec3 vv = normalize( cross( uu , ww ) );

  return mat3( uu , vv , ww );

}


vec2 map(){}



vec2 calcIntersection( in vec3 ro , in vec3 rd ){


}



void main(){

  vec2 p = ( -resolution + 2.0 * gl_FragCoord.xy ) / resolution.y;
    
  vec3 ro , ta;
  doCamera( ro , ta , time , 1. );
  
  mat3 camMat = calcLookAtMatrix( ro , ta , 0. ); 
 
  // z = lens length 
  vec3 rd = normalize( camMat * vec3( p.xy , 2. ) ); 
 
  vec2 intersection = calcIntersction( ro , rd );



  vec3 col = vec3( 1. , uv.x , uv.y );

  gl_FragColor = vec4( col , 1. );

}
