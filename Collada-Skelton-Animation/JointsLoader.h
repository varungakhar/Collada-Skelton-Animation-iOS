//
//  JointsLoader.h
//  Collada-Skelton-Animation
//
//  Created by Varun on 01/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMXMLDocument.h"
#import "JointsData.h"
@interface JointsLoader : NSObject
{
    SMXMLElement *armatureData;
    NSArray *boneOrder;
    int jointcount;
    
    
}
-(instancetype)initwithelement:(SMXMLElement*)element boneOrder:(NSArray*)boneList;
-(JointsData *)extractdata;

@end
