
  // Modules to require
  var glContext = require( "gl-context"       );
  var bigTri    = require( "a-big-triangle"   );
  var glslify   = require( "glslify"          );
  var glShader  = require( "gl-shader"        );


  document.body.style.margin = "0px";

  // Creating a canvas to draw on
  var canvas = document.createElement( "canvas" );
  document.body.appendChild( canvas );


  // Sets up an animation using the animate function
  var gl = glContext( canvas , {} , animate );



  // Setting canvas to be the proper size
  gl.viewport( 0 , 0 , window.innerWidth , window.innerHeight );
  canvas.width  = window.innerWidth;
  canvas.height = window.innerHeight;


  // Getting glsl to create our vertex
  // and fragment shaders
  var vs = glslify( "./vert.glsl" );
  var fs = glslify( "./frag.glsl" );

  var shader = glShader( gl , vs , fs ); 

  var uniforms = {
    
    time : 0,
    resolution : [ window.innerWidth , window.innerHeight ]

  }
 
  function animate( dT ){

    uniforms.time += dT;
    shader.bind();
    shader.uniforms = uniforms; 
    bigTri( gl );

  }



