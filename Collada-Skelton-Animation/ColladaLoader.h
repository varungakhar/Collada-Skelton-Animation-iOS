//
//  ColladaLoader.h
//  Collada-Skelton-Animation
//
//  Created by Varun on 01/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMXMLDocument.h"
#import "SkinLoader.h"
#import "SkinningData.h"
#import "JointsLoader.h"
#import "JointsData.h"
#import "GeometryLoader.h"
#import "MeshData.h"
#import "AnimationModelData.h"
#import "AnimationLoader.h"
#import "AnimationData.h"
@interface ColladaLoader : NSObject

-(AnimationModelData *)loadColladaModel:(SMXMLDocument*)document maxweights:(int)maxweights;
-(AnimationData*)loadColladaAnimation:(SMXMLDocument*)document;

@end
