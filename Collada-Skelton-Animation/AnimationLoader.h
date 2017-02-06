//
//  AnimationLoader.h
//  Collada-Skelton-Animation
//
//  Created by Varun on 01/02/17.
//  Copyright © 2017 X89. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMXMLDocument.h"
#import "AnimationData.h"
#import "KeyFrameData.h"
@interface AnimationLoader : NSObject
{
    SMXMLElement *animationData,*jointHierarchy;
}
-(instancetype)initwithelement:(SMXMLElement*)animNode jointsNode:(SMXMLElement*)jointsNode;
-(AnimationData*)extractdata;

@end
