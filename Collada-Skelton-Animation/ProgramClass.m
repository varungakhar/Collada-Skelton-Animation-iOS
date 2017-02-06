//
//  ProgramClass.m
//  Collada-Skelton-Animation
//
//  Created by Varun on 31/01/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import "ProgramClass.h"

@implementation ProgramClass





-(GLuint)createshader:(NSString*)name type:(GLuint)type
{
    GLuint shader = glCreateShader(type);
    
    NSString *shadername=[[NSBundle mainBundle]pathForResource:name ofType:@"glsl"];
    NSString *shadersource=[NSString stringWithContentsOfFile:shadername encoding:NSUTF8StringEncoding error:nil];
    const char *shaderstring = [shadersource UTF8String];
    glShaderSource(shader, 1, &shaderstring, 0);
    glCompileShader(shader);
    
    GLint status;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
    if (status==GL_FALSE)
    {
        GLchar message[256];
        glGetShaderInfoLog(shader, sizeof(message),0, &message[0]);
        NSString *string=[[NSString alloc]initWithUTF8String:message];
        NSLog(@"%@",string);
    }
    
    
    return shader;
}

-(GLuint)program:(NSString*)vertex fragment:(NSString*)fragment
{
    GLuint vertexshader,fragmentshader;
    
    GLuint program;
    
    vertexshader=[self createshader:vertex type:GL_VERTEX_SHADER];
    fragmentshader=[self createshader:fragment type:GL_FRAGMENT_SHADER];
    
    
    program = glCreateProgram();
    glAttachShader(program, vertexshader);
    glAttachShader(program, fragmentshader);
    glLinkProgram(program);
    
    GLint status;
    glGetProgramiv(program, GL_LINK_STATUS, &status);
    if (status==GL_FALSE)
    {
        GLchar message[256];
        glGetProgramInfoLog(program, sizeof(message),0, &message[0]);
        NSString *string=[[NSString alloc]initWithUTF8String:message];
        NSLog(@"%@",string);
    }
    
    
    return program;
    
    
}
@end
