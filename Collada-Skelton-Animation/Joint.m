//
//  Joint.m
//  Collada-Skelton-Animation
//
//  Created by Varun on 02/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import "Joint.h"

@implementation Joint
-(id)init
{
    _children=[[NSMutableArray alloc]init];
    return self;
}
-(void)addchild:(Joint*)joint
{
    [_children addObject:joint];
}
-(void)calcInverseBindTransform:(GLKMatrix4)parentBindTransform
{
    GLKMatrix4 bindtransform =GLKMatrix4Multiply(parentBindTransform, _localBindTransform);
    BOOL tr=true;
    GLKMatrix4 inverse=GLKMatrix4Invert(bindtransform, &tr);
    self.inverseBindTransform=inverse;
    for (Joint *child in _children)
    {
        [child calcInverseBindTransform:bindtransform];
    }
}
@end
