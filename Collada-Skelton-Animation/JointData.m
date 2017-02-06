//
//  JointData.m
//  Collada-Skelton-Animation
//
//  Created by Varun on 01/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import "JointData.h"

@implementation JointData

-(id)init
{
    _children=[[NSMutableArray alloc]init];
    
    return self;
}
-(void)addchild:(JointData*)data
{
    [_children addObject:data];
}
@end
