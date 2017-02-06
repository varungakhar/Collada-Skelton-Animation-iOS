//
//  VertexSkinData.m
//  Collada-Skelton-Animation
//
//  Created by Varun on 01/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import "VertexSkinData.h"

@implementation VertexSkinData
@synthesize jointIds,weights;
-(id)init
{
    jointIds=[[NSMutableArray alloc]init];
    weights=[[NSMutableArray alloc]init];
    return self;
}
-(void)addJointEffect:(int)jointid weightid:(float)weightid
{
    
    for(int i=0;i<weights.count;i++){
        if(weightid > [[weights objectAtIndex:i]floatValue])
        {
            [jointIds insertObject:[NSString stringWithFormat:@"%d",jointid] atIndex:i];
            [weights insertObject:[NSString stringWithFormat:@"%f",weightid] atIndex:i];
            return;
        }
    }
    [jointIds addObject:[NSString stringWithFormat:@"%d",jointid]];
    [weights addObject:[NSString stringWithFormat:@"%f",weightid]];
    
}

-(void)limitJointNumber:(int)max
{
    
    
    
    if(jointIds.count > max)
    {
        NSMutableArray *topWeights=[[NSMutableArray alloc]init];
        
        float total = [self saveTopWeights:topWeights];
        //
        [self  refillWeightList:topWeights  total:total];
        
        [self removeExcessJointIds:max];
        
        
        
        
    }
    else if(jointIds.count < max)
    {
        [self fillEmptyWeights:max];
        
        
    }
    
    
    
    
}
-(void) fillEmptyWeights:(int) max
{
    while(jointIds.count < max)
    {
        [jointIds addObject:[NSString stringWithFormat:@"%d",0]];
        [weights addObject:[NSString stringWithFormat:@"%f",0.0f]];
    }
}
-(float)saveTopWeights:(NSMutableArray*)topWeightsArray
{
    float total = 0;
    for(int i=0;i<3;i++)
    {
        topWeightsArray[i] = [weights objectAtIndex:i];
        
        total += [topWeightsArray[i]floatValue];
    }
    
    return total;
}
-(void)refillWeightList:(NSArray*)topWeights total:(float)total
{
    [weights removeAllObjects];
    for(int i=0;i<3;i++)
    {
        //  weights.add(Math.min(topWeights[i]/total, 1));
        float value=MIN([topWeights[i]floatValue]/total,1.0f);
        [weights addObject:[NSString stringWithFormat:@"%f",value]];
    }
}
-(void) removeExcessJointIds:(int) max
{
    while(jointIds.count > max)
    {
        [jointIds removeObjectAtIndex:(jointIds.count-1)];
    }
}
@end
