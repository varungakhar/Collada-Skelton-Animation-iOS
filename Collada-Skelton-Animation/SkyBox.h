//
//  SkyBox.h
//  Collada-Skelton-Animation
//
//  Created by Varun on 01/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProgramClass.h"
@interface SkyBox : NSObject
{
    GLuint skyboxprogram,skyboxvertex;
}
@property(nonatomic)GLKMatrix4 rotMatrix;
-(void)render;
@end
