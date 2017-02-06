//
//  Animator.h
//  Collada-Skelton-Animation
//
//  Created by Varun on 02/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyFrame.h"
#import "Joint.h"
#import "Animation.h"
#import "JointTransform.h"
@interface Animator : NSObject
{
    float animationtime;
    Animation *currentanimation;
    Joint *jointdata;
}
@property(nonatomic)float frametime;
-(void)doanimation:(Animation *)animation array:(Joint*)joint;
-(void)update;
@end
