//
//  SceneLoader.m
//  Collada-Skelton-Animation
//
//  Created by Varun on 31/01/17.
//  Copyright © 2017 X89. All rights reserved.


typedef struct
{
    float position[4];
    float texture[2];
    float normal[3];
    int jointindices[3];
    float weights[3];
    
    
}ColladaVertex;


#import "SceneLoader.h"

GLushort *ColladaIndices;
ColladaVertex *colladavertices;

@implementation SceneLoader

-(id)init
{
    programclass=[[ProgramClass alloc]init];
    entityarray=[[NSMutableArray alloc]init];
    [self createGeometery];
    
    return self;
}
-(void)createGeometery
{
    NSURL *url=[[NSBundle mainBundle]URLForResource:@"CharacterRunning" withExtension:@"txt"];
    
    NSData *data=[NSData dataWithContentsOfURL:url];

    SMXMLDocument *document=[SMXMLDocument documentWithData:data error:nil];
    
    NSDictionary *detaildict=@{@"document":document,@"texture":@"CharacterRunning.png",@"name":@"CharacterRunning"};
    
 GLuint program = [programclass program:@"entityvertex" fragment:@"entityfragment"];

    ColladaLoader *collada=[[ColladaLoader alloc]init];
    modeldata = [collada loadColladaModel:document maxweights:3];
    AnimationData *animdata=[collada loadColladaAnimation:document];
    loader=[[AnimatedModelLoader alloc]init];
    joints = [loader compileanimation:modeldata animdata:animdata];
    [self createentity:detaildict];
    [self CreateBufferForEntity:[detaildict valueForKey:@"name"]];
    [self createvao:[detaildict valueForKey:@"name"] program:program];
}
-(void)update
{
    loader.frametime=_frametime;
    [loader update];
    [self renderentity:@"CharacterRunning"];
}
-(void)createentity:(NSDictionary *)DetailDict
{
 
 NSArray * verticesarray = modeldata.mesh.vertexarray;
    NSArray *  normalarray = modeldata.mesh.normalarray;
    NSArray * texturearray = modeldata.mesh.texturearray;
 NSArray * forindices = modeldata.mesh.indicesarray;
    NSInteger temp=modeldata.mesh.temp;
    
    
    
     NSInteger j=0;
     colladavertices=(ColladaVertex *)malloc(sizeof(colladavertices)*forindices.count*10);
     ColladaIndices = malloc(sizeof(colladavertices)*forindices.count*10);
     for (NSInteger i=0; i<forindices.count; i=i+temp)
     {
         
     NSString *vertex= [forindices objectAtIndex:i];
     NSString *normal= [forindices objectAtIndex:i+1];
     NSString *texture=[forindices objectAtIndex:i+2];
NSDictionary *dictvalues=[verticesarray objectAtIndex:[vertex intValue]];
    VertexSkinData *SkinData=[dictvalues valueForKey:@"jointweight"];
    NSValue *vertexvalue = [dictvalues valueForKey:@"vertices"];
     NSValue *normalvalue=[normalarray objectAtIndex:[normal intValue]];
     NSValue *texturevalue=[texturearray objectAtIndex:[texture intValue]];
     
     GLKVector3 vertexvector;
     [vertexvalue getValue:&vertexvector];
     GLKVector3 normalvector;
     [normalvalue getValue:&normalvector];
     GLKVector2 texturevector;
     [texturevalue getValue:&texturevector];
     
     j=i/temp;
     
     colladavertices[j].position[0]= vertexvector.x;
     colladavertices[j].position[1]= vertexvector.y;
     colladavertices[j].position[2]= vertexvector.z;
     colladavertices[j].position[3]= 1;
     
     colladavertices[j].normal[0]= normalvector.x;
     colladavertices[j].normal[1]= normalvector.y;
     colladavertices[j].normal[2]= normalvector.z;
     
     colladavertices[j].texture[0]= texturevector.x;
     colladavertices[j].texture[1]= texturevector.y;
         
         colladavertices[j].jointindices[0]=[SkinData.jointIds[0]intValue];
         colladavertices[j].jointindices[1]=[SkinData.jointIds[1]intValue];
         colladavertices[j].jointindices[2]=[SkinData.jointIds[2]intValue];
         

         colladavertices[j].weights[0]=[SkinData.weights[0]floatValue];
         colladavertices[j].weights[1]=[SkinData.weights[1]floatValue];
         colladavertices[j].weights[2]=[SkinData.weights[2]floatValue];
         
         
     
     
     ColladaIndices[j]=j;
     
     }
     
     
     UIImage *image=[UIImage imageNamed:[DetailDict valueForKey:@"texture"]];
     
     
     NSDictionary *dicttex=@{
     GLKTextureLoaderOriginBottomLeft:[NSNumber numberWithBool:YES]
     };
     
     GLKTextureInfo *info1= [GLKTextureLoader textureWithCGImage:[image CGImage] options:dicttex error:nil];
     
     if (!info1)
     {
     info1= [GLKTextureLoader textureWithCGImage:[image CGImage] options:dicttex error:nil];
     }
     
     glActiveTexture(GL_TEXTURE0);
     
     glBindTexture(GL_TEXTURE_2D, info1.name);
     
     int entityindices=sizeof(GLushort)*(int)(forindices.count/temp);
     int  entityvertices =(int)(forindices.count/temp)*sizeof(ColladaVertex);
     
     NSMutableDictionary *geometerydict=[[NSMutableDictionary alloc]init];
     
     [geometerydict setValue:[NSNumber numberWithInt:entityindices] forKey:@"entityindices"];
     [geometerydict setValue:[NSNumber numberWithInt:entityvertices] forKey:@"entityvertices"];
     [geometerydict setValue:[NSNumber numberWithInt:0] forKey:@"buffer"];
     [geometerydict setValue:[NSNumber numberWithInt:0] forKey:@"vao"];
     [geometerydict setValue:[NSNumber numberWithInt:info1.name] forKey:@"texture"];
     [geometerydict setValue:[DetailDict valueForKey:@"name"] forKey:@"name"];
     [geometerydict setValue:[NSNumber numberWithInt:0] forKey:@"program"];
     
     [entityarray addObject:geometerydict];
     
   
}


 
 -(void)CreateBufferForEntity:(NSString *)name
 {
 NSPredicate *predicate=[NSPredicate predicateWithFormat:@"name like[cd] %@",name];
 
 NSArray *filterarray=[entityarray filteredArrayUsingPredicate:predicate];
 
 NSMutableDictionary *dict=[filterarray objectAtIndex:0];
 
 int entityindices=[[dict valueForKey:@"entityindices"]intValue];
 int entityvertices=[[dict valueForKey:@"entityvertices"]intValue];
 
 
 GLuint buffer;
 glGenBuffers(1, &buffer);
 glBindBuffer(GL_ARRAY_BUFFER, buffer);
 glBufferData(GL_ARRAY_BUFFER, sizeof(GLbyte) * entityvertices + sizeof(GLbyte) * entityindices, 0, GL_STATIC_DRAW);
 glBufferSubData(GL_ARRAY_BUFFER, 0,sizeof(GLbyte) * entityvertices, colladavertices);
 glBufferSubData(GL_ARRAY_BUFFER, sizeof(GLbyte) * entityvertices,sizeof(GLbyte) * entityindices, ColladaIndices);
 glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, buffer);
 
 [dict setValue:[NSNumber numberWithInt:buffer] forKey:@"buffer"];
 
 
 
 }



 -(void)createvao:(NSString *)name program:(GLuint)entityprogram
 {
     
 NSPredicate *predicate=[NSPredicate predicateWithFormat:@"%K like[cd] %@",@"name",name];
 NSArray *ar=(NSMutableArray*)[entityarray filteredArrayUsingPredicate:predicate];
 
 GLuint buffer;
 
 NSMutableDictionary *dict=[ar objectAtIndex:0];
 
 
 NSNumber *number =(NSNumber*)[dict objectForKey:@"buffer"];
 buffer=[number intValue];
 
 GLuint vao;
 glGenVertexArrays(1, &vao);
 glBindVertexArray(vao);
 glBindBuffer(GL_ARRAY_BUFFER,buffer);
 
 glEnableVertexAttribArray(glGetAttribLocation(entityprogram, "entityposition"));
 glEnableVertexAttribArray(glGetAttribLocation(entityprogram, "entitytexin"));
 glEnableVertexAttribArray(glGetAttribLocation(entityprogram, "entitynormal"));
     glEnableVertexAttribArray(glGetAttribLocation(entityprogram, "in_jointIndices"));
     glEnableVertexAttribArray(glGetAttribLocation(entityprogram, "in_weights"));
 
 
     glVertexAttribPointer(glGetAttribLocation(entityprogram, "entityposition"), 4, GL_FLOAT, GL_FALSE, sizeof(float)*15, 0);
     glVertexAttribPointer(glGetAttribLocation(entityprogram, "entitytexin"),2, GL_FLOAT, GL_FALSE, sizeof(float)*15,(GLvoid*)(sizeof(float)*4));
     glVertexAttribPointer(glGetAttribLocation(entityprogram, "entitynormal"),3, GL_FLOAT, GL_FALSE, sizeof(float)*15,(GLvoid*)(sizeof(float)*6));
     
     glVertexAttribPointer(glGetAttribLocation(entityprogram, "in_jointIndices"),3, GL_INT, GL_FALSE, sizeof(int)*15,(GLvoid*)(sizeof(int)*9));
     
     glVertexAttribPointer(glGetAttribLocation(entityprogram, "in_weights"),3, GL_FLOAT, GL_FALSE, sizeof(float)*15,(GLvoid*)(sizeof(float)*12));
 
 
 glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,buffer);
 
 [dict setValue:[NSNumber numberWithInt:vao] forKey:@"vao"];
 [dict setValue:[NSNumber numberWithInt:entityprogram] forKey:@"program"];
 
 }

 -(void)renderentity:(NSString *)name
 {
 NSPredicate *predicate=[NSPredicate predicateWithFormat:@"name like[cd] %@",name];
 
 NSArray *filterarray=[entityarray filteredArrayUsingPredicate:predicate];
 
 NSMutableDictionary *dict=[filterarray objectAtIndex:0];
 int vertexarray = [[dict valueForKey:@"vao"]intValue];
 int entityprogram = [[dict valueForKey:@"program"]intValue];
 glUseProgram(entityprogram);
 glBindVertexArray(vertexarray);
 
 GLuint texturename;
 NSNumber *tex=[dict objectForKey:@"texture"];
 texturename=[tex unsignedIntValue];
 glActiveTexture(GL_TEXTURE0);
 glBindTexture(GL_TEXTURE_2D, texturename);
 glUniform1i(glGetUniformLocation(entityprogram, "entityimage"), 0);
 
 
 
 float ratio=[UIScreen mainScreen].bounds.size.width/[UIScreen mainScreen].bounds.size.height;
 
 
 GLKMatrix4 prespective = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(60), ratio, 0.1, 10000);
 
 
 
 GLKMatrix4 scale =_scalematrix;
 
 GLKMatrix4 rotatemat=GLKMatrix4Multiply(_rotmatrix, scale);
 
 GLKMatrix4 translate = GLKMatrix4MakeTranslation(0, -4, -20);
 
 GLKMatrix4 model =GLKMatrix4Multiply(translate , rotatemat);
 
 //  model=GLKMatrix4Identity;
 
 GLKMatrix4 camera;
 
 camera=GLKMatrix4Identity;
 
 glUniformMatrix4fv(glGetUniformLocation(entityprogram, "prespective"), 1, GL_FALSE, prespective.m);
 
 glUniformMatrix4fv(glGetUniformLocation(entityprogram, "view"), 1, GL_FALSE, camera.m);
 
 glUniformMatrix4fv(glGetUniformLocation(entityprogram, "model"), 1, GL_FALSE, model.m);
     
