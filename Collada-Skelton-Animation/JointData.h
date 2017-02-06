//
//  JointData.h
//  Collada-Skelton-Animation
//
//  Created by Varun on 01/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@interface JointData : NSObject
@property(nonatomic)NSInteger index;
@property(strong,nonatomic)NSString *jointname;
@property(strong,nonatomic)NSMutableArray *children;
@property(nonatomic)GLKMatrix4 matrix;
-(void)addchild:(JointData*)data;
@end
