//
//  SceneLoader.h
//  Collada-Skelton-Animation
//
//  Created by Varun on 31/01/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMXMLDocument.h"
#import <GLKit/GLKit.h>
#import "GeometryLoader.h"
#import "ProgramClass.h"
#import "Joint.h"
#import "AnimatedModelLoader.h"

@interface SceneLoader : NSObject
{
    GeometryLoader *geometry;
    ProgramClass *programclass;
    AnimatedModelLoader *loader;
    AnimationModelData *modeldata;
    NSMutableArray *entityarray;
    Joint *joints;
    
}
@property(nonatomic)float frametime;
@property(nonatomic)GLKMatrix4 rotmatrix,scalematrix;
-(void)update;

@end
