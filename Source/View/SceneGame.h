//
//  SceneGame.h
//  XJ1024CC2D
//
//  Created by JunXie on 14-7-3.
//  Copyright 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "XJ1024Grid.h"

static CGFloat TILE_WIDTH = 60;
static CGFloat TILE_HEIGHT = 80;
static CGPoint TILE_START_POSITION = (CGPoint){53, 46};
static NSInteger NUM_COLUMNS = 4;
static NSInteger NUM_ROWS = 4;


@class NodeGrid;
@interface SceneGame : CCNode {
    CCLabelTTF          *   _labelScore;
    CCLabelTTF          *   _labelHighScore;
    
    NodeGrid            *   _nodeGrid;
}
@property (nonatomic, strong) XJ1024Grid        *   grid;

@end
