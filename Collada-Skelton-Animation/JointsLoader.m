//
//  JointsLoader.m
//  Collada-Skelton-Animation
//
//  Created by Varun on 01/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import "JointsLoader.h"

@implementation JointsLoader
-(instancetype)initwithelement:(SMXMLElement*)element boneOrder:(NSArray*)boneList
{
    armatureData=[[element childNamed:@"visual_scene"] childWithAttribute:@"id" value:@"Armature"];
    boneOrder=boneList;
    
    
    return self;
}
-(JointsData *)extractdata
{
     JointData *headJoint=[self loadelementarray:[armatureData childNamed:@"node"] isRoot:YES];
    
    JointsData *joints=[[JointsData alloc]init];
    joints.jointdata=headJoint;
    joints.jointcount=jointcount;
    
    return joints;
    
}
-(JointData *)loadelementarray:(SMXMLElement*)element isRoot:(BOOL)isRoot
{
    
    
    JointData *joint=[self extractMainJointDatafromelement:element isRoot:isRoot];
    
    for (SMXMLElement *childnode in [element childrenNamed:@"node"])
    {
        JointData *data= [self loadelementarray:childnode isRoot:NO];
        [joint addchild:data];
    }
    
    
    
    return joint;
    
    
    
}

-(JointData *)extractMainJointDatafromelement:(SMXMLElement*)jointNode isRoot:(BOOL)isRoot
{
    NSString *nameid=[jointNode.attributes valueForKey:@"id"];
    nameid=[NSString stringWithFormat:@"%@",nameid];
    NSInteger index = [boneOrder indexOfObject:nameid];
    
    NSArray  *matrixarray=[[jointNode valueWithPath:@"matrix"]componentsSeparatedByString:@" "];
    
    GLKMatrix4 matrix=[self creatematrix:matrixarray];
    
    
    
    if (isRoot) {
        
        
        GLKMatrix4 rotate = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(-90), 1, 0, 0);
        
        matrix=GLKMatrix4Multiply(rotate, matrix);
        
    }
    
    
    JointData *data=[[JointData alloc]init];
    data.index=index;
    data.jointname=nameid;
    data.matrix=matrix;
    
    
    jointcount++;
    
    return data;
    
}






-(GLKMatrix4)creatematrix:(NSArray*)matrixarray
{
    
    // NSLog(@"%lu",matrixarray.count);
    
    GLKMatrix4 matrix=GLKMatrix4Identity;
    for (int i=0; i<16; i++)
    {
        matrix.m[i] = [matrixarray[i]floatValue];
    }
    
    matrix=GLKMatrix4Transpose(matrix);
    
    return matrix;
}


@end
