//
//  JointTransform.h
//  Collada-Skelton-Animation
//
//  Created by Varun on 02/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@interface JointTransform : NSObject
@property(nonatomic)GLKVector3 translatevector;
@property(nonatomic)GLKQuaternion quat;

-(JointTransform*)interpolate:(JointTransform*)frameA frameB:(JointTransform*)frameB progression:(float)progression;
-(GLKMatrix4)getlocaltransform;
@end
