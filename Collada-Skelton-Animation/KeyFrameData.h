//
//  KeyFrameData.h
//  Collada-Skelton-Animation
//
//  Created by Varun on 02/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JointTransformData.h"
@interface KeyFrameData : NSObject

-(void)addJointtransform:(JointTransformData*)data;
@property(strong,nonatomic)NSMutableArray *jointarray;
@property(strong,nonatomic)NSString *time;
@end
