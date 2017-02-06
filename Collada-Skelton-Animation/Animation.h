//
//  Animation.h
//  Collada-Skelton-Animation
//
//  Created by Varun on 02/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Animation : NSObject
@property(strong,nonatomic)NSMutableArray *frames;
@property(strong,nonatomic)NSString *durations;
@end
