//
//  GeometryLoader.m
//  Collada-Skelton-Animation
//
//  Created by Varun on 31/01/17.
//  Copyright © 2017 X89. All rights reserved.
//



#import "GeometryLoader.h"

@implementation GeometryLoader




-(id)init
{
    
    entityarray=[[NSMutableArray alloc]init];
    return self;
}

-(instancetype)initwithelement:(SMXMLElement*)element skinarray:(NSArray*)skinarray
{
    meshdata=[[element childNamed:@"geometry"]childNamed:@"mesh"];
    vertexweights=skinarray;
    return self;
}
-(MeshData *)getMeshData;
{
    NSString *pvalue=[[meshdata childNamed:@"polylist"] valueWithPath:@"p"];
    NSArray *sourcearray=[meshdata childrenNamed:@"source"];
    NSInteger temp=sourcearray.count;
    NSArray *forvertices=[[[sourcearray objectAtIndex:0]valueWithPath:@"float_array"]componentsSeparatedByString:@" "];
    NSArray *fornormal=[[[sourcearray objectAtIndex:1]valueWithPath:@"float_array"]componentsSeparatedByString:@" "];
    NSArray *fortexture=[[[sourcearray objectAtIndex:2]valueWithPath:@"float_array"]componentsSeparatedByString:@" "];
    NSArray *forindices=[pvalue componentsSeparatedByString:@" "];
    
    NSMutableArray *verticesarray=[[NSMutableArray alloc]init];
    NSMutableArray *normalarray=[[NSMutableArray alloc]init];
    NSMutableArray *texturearray=[[NSMutableArray alloc]init];
    
    for (int j=0; j<forvertices.count/3; j++) {
        
        VertexSkinData *skindata=[vertexweights objectAtIndex:j];
        
        
        NSString *x= [forvertices objectAtIndex:(j*3)];
        NSString *y= [forvertices objectAtIndex:(j*3)+1];
        NSString *z= [forvertices objectAtIndex:(j*3)+2];
        
        GLKVector3 vector=GLKMatrix3MultiplyVector3(GLKMatrix3MakeRotation(GLKMathDegreesToRadians(-90), 1, 0, 0), GLKVector3Make([x floatValue], [y floatValue], [z floatValue]));
        
        
        NSValue *value=[NSValue valueWithBytes:&vector objCType:@encode(GLKVector3)];
        
        
        NSDictionary *dict=@{@"vertices":value,@"jointweight":skindata};
        
        
        [verticesarray addObject:dict];
        
        
        
    }
    
    for (int j=0; j<fornormal.count; j=j+3) {
        
        NSString *x= [fornormal objectAtIndex:j];
        NSString *y= [fornormal objectAtIndex:j+1];
        NSString *z= [fornormal objectAtIndex:j+2];
        
        GLKVector3 vector=GLKMatrix3MultiplyVector3(GLKMatrix3MakeRotation(GLKMathDegreesToRadians(-90), 1, 0, 0), GLKVector3Make([x floatValue], [y floatValue], [z floatValue]));
        
        NSValue *value=[NSValue valueWithBytes:&vector objCType:@encode(GLKVector3)];
        
        [normalarray addObject:value];
    }
    for (int j=0; j<fortexture.count; j=j+2)
    {
        NSString *u= [fortexture objectAtIndex:j];
        NSString *v= [fortexture objectAtIndex:j+1];
        
        GLKVector2 vector=GLKVector2Make([u floatValue], [v floatValue]);
        NSValue *value=[NSValue valueWithBytes:&vector objCType:@encode(GLKVector2)];
        [texturearray addObject:value];
    }
    
    
    MeshData *mesh=[[MeshData alloc]init];
    mesh.vertexarray =verticesarray;
    mesh.texturearray=texturearray;
    mesh.indicesarray=forindices;
    mesh.normalarray =normalarray;
    mesh.temp=temp;

    return mesh;
    
}



@end
