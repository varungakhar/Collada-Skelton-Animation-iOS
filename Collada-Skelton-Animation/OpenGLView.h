//
//  OpenGLView.h
//  Collada-Skelton-Animation
//
//  Created by Varun on 31/01/17.
//  Copyright © 2017 X89. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
#import <GLKit/GLKit.h>
#import "SceneLoader.h"
#import "GeometryLoader.h"
#import "SkyBox.h"
@interface OpenGLView : UIView

{
    EAGLContext *eglcontext;
    SceneLoader *loader;
     float rotx,roty,scale,radius;
     NSMutableArray *entityarray;
    GLKMatrix4 rotMatrix,scalematrix;
    SkyBox *sky;
    float processingTime;
    
    
}

@end
