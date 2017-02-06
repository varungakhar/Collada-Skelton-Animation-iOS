//
//  ColladaLoader.m
//  Collada-Skelton-Animation
//
//  Created by Varun on 01/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import "ColladaLoader.h"

@implementation ColladaLoader

-(AnimationModelData *)loadColladaModel:(SMXMLDocument*)document maxweights:(int)maxweights
{
    AnimationModelData *data=[[AnimationModelData alloc]init];
 
    SkinLoader *loader=[[SkinLoader alloc]initwithelement:[document childNamed:@"library_controllers"] maxweights:maxweights];
    
    SkinningData *skindata=[loader extractSkinData];
    
    JointsLoader *jointsloader=[[JointsLoader alloc]initwithelement:[document childNamed:@"library_visual_scenes"] boneOrder:skindata.jointOrder];
    JointsData *joints=[jointsloader extractdata];
    
    GeometryLoader *geo=[[GeometryLoader alloc]initwithelement:[document childNamed:@"library_geometries"] skinarray:skindata.verticesSkinData];
    MeshData *mesh=[geo getMeshData];
    
    
    data.mesh=mesh;
    data.joints=joints;
    
    return data;
    
}
-(AnimationData *)loadColladaAnimation:(SMXMLDocument*)document
{
   
    AnimationLoader *loader=[[AnimationLoader alloc]initwithelement:[document childNamed:@"library_animations"] jointsNode:[document childNamed:@"library_visual_scenes"]];
    
    
    AnimationData *data=[loader extractdata];
    
    
    return data;
    
}

@end
