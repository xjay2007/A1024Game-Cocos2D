//
//  NodeGrid.m
//  XJ1024CC2D
//
//  Created by JunXie on 14-7-3.
//  Copyright 2014年 Apportable. All rights reserved.
//

#import "NodeGrid.h"
#import "NodeTile.h"
#import "XJ1024Grid.h"

@interface NodeGrid ()

@end
@implementation NodeGrid

- (void)didLoadFromCCB {
    
}

- (void)resetNodeGrid {
    [self unscheduleAllSelectors];
    [self stopAllActions];
    [self removeAllChildren];
}

- (void)animateSpawnTiles:(NSArray *)tiles completion:(dispatch_block_t)completion {
    
    CCTime duration = 0.15;
    for (XJ1024Tile *tile in tiles) {
        NodeTile *nodeTile = (NodeTile *)[CCBReader load:@"NodeTile"];
        nodeTile.scale = 0;
        nodeTile.position = [self positionWithColumn:tile.column row:tile.row];
        nodeTile.value = tile.value;
        tile.nodeTile = nodeTile;
        [self addChild:nodeTile];
        
        CCActionInterval *actSpawn = [CCActionScaleTo actionWithDuration:duration scale:1.0];
        [nodeTile runAction:actSpawn];
    }
    
    [self runAction:[CCActionSequence actionOne:[CCActionDelay actionWithDuration:duration] two:[CCActionCallBlock actionWithBlock:completion]]];
}

static CGFloat SPEED = 800.0;
- (void)animateMoveTiles:(NSArray *)moves completion:(dispatch_block_t)completion {
    CCTime longestDuration = 0;
    for (XJ1024Move *move in moves) {
        NodeTile *nodeTile = move.tile.nodeTile;
        NodeTile *mergedTile = move.mergedTile.nodeTile;
        if (nodeTile) {
            CGPoint oldPosition = [self positionWithColumn:move.originColumn row:move.originRow];
            CGPoint newPosition = [self positionWithColumn:move.targetColumn row:move.targetRow];
//            NSLog(@"oldposition = %@, newPosition = %@", NSStringFromCGPoint(oldPosition), NSStringFromCGPoint(newPosition));
            CCTime duration = ccpDistance(oldPosition, newPosition) / SPEED;
            longestDuration = MAX(longestDuration, duration);
            CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:duration position:newPosition];
            if (mergedTile) {
                // merge
                nodeTile.zOrder = 1;
                mergedTile.zOrder = 0;
                NSInteger value = move.tile.value;
                CCActionInterval *actMerge = [nodeTile actionMergeToValue:value];
                [nodeTile runAction:[CCActionSequence actionOne:moveTo two:actMerge]];
                
                [mergedTile runAction:[CCActionSequence actionOne:[moveTo copy] two:[CCActionRemove action]]];
                longestDuration = MAX(longestDuration, moveTo.duration + actMerge.duration);
            } else {
                [move.tile.nodeTile runAction:moveTo];
            }
        }
    }
    [self runAction:[CCActionSequence actionOne:[CCActionDelay actionWithDuration:longestDuration] two:[CCActionCallBlock actionWithBlock:completion]]];
}

#pragma mark - Helper
- (CGPoint)positionWithColumn:(NSInteger)column row:(NSInteger)row {
    NSAssert(column >= 0 && column < self.grid.numColumns && row >= 0 && row < self.grid.numRows, @"Invalid column<%ld> or row<%ld>", (long)column, (long)row);
    return ccpAdd(self.positionStart, ccp(self.tileWidth * column, self.tileHeight * row));
}
- (NSString *)tileNameWithColumn:(NSInteger)column row:(NSInteger)row {
    return [@(column + self.grid.numColumns + row) stringValue];
}
- (NodeTile *)nodeTileWithColumn:(NSInteger)column row:(NSInteger)row {
    return (NodeTile *)[self getChildByName:[self tileNameWithColumn:column row:row] recursively:NO];
}
@end
