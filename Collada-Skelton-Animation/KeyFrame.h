//
//  KeyFrame.h
//  Collada-Skelton-Animation
//
//  Created by Varun on 02/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyFrame : NSObject
@property(strong,nonatomic)NSString *timestamp;
@property(strong,nonatomic)NSMutableDictionary *posedict;
@end
