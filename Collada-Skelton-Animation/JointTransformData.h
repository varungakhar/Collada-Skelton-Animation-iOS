//
//  JointTransformData.h
//  Collada-Skelton-Animation
//
//  Created by Varun on 02/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@interface JointTransformData : NSObject
@property(strong,nonatomic)NSString *jointname;
@property(nonatomic)GLKMatrix4 transformmatrix;
@end
