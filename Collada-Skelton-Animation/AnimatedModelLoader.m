//
//  AnimatedModelLoader.m
//  Collada-Skelton-Animation
//
//  Created by Varun on 02/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import "AnimatedModelLoader.h"

@implementation AnimatedModelLoader




-(Joint *)compileanimation:(AnimationModelData*)modeldata animdata:(AnimationData *)animdata
{
   
   
    
    Animation *animation = [self loadanimation:animdata];
    
    Joint *headjoint=[self createjoin:modeldata.joints.jointdata];
    
    [headjoint calcInverseBindTransform:GLKMatrix4Identity];
    
    animator=[[Animator alloc]init];
    
    [animator doanimation:animation array:headjoint];
    
    return headjoint;
}
-(void)update
{
    animator.frametime=_frametime;
    [animator update];
}


-(Animation *)loadanimation:(AnimationData*)animdata
{
    NSMutableArray *keyframedataarray=animdata.keyframe;
    
    
    NSMutableArray *keyframearray=[[NSMutableArray alloc]init];
    
    
    for (int i=0; i<keyframedataarray.count; i++) {
        
        
        keyframearray[i]=[self createkeyframe:keyframedataarray[i]];
        
        
    }
    
    Animation *animate=[[Animation alloc]init];
    
    animate.durations=animdata.duration;
    animate.frames=keyframearray;
    
    
    return animate;
    
}
-(KeyFrame*)createkeyframe:(KeyFrameData*)data
{
    KeyFrame *frame=[[KeyFrame alloc]init];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    int i=0;
    for (JointTransformData *jointdata in data.jointarray)
    {
        JointTransform *joint=[self createtransform:jointdata];
        [dict setObject:joint forKey:jointdata.jointname];
        i++;
    }
    frame.timestamp=data.time;
    frame.posedict=dict;
    
    
    return frame;
}
-(JointTransform*)createtransform:(JointTransformData*)data
{
    JointTransform *jointtransform=[[JointTransform alloc]init];
    GLKMatrix4 matrix=data.transformmatrix;
    GLKVector3 vec=GLKVector3Make(matrix.m30, matrix.m31, matrix.m32);
    GLKQuaternion quat = GLKQuaternionMakeWithMatrix4(matrix);
    jointtransform.translatevector=vec;
    jointtransform.quat=quat;
    return jointtransform;
}
-(Joint *)createjoin:(JointData*)data
{
    Joint *newjoint=[[Joint alloc]init];
    newjoint.index=data.index;
    newjoint.name=data.jointname;
    newjoint.animatedTransform=GLKMatrix4Identity;
    newjoint.inverseBindTransform=GLKMatrix4Identity;
    newjoint.localBindTransform=data.matrix;
    for (JointData *child in data.children)
    {
        Joint *jointval = [self createjoin:child];
        [newjoint addchild:jointval];

    }
    return newjoint;
}



@end
