//
//  MeshData.h
//  Collada-Skelton-Animation
//
//  Created by Varun on 01/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeshData : NSObject

@property(strong,nonatomic)NSArray *indicesarray,*vertexarray,*normalarray,*texturearray;
@property(nonatomic)NSInteger temp;


@end
