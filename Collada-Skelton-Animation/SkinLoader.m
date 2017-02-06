//
//  SkinLoader.m
//  Collada-Skelton-Animation
//
//  Created by Varun on 01/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import "SkinLoader.h"

@implementation SkinLoader


-(instancetype)initwithelement:(SMXMLElement*)element maxweights:(int)maxweight
{
    
    skinningData=[[element childNamed:@"controller"]childNamed:@"skin"];
    maxWeights = maxweight;
    
    
    
    return self;
    
}

-(SkinningData*)extractSkinData
{
    
    NSArray *jointlist=[self loadJointsList];
    
    NSArray *weights=[self loadweights];
    
    
    SMXMLElement  *weightsDataNode=[skinningData childNamed:@"vertex_weights"];
    
    
    NSArray * effectorJointCounts=[self getEffectiveJointsCounts:weightsDataNode];
    
    
    NSArray *vertexWeights=[self getSkinData:weightsDataNode jointcount:effectorJointCounts weightlist:weights];
    
    
    SkinningData *skindata=[[SkinningData alloc]init];
    
    skindata.jointOrder=jointlist;
    
    skindata.verticesSkinData=vertexWeights;
    
    return skindata;
    
    
}
-(NSArray*)loadJointsList
{
    SMXMLElement *vertexweight=[skinningData childNamed:@"vertex_weights"];
    
  SMXMLElement *joints=  [vertexweight childWithAttribute:@"semantic" value:@"JOINT"];
    
    NSString *jointsid=[[joints.attributes valueForKey:@"source"]substringFromIndex:1];
    
    SMXMLElement *jointslistvalue=[skinningData childWithAttribute:@"id" value:jointsid];
    NSArray *jointslistname=[[jointslistvalue valueWithPath:@"Name_array"]componentsSeparatedByString:@" "];

    return jointslistname;
    
}
-(NSArray *)loadweights
{
    SMXMLElement *vertexweight=[skinningData childNamed:@"vertex_weights"];
    
    SMXMLElement *joints=  [vertexweight childWithAttribute:@"semantic" value:@"WEIGHT"];
    
    NSString *weightid=[[joints.attributes valueForKey:@"source"]substringFromIndex:1];
    
    SMXMLElement *jointslistvalue=[skinningData childWithAttribute:@"id" value:weightid];
    
    NSArray *weightsNode=[[jointslistvalue valueWithPath:@"float_array"]componentsSeparatedByString:@" "];
    
    return weightsNode;
}
-(NSArray*)getEffectiveJointsCounts:(SMXMLElement*)weightsDataNode
{
    
    NSString *dictvertexweight=[weightsDataNode valueWithPath:@"vcount"];
    
    return [dictvertexweight componentsSeparatedByString:@" "];
    
}
-(NSMutableArray*)getSkinData:(SMXMLElement*)weightsDataNode jointcount:(NSArray*)jointcounts weightlist:(NSArray*)weight
{
    
    NSArray *skinning=[[weightsDataNode valueWithPath:@"v"]componentsSeparatedByString:@" "];
    
    NSMutableArray *skindataarray=[[NSMutableArray alloc]init];
    
    
    int pointer=0;
    
    for (NSString* stringcount in jointcounts) {
        
        VertexSkinData *vertex=[[VertexSkinData alloc]init];
        
        NSInteger count=[stringcount integerValue];
        for (int i=0; i<count; i++) {
            
            int jointId = [skinning[pointer++]intValue];
            
            
            int weightId = [skinning[pointer++]intValue];
            
            
            
            [vertex addJointEffect:jointId weightid:[weight[weightId]floatValue]];
        }
        [vertex limitJointNumber:3];
        
        
  
        
        
        [skindataarray addObject:vertex];
        
    }
    
    
    
    return skindataarray;
    
    
}


@end
