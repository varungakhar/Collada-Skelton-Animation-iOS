#version 300 es

const int MAX_JOINTS = 50;
const int MAX_WEIGHTS = 3;
in vec4 entityposition;
in vec2 entitytexin;
in vec3 entitynormal;
out vec2 entitytexout;
in ivec3 in_jointIndices;
in vec3 in_weights;
uniform mat4 jointTransforms[MAX_JOINTS];
uniform mat4 prespective;
uniform mat4 view;
uniform mat4 model;

void main()
{
    vec4 totalLocalPos = vec4(0.0);
    vec4 totalNormal = vec4(0.0);
    
    for(int i=0;i<MAX_WEIGHTS;i++)
    {
        vec4 localPosition = jointTransforms[in_jointIndices[i]] * entityposition;
        totalLocalPos += localPosition * in_weights[i];
      vec4 worldNormal = jointTransforms[in_jointIndices[i]] * vec4(entitynormal, 0.0);
      totalNormal += worldNormal * in_weights[i];
    }
    entitytexout=entitytexin;
    gl_Position=prespective*view*model*totalLocalPos;
}
