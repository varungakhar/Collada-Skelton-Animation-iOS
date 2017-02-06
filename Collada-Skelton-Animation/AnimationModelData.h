//
//  AnimationModelData.h
//  Collada-Skelton-Animation
//
//  Created by Varun on 01/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeshData.h"
#import "JointsData.h"
@interface AnimationModelData : NSObject
@property(strong,nonatomic)MeshData *mesh;
@property(strong,nonatomic)JointsData *joints;


@end
