#version 300 es
precision lowp float;


in vec2 entitytexout;
out vec4 fragcolor;
uniform sampler2D entityimage;

void main()
{
  fragcolor=texture(entityimage,entitytexout);
}
