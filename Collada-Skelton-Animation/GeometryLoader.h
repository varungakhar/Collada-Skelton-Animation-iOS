//
//  GeometryLoader.h
//  Collada-Skelton-Animation
//
//  Created by Varun on 31/01/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMXMLDocument.h"
#import "MeshData.h"
#import <GLKit/GLKit.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
#import "VertexSkinData.h"
@interface GeometryLoader : NSObject
{
    SMXMLElement *meshdata;
    NSArray *vertexweights;
    
    NSMutableArray *entityarray;
}
@property(nonatomic)GLKMatrix4 rotmatrix,scalematrix;


-(instancetype)initwithelement:(SMXMLElement*)element skinarray:(NSArray*)skinarray;
-(MeshData *)getMeshData;

-(void)createEntity:(NSDictionary*)document;
-(void)CreateBufferForEntity:(NSString *)name;
-(void)createvao:(NSString *)name program:(GLuint)program;
-(void)renderentity:(NSString *)name;
@end
