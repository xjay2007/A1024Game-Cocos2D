//
//  NodeGrid.h
//  XJ1024CC2D
//
//  Created by JunXie on 14-7-3.
//  Copyright 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class XJ1024Grid, XJ1024Move;
@interface NodeGrid : CCNode {
}
@property (nonatomic, weak) XJ1024Grid          *   grid;
@property (nonatomic, assign) CGFloat               tileWidth;
@property (nonatomic, assign) CGFloat               tileHeight;
@property (nonatomic, assign) CGPoint               positionStart;


- (void)animateSpawnTiles:(NSArray *)tiles completion:(dispatch_block_t)completion;
- (void)animateMoveTiles:(NSArray *)moves completion:(dispatch_block_t)completion;

- (void)resetNodeGrid;
@end
