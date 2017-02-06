//
//  JointTransform.m
//  Collada-Skelton-Animation
//
//  Created by Varun on 02/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import "JointTransform.h"

@implementation JointTransform
-(JointTransform*)interpolate:(JointTransform*)frameA frameB:(JointTransform*)frameB progression:(float)progression
{
    GLKVector3 vector=[self interplotevector:frameA.translatevector endvector:frameB.translatevector progression:progression];
    GLKQuaternion quat= GLKQuaternionSlerp(frameA.quat, frameB.quat, progression);
    JointTransform *transfor=[[JointTransform alloc]init];
    transfor.translatevector=vector;
    transfor.quat=quat;

    return transfor;
}

-(GLKVector3)interplotevector:(GLKVector3)start endvector:(GLKVector3)end progression:(float)progression
{
    
    float x = start.x + (end.x - start.x) * progression;
    float y = start.y + (end.y - start.y) * progression;
    float z = start.z + (end.z - start.z) * progression;
    
    return GLKVector3Make(x, y, z);
    
}

-(GLKMatrix4)getlocaltransform
{
    
    
    GLKMatrix4 translation=GLKMatrix4MakeTranslation(self.translatevector.x, self.translatevector.y, self.translatevector.z);
    
    GLKMatrix4 rotation=GLKMatrix4MakeWithQuaternion(self.quat);;
    
    GLKMatrix4 rt=GLKMatrix4Multiply(translation, rotation);
    
    return rt;
}
@end
