//
//  Animator.m
//  Collada-Skelton-Animation
//
//  Created by Varun on 02/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import "Animator.h"

@implementation Animator

-(void)doanimation:(Animation *)animation array:(Joint*)joint
{
    animationtime=0.0;
    
    currentanimation=animation;
    
    jointdata=joint;
    
}
-(void)update
{
    [self increaseanimationtime];
    NSMutableDictionary *dict=[self calculateCurrentAnimationPose];
    [self applyposeanimation:dict array:jointdata parentTransform:GLKMatrix4Identity];
}

-(void)applyposeanimation:(NSMutableDictionary*)currentpose array:(Joint*)joints parentTransform :(GLKMatrix4)parentTransform
{
    
    
    GLKMatrix4 currentLocalTransform ;
    
    NSValue *value=[currentpose valueForKey:joints.name];
    
    [value getValue:&currentLocalTransform];
    
    GLKMatrix4 currentTransform=  GLKMatrix4Multiply(parentTransform, currentLocalTransform);
    
    for (Joint *childJoint in joints.children)
    {
        [self applyposeanimation:currentpose array:childJoint parentTransform:currentTransform];
    }
    
    GLKMatrix4 inverseval=joints.inverseBindTransform;
    
    
    
    GLKMatrix4  newtransform =  GLKMatrix4Multiply(currentTransform,inverseval);
    
    
    
    
    joints.animatedTransform=newtransform;
    
    

    
}

-(float)increaseanimationtime
{
    animationtime+=_frametime;
    if (animationtime>[currentanimation.durations floatValue])
    {
        animationtime=  fmod(animationtime, [currentanimation.durations floatValue]);
    }

    return animationtime;
    
}

-(NSMutableDictionary *)calculateCurrentAnimationPose
{
    NSArray *keyframes=[self getprevious];
    float progress=[self calculateProgression:keyframes];
    
    
    return [self interploateposes:keyframes Progression:progress];
    
    
}

-(NSMutableDictionary *)interploateposes:(NSArray*)frame Progression:(float)progression
{
    KeyFrame *previousframe=[frame objectAtIndex:0];
    KeyFrame *nextFrame=[frame objectAtIndex:1];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    
    for (NSString *jointName in previousframe.posedict.allKeys)
    {
        
        JointTransform *previousTransform = [previousframe.posedict valueForKey:jointName];
        JointTransform *nextTransform = [nextFrame.posedict valueForKey:jointName];
        JointTransform *currentTransform =[nextTransform interpolate:previousTransform frameB:nextTransform progression:progression];
        
        GLKMatrix4 transform=[currentTransform getlocaltransform];
        
        NSValue *val=[NSValue valueWithBytes:&transform objCType:@encode(GLKMatrix4)];
        
        [dict setObject:val forKey:jointName];
        
    }
    
    
    return dict;
    
    
}

-(float)calculateProgression:(NSArray*)frame
{
    
    KeyFrame *previousframe=[frame objectAtIndex:0];
    KeyFrame *nextFrame=[frame objectAtIndex:1];
    
    float timeDifference = [nextFrame.timestamp floatValue] - [previousframe.timestamp floatValue];
    return (animationtime - [previousframe.timestamp floatValue]) / timeDifference;
    
    
}
-(NSArray*)getprevious
{
    KeyFrame *previousframe;
    KeyFrame *nextFrame;
    
    for (KeyFrame *frame in currentanimation.frames) {
        
        if ([frame.timestamp floatValue] > animationtime) {
            nextFrame = frame;
            break;
        }
        previousframe = frame;
        
    }
    
    previousframe = previousframe == nil ? nextFrame : previousframe;
    nextFrame = nextFrame == nil ? previousframe : nextFrame;
    
    
    return @[previousframe,nextFrame];
    
}
@end