int jointTransforms= glGetUniformLocation(entityprogram, "jointTransforms");
     
     
     
     
     
     float mat[modeldata.joints.jointcount*16];
    GLKMatrix4 *matval=[self gettransform];
     int j=0;
     for (int i=0; i<16; i++)
     {
         GLKMatrix4 sendmat=matval[i];
         for (int i=0; i<16; i++) {
             
             mat[j]=sendmat.m[i];
             j++;
         }
     }
     
 
 int index=[[dict valueForKey:@"entityindices"]intValue];
 int vertex=[[dict valueForKey:@"entityvertices"]intValue];
     
 glUniformMatrix4fv(jointTransforms, 50, GL_FALSE, mat);
 glDrawElements(GL_TRIANGLES,sizeof(GLbyte)*index, GL_UNSIGNED_SHORT,(void*)(sizeof(GLbyte)*vertex));
 
 }


-(GLKMatrix4 *)gettransform
{
    GLKMatrix4  *jointMatrices = malloc(sizeof(GLKMatrix4)*modeldata.joints.jointcount);
    [self addjointarray:joints jointMatrices:jointMatrices];
    return jointMatrices;
}
-(void)addjointarray:(Joint*)headJoint jointMatrices:(GLKMatrix4*)jointMatrices
{
    jointMatrices[headJoint.index]=headJoint.animatedTransform;
    for (Joint *childJoint in headJoint.children)
    {
        [self addjointarray:childJoint jointMatrices:jointMatrices];
        
    }
}
 






@end
