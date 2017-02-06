//
//  AnimationLoader.m
//  Collada-Skelton-Animation
//
//  Created by Varun on 01/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import "AnimationLoader.h"

@implementation AnimationLoader
-(instancetype)initwithelement:(SMXMLElement*)animNode jointsNode:(SMXMLElement*)jointsNode
{
    
    animationData=animNode;
    jointHierarchy=jointsNode;
    
    
    return self;
}
-(AnimationData*)extractdata
{
    
    NSString *rootname=[self getrootname];
    NSArray *keyframes=[self getkeytimes];
    
    NSString* duration=[keyframes lastObject];
    
    NSMutableArray *keyframe = [self initkeyframe:keyframes];
    
    for (SMXMLElement *element in [animationData childrenNamed:@"animation"]) {
        
        
        
        [self loadJointTransforms:element keyframe:keyframe rootname:rootname];
        
        
    }
    AnimationData *data=[[AnimationData alloc]init];
    data.keyframe=keyframe;
    data.duration=duration;
    
    
    
    
    return data;
}


-(void)loadJointTransforms:(SMXMLElement*)element keyframe:(NSMutableArray*)keyframe rootname:(NSString*)rootname

{
    
    NSString *jointname=[self getjointname:element];
    NSString *dataid =[self getDataId:element];
    
    SMXMLElement *dataelement=[element childWithAttribute:@"id" value:dataid];
    
    NSArray *rawdata=[[dataelement valueWithPath:@"float_array"]componentsSeparatedByString:@" "];
    
    
     [self processTransforms:jointname keyframe:keyframe rawdata:rawdata isroot:[rootname isEqualToString:jointname]];
    
    
}
-(void)processTransforms:(NSString*)jointname keyframe:(NSMutableArray*)keyframe rawdata:(NSArray *)rawdata isroot:(BOOL)isroot
{
    
    for (int i=0; i<keyframe.count; i++)
    {
        KeyFrameData *data=[keyframe objectAtIndex:i];
        
        //  NSLog(@"keyframe..%lu",(unsigned long)keyframe.count);
        
        
        
        
        GLKMatrix4 matrix=GLKMatrix4Identity;
        for (int j=0; j<16; j++)
        {
            matrix.m[j] = [rawdata[(i*16) + j]floatValue];
        }
        
        matrix=GLKMatrix4Transpose(matrix);
        
        
        if (isroot) {
            
            
            GLKMatrix4 rotate = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(-90), 1, 0, 0);
            
            matrix=GLKMatrix4Multiply(rotate, matrix);
            
        }
        
        
        
        
        JointTransformData *jointtransform=[[JointTransformData alloc]init];
        jointtransform.transformmatrix=matrix;
        jointtransform.jointname=jointname;
        
        [data addJointtransform:jointtransform];
        
        
    }
    
    
}

-(NSString*)getjointname:(SMXMLElement*)jointdict
{
  NSArray *array=   [[[[jointdict childNamed:@"channel"]attributes]valueForKey:@"target"]componentsSeparatedByString:@"/"];
    

    return [array objectAtIndex:0];
}
-(NSString*)getDataId:(SMXMLElement*)jointdict
{
    
    SMXMLElement *outputarray=[jointdict childNamed:@"sampler"];
    
    
   outputarray= [outputarray childWithAttribute:@"semantic" value:@"OUTPUT"];
    
   NSString *string= [[outputarray.attributes valueForKey:@"source"]substringFromIndex:1];
    

    return string;
    
}

-(NSMutableArray*)initkeyframe:(NSArray*)keyframe
{
    
    
    NSMutableArray *keyframearray=[[NSMutableArray alloc]init];
    
    
    for (int i=0; i<keyframe.count; i++) {
        KeyFrameData *data=[[KeyFrameData alloc]init];
        data.time=[keyframe objectAtIndex:i];
        [keyframearray addObject:data];
        
    }
    
    return keyframearray;
    
    
    
}

-(NSArray *)getkeytimes
{

    return [[[[[animationData childrenNamed:@"animation"]objectAtIndex:0]childNamed:@"source"]valueWithPath:@"float_array"] componentsSeparatedByString:@" "];;
    
}


-(NSString*)getrootname
{
    
   SMXMLElement *element = [[[jointHierarchy childNamed:@"visual_scene"] childWithAttribute:@"id" value:@"Armature"]childNamed:@"node"];
    
    
    return [element.attributes valueForKey:@"id"];
    
}
@end
