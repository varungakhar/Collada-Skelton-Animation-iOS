#version 300 es
precision lowp float;

out vec4 outcolor;
uniform samplerCube box;

in vec4 boxposition;


void main()
{
    outcolor=texture(box,boxposition.xyz);
    
}
