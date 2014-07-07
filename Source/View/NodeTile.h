//
//  NodeTile.h
//  XJ1024CC2D
//
//  Created by JunXie on 14-7-3.
//  Copyright 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface NodeTile : CCNode {
    CCSprite            *   _sprCard;
    CCLabelTTF          *   _labelValue;
    CCNodeColor         *   _nodeColorBg;
}
@property(nonatomic, assign) NSInteger               value;
- (CCActionInterval *)actionMergeToValue:(NSInteger)value;

@end
