//
//  KeyFrameData.m
//  Collada-Skelton-Animation
//
//  Created by Varun on 02/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import "KeyFrameData.h"

@implementation KeyFrameData
-(id)init
{
    _jointarray=[[NSMutableArray alloc]init];
    return self;
}
-(void)addJointtransform:(JointTransformData*)data
{
    [_jointarray addObject:data];
    
}
@end
