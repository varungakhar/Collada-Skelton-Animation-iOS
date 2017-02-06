//
//  SkyBox.m
//  Collada-Skelton-Animation
//
//  Created by Varun on 01/02/17.
//  Copyright © 2017 X89. All rights reserved.
//
#define SIZE 2000

typedef struct
{
    float position[4];
    
}SkyboxVertex;

static SkyboxVertex skybox[]=
{
    SIZE, -SIZE, -SIZE,1.0,
    SIZE, SIZE, -SIZE, 1.0,
    SIZE, -SIZE, SIZE, 1.0,
    SIZE, -SIZE, SIZE,1.0,
    SIZE, SIZE, -SIZE,1.0,
    SIZE, SIZE,  SIZE,1.0,
    
    SIZE, SIZE, -SIZE, 1.0,
    -SIZE, SIZE, -SIZE,1.0,
    SIZE, SIZE, SIZE,  1.0,
    SIZE, SIZE, SIZE,  1.0,
    -SIZE, SIZE, -SIZE, 1.0,
    -SIZE, SIZE, SIZE,  1.0,
    
    -SIZE, SIZE, -SIZE, 1.0,
    -SIZE, -SIZE, -SIZE, 1.0,
    -SIZE, SIZE, SIZE,  1.0,
    -SIZE, SIZE, SIZE,  1.0,
    -SIZE, -SIZE, -SIZE,1.0,
    -SIZE, -SIZE, SIZE, 1.0,
    
    -SIZE, -SIZE, -SIZE,1.0,
    SIZE, -SIZE, -SIZE, 1.0,
    -SIZE, -SIZE, SIZE, 1.0,
    -SIZE, -SIZE, SIZE, 1.0,
    SIZE, -SIZE, -SIZE, 1.0,
    SIZE, -SIZE, SIZE,  1.0,
    
    SIZE, SIZE, SIZE,  1.0,
    -SIZE, SIZE, SIZE, 1.0,
    SIZE, -SIZE, SIZE, 1.0,
    SIZE, -SIZE, SIZE, 1.0,
    -SIZE, SIZE, SIZE, 1.0,
    -SIZE, -SIZE, SIZE,1.0,
    
    SIZE, -SIZE, -SIZE,1.0,
    -SIZE, -SIZE, -SIZE,1.0,
    SIZE, SIZE, -SIZE,1.0,
    SIZE, SIZE, -SIZE,1.0,
    -SIZE, -SIZE, -SIZE,1.0,
    -SIZE, SIZE, -SIZE,1.0,
    
    
};



#import "SkyBox.h"

@implementation SkyBox

-(id)init
{
    ProgramClass * programclass=[[ProgramClass alloc]init];
    
    skyboxprogram = [programclass program:@"skyboxvertex" fragment:@"skyboxfragment"];
    
    GLuint buffer=[self sendbuffer];
    
    skyboxvertex=[self setskboxvao:buffer];
    
    [self drawbox];
    
    return self;
    
}
-(void)render
{
    glUseProgram(skyboxprogram);
    glBindVertexArray(skyboxvertex);
    
    
    float ratio=[UIScreen mainScreen].bounds.size.width/[UIScreen mainScreen].bounds.size.height;
    GLKMatrix4 prespective = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(60), ratio, 0.1, 10000);
    
    GLKMatrix4 translate = GLKMatrix4MakeTranslation(0, 0, -1000);
    
    
    GLKMatrix4 model =GLKMatrix4Multiply(translate , _rotMatrix);
    
    glUniformMatrix4fv(glGetUniformLocation(skyboxprogram, "p"), 1, GL_FALSE, prespective.m);
    glUniformMatrix4fv(glGetUniformLocation(skyboxprogram, "m"), 1, GL_FALSE, model.m);
    
    
    glDrawArrays(GL_TRIANGLES, 0, sizeof(skybox)/sizeof(skybox[0]));
}

-(GLuint)sendbuffer
{
    GLuint buffer;
    
    glGenBuffers(1,&buffer);
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(skybox), skybox, GL_STATIC_DRAW);
    
    
    return buffer;
    
    
}
-(void)drawbox
{
    
    NSString *positivex=[[NSBundle mainBundle]pathForResource:@"right" ofType:@"png"
                         ];
    NSString *negativex=[[NSBundle mainBundle]pathForResource:@"right" ofType:@"png"
                         ];
    
    NSString *positivey=[[NSBundle mainBundle]pathForResource:@"right" ofType:@"png"
                         ];
    NSString *negativey=[[NSBundle mainBundle]pathForResource:@"right" ofType:@"png"
                         ];
    
    NSString *positivez=[[NSBundle mainBundle]pathForResource:@"right" ofType:@"png"
                         ];
    NSString *negativez=[[NSBundle mainBundle]pathForResource:@"right" ofType:@"png"
                         ];
    
    NSDictionary *dic=@{
                        GLKTextureLoaderOriginBottomLeft:[NSNumber numberWithBool:YES],
                        GLKTextureLoaderGenerateMipmaps:@(YES),
                        };
    
    NSArray *array=@[
                     negativex,positivex,positivey,negativey,positivez,negativez
                     ];
    
    NSError *err;
    
    
    GLKTextureInfo *texcube=[GLKTextureLoader cubeMapWithContentsOfFiles:array options:dic error:&err];
    if (err)
    {
        
        
        NSLog(@"%@",[err localizedDescription]);
        
    }
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_R, GL_REPEAT);
    
    glBindTexture(GL_TEXTURE_CUBE_MAP, texcube.name);
    
}

-(GLuint)setskboxvao:(GLuint)buffer
{
    GLuint vertexarray;
    
    glGenVertexArrays(1, &vertexarray);
    glBindVertexArray(vertexarray);
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glVertexAttribPointer(glGetAttribLocation(skyboxprogram, "position"), 4, GL_FLOAT, GL_FALSE, sizeof(float)*4, 0);
    glEnableVertexAttribArray(glGetAttribLocation(skyboxprogram, "position"));
    
    
    return vertexarray;
    
    
}

@end
