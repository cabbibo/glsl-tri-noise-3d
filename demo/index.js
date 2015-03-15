
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
  canvas.width  = window.innerWidth/4;
  canvas.height = window.innerHeight/4;
  canvas.style.width  = "100%";
  canvas.style.height = "100%";
  gl.viewport( 0 , 0 , canvas.width , canvas.height );


  // Getting glsl to create our vertex
  // and fragment shaders
  var vs = glslify( "./vert.glsl" );
  var fs = glslify( "./volume.glsl" );

  var shader = glShader( gl , vs , fs ); 

  var uniforms = {
    
    time : 0,
    resolution : [ canvas.width , canvas.height ]

  }

  var start = Date.now();
  function animate( dT ){

    uniforms.time =( Date.now() - start ) / 1000.;
    shader.bind();
    shader.uniforms = uniforms; 
    bigTri( gl );

  }



