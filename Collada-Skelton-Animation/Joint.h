//
//  Joint.h
//  Collada-Skelton-Animation
//
//  Created by Varun on 02/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@interface Joint : NSObject
@property(nonatomic)NSInteger index;
@property(strong,nonatomic)NSMutableArray *children;
@property(strong,nonatomic)NSString *name;
@property(nonatomic)GLKMatrix4 localBindTransform;
@property(nonatomic)GLKMatrix4 inverseBindTransform,animatedTransform;
-(void)calcInverseBindTransform:(GLKMatrix4)parentBindTransform;
-(void)addchild:(Joint*)joint;
@end
