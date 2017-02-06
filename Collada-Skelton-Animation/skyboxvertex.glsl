#version 300 es


in vec4 position;
out vec4 boxposition;
uniform mat4 p;
uniform mat4 m;


void main()
{
    boxposition=position;
    
    gl_Position=p*m*position;
}
