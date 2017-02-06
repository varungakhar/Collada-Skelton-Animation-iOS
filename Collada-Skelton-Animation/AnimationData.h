//
//  AnimationData.h
//  Collada-Skelton-Animation
//
//  Created by Varun on 01/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationData : NSObject

@property(strong,nonatomic) NSMutableArray *keyframe;
@property(strong,nonatomic)NSString* duration;
@end
