//
//  AnimatedModelLoader.h
//  Collada-Skelton-Animation
//
//  Created by Varun on 02/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColladaLoader.h"
#import "AnimationModelData.h"
#import "AnimationData.h"
#import "SMXMLDocument.h"
#import "Joint.h"
#import "Animation.h"
#import "JointTransform.h"
#import "KeyFrame.h"
#import "Animator.h"
@interface AnimatedModelLoader : NSObject
{
    Animator *animator;
}
@property(nonatomic)float frametime;
-(void)update;
-(Joint *)compileanimation:(AnimationModelData*)modeldata animdata:(AnimationData *)animdata;
@end
