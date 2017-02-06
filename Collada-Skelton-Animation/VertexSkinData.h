//
//  VertexSkinData.h
//  Collada-Skelton-Animation
//
//  Created by Varun on 01/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VertexSkinData : NSObject
@property(strong,nonatomic) NSMutableArray *jointIds,*weights;
-(void)addJointEffect:(int)jointid weightid:(float)weightid;
-(void)limitJointNumber:(int)max;
@end
