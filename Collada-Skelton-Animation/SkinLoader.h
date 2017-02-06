//
//  SkinLoader.h
//  Collada-Skelton-Animation
//
//  Created by Varun on 01/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkinningData.h"
#import "SMXMLDocument.h"
#import "VertexSkinData.h"
@interface SkinLoader : NSObject
{
    
    SMXMLElement *skinningData ;
    
    int maxWeights ;
}
-(instancetype)initwithelement:(SMXMLElement*)element maxweights:(int)maxweight;
-(SkinningData*)extractSkinData;

@end
