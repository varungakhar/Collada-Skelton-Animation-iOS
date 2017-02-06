//
//  OpenGLView.m
//  Collada-Skelton-Animation
//
//  Created by Varun on 31/01/17.
//  Copyright © 2017 X89. All rights reserved.
//


#import "OpenGLView.h"

@implementation OpenGLView



+(Class)layerClass
{
    return [CAEAGLLayer class];
}

-(id)initWithFrame:(CGRect)frame
{
    
    if (self=[super initWithFrame:frame])
    {
        
        UIPinchGestureRecognizer *pinch=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
        
        [self addGestureRecognizer:pinch];
        
        eglcontext=[[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES3];
        
        [EAGLContext setCurrentContext:eglcontext];
        CAEAGLLayer *layer=(CAEAGLLayer *)self.layer;
        layer.opaque=YES;
        
        GLuint renderbuffer,depthbuffer,framebuffer;
        
        glGenRenderbuffers(1, &depthbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, depthbuffer);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT32F, frame.size.width, frame.size.height);
        
        
        glGenRenderbuffers(1, &renderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer);
        [eglcontext renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];
        
        glEnable(GL_DEPTH_TEST);
        
        
        glGenFramebuffers(1, &framebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderbuffer);
         glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT , GL_RENDERBUFFER, depthbuffer);
        
        CADisplayLink *link=[CADisplayLink displayLinkWithTarget:self selector:@selector(drawview)];
        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        
         loader=[[SceneLoader alloc]init];
        
        scalematrix=GLKMatrix4Identity;
        rotMatrix=GLKMatrix4Identity;
        
       sky=[[SkyBox alloc]init];
        
        [self drawview];
        

    }
    
    return self;
}

-(void)drawview
{
    
    CFAbsoluteTime elapsedTime, startTime = CFAbsoluteTimeGetCurrent();
    glClearColor(0.5f, 0.5f, 0.9f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    sky.rotMatrix=rotMatrix;
    [sky render];
    loader.scalematrix=scalematrix;
    loader.rotmatrix=rotMatrix;
    loader.frametime=processingTime;
    [loader update];
    [eglcontext presentRenderbuffer:GL_RENDERBUFFER];
    elapsedTime = CFAbsoluteTimeGetCurrent() - startTime;
    processingTime =  elapsedTime ;
}



-(void)pinch:(UIPinchGestureRecognizer*)pinch
{
    
    
    if (pinch.scale<0.5) {
        return;
    }
    else if (pinch.scale>2)
    {
        return;
    }
    
    GLKMatrix4 checkscale=GLKMatrix4Scale(scalematrix, pinch.scale, pinch.scale, pinch.scale);
    
    if (checkscale.m00>0.1&&checkscale.m00<2.0) {

        scalematrix=GLKMatrix4Scale(scalematrix, pinch.scale, pinch.scale, pinch.scale);
    }
    pinch.scale=1;
    [self drawview];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch=[touches anyObject];
    
    CGPoint first=[touch locationInView:self];
    CGPoint previous=[touch previousLocationInView:self];
    
    CGPoint diff=CGPointMake(previous.x-first.x, previous.y-first.y);
    

    rotx = rotx+ -1*diff.y/2;
    roty = roty+ -1*diff.x/2;
    
    GLKMatrix4 x =GLKMatrix4Rotate(GLKMatrix4Identity, GLKMathDegreesToRadians(rotx), 1, 0, 0);
    
    GLKMatrix4 y=GLKMatrix4Rotate(GLKMatrix4Identity, GLKMathDegreesToRadians(roty), 0, 1, 0);
    
    
    rotMatrix=GLKMatrix4Multiply(x, y);
    

    [self drawview];
}











@end
