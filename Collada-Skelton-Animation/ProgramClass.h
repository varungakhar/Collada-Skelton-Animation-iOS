//
//  ProgramClass.h
//  Collada-Skelton-Animation
//
//  Created by Varun on 31/01/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
@interface ProgramClass : NSObject


-(GLuint)program:(NSString*)vertex fragment:(NSString*)fragment;

@end
