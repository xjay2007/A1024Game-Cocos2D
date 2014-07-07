//
//  XJ1024Grid.m
//  XJ1024CC2D
//
//  Created by JunXie on 14-7-3.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "XJ1024Grid.h"

@interface XJ1024Grid()
@property (nonatomic, strong) NSMutableArray    *   arrTiles;
@property (nonatomic, strong) NSNull            *   noTile;
@property (nonatomic, assign) NSUInteger            numColumns;
@property (nonatomic, assign) NSUInteger            numRows;
@property (nonatomic, assign) NSUInteger            numStartTiles;
@property (nonatomic, assign) NSInteger             targetValue;
@property (nonatomic, assign) NSInteger             numZeroValue;
@property (nonatomic, assign) BOOL                  isZeroFixed;

@property (nonatomic, assign) BOOL                  movedTileThisRound;
@property (nonatomic, assign) NSInteger             highestValue;
@end

@implementation XJ1024Grid
+ (instancetype)gridWithConfig:(NSDictionary *)config {
    return [[[self class] alloc] initWithConfig:config];
}
- (instancetype)initWithConfig:(NSDictionary *)config {
    if (self = [super init]) {
        self.noTile = [NSNull null];
        self.numColumns = [config[GRID_NUM_COLUMNS_KEY] unsignedIntegerValue];
        self.numRows = [config[GRID_NUM_ROWS_KEY] unsignedIntegerValue];
        self.numStartTiles = [config[GRID_NUM_START_TILES_KEY] unsignedIntegerValue];
        self.targetValue = [config[GRID_NUM_TARGET_VALUE_KEY] integerValue];
        self.numZeroValue = [config[GRID_NUM_ZERO_VALUE_KEY] integerValue];
        self.isZeroFixed = [config[GRID_IS_ZERO_FIXED_KEY] boolValue];
        
        // arrTiles
        self.arrTiles = [NSMutableArray arrayWithCapacity:self.numColumns];
        for (NSInteger i = 0; i < self.numColumns; ++i) {
            self.arrTiles[i] = [NSMutableArray arrayWithCapacity:self.numRows];
            for (NSInteger j = 0; j < self.numRows; ++j) {
                self.arrTiles[i][j] = self.noTile;
            }
        }
    }
    return self;
}
- (instancetype)init {
    return [self initWithConfig:nil];
}

#pragma mark - Spawn
- (NSArray *)spawnStartTiles {
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:self.numStartTiles];
    for (NSInteger i = 0; i < self.numZeroValue; ++i) {
        XJ1024Tile *tile = [self spawnZeroTile];
        if (tile) {
            [ret addObject:tile];
        }
    }
    for (NSInteger i = 0; i < self.numStartTiles; ++i) {
        XJ1024Tile *tile = [self spawnRandomTile];
        if (tile) {
            [ret addObject:tile];
        }
    }
    return ret;
}
- (XJ1024Tile *)spawnRandomTile {
    XJ1024Tile *tile = nil;
    do {
        NSInteger randomColumn = arc4random_uniform((u_int32_t)self.numColumns);
        NSInteger randomRow = arc4random_uniform((u_int32_t)self.numRows);
        tile = [self tileAtColumn:randomColumn row:randomRow];
        if ([tile isEqual:self.noTile]) {
            tile = [self createTileAtColumn:randomColumn row:randomRow];
            break;
        }
    } while (YES);
    return tile;
}
- (XJ1024Tile *)spawnZeroTile {
    XJ1024Tile *tile = nil;
    do {
        NSInteger randomColumn = arc4random_uniform((u_int32_t)self.numColumns-2)+1;
        NSInteger randomRow = arc4random_uniform((u_int32_t)self.numRows-2)+1;
        tile = [self tileAtColumn:randomColumn row:randomRow];
        if ([tile isEqual:self.noTile]) {
            tile = [self createTileAtColumn:randomColumn row:randomRow];
            tile.value = 0;
            break;
        }
    } while (YES);
    return tile;
}
#pragma mark - Move
- (NSArray *)moveTilesWithDirection:(UISwipeGestureRecognizerDirection)direction {
    
    NSMutableArray *ret = [NSMutableArray array];
    NSInteger offsetX = 0;
    NSInteger offsetY = 0;
    switch (direction) {
        case UISwipeGestureRecognizerDirectionRight:
        {
            offsetX = 1;
            break;
        }
        case UISwipeGestureRecognizerDirectionLeft:
        {
            offsetX = -1;
            break;
        }
        case UISwipeGestureRecognizerDirectionUp:
        {
            offsetY = 1;
            break;
        }
        case UISwipeGestureRecognizerDirectionDown:
        {
            offsetY = -1;
            break;
        }
    }
    
    // apply negative vector until reaching boundary, this way we get the tile that bottom left corner
    NSInteger currentX = 0;
    NSInteger currentY = 0;
    // Move to relevant edge by applying direction until reaching border
    while ([self indexValidWithColumn:currentX row:currentY]) {
        CGFloat newX = currentX + offsetX;
        CGFloat newY = currentY + offsetY;
        if ([self indexValidWithColumn:newX row:newY]) {
            currentX = newX;
            currentY = newY;
        } else {
            break;
        }
    }
    // Store initial row value to reset after completing each column
    NSInteger initialY = currentY;
    // define changing of x and y value(moving left, up, down or right?)
    NSInteger xChange = -offsetX;
    NSInteger yChange = -offsetY;
    if (xChange == 0) {
        xChange = 1;
    }
    if (yChange == 0) {
        yChange = 1;
    }
    // visit column for column
    while ([self indexValidWithColumn:currentX row:currentY]) {
        while ([self indexValidWithColumn:currentX row:currentY]) {
            // get tile at current index
            XJ1024Tile *tile = [self tileAtColumn:currentX row:currentY];
            if ([tile isEqual:self.noTile] || (self.isZeroFixed && [tile isKindOfClass:[XJ1024Tile class]] && tile.value == 0)) {
                // if there is no tile at this index -> skip
                currentY += yChange;
                continue;
            }
            // store index in temp variables to change them and store new location of this tile
            NSInteger newX = currentX;
            NSInteger newY = currentY;
            // find the farthest position by iterating in direction of the vector until we reach border of grid or an occupied cell
            while ([self indexValidAndUnoccupiedWithColumn:newX+offsetX row:newY+offsetY]) {
                newX += offsetX;
                newY += offsetY;
            }
            BOOL isPerformMove = NO;
            // If we stop moving in vector direction, but next index in vector is valid, this means the cell is occupied. Let's check if we can merge them
            if ([self indexValidWithColumn:newX+offsetX row:newY+offsetY]) {
                // get the other tile
                NSInteger otherTileX = newX + offsetX;
                NSInteger otherTileY = newY + offsetY;
                XJ1024Tile *otherTile = [self tileAtColumn:otherTileX row:otherTileY];
                if (![otherTile isEqual:self.noTile] && tile.value == otherTile.value && !otherTile.isMergedThisRound) {
                    // merge tiles
                    // //
                    XJ1024Move *move = [XJ1024Move moveWithTile:tile mergedTile:otherTile originColumn:currentX originRow:currentY targetColumn:otherTileX targetRow:otherTileY];
                    move.score = tile.value * 2;
                    
                    tile.column = otherTileX;
                    tile.row = otherTileY;
                    tile.value = tile.value * 2;
                    tile.isMergedThisRound = YES;
                    otherTile.isMergedThisRound = YES;
                    self.arrTiles[otherTileX][otherTileY] = tile;
                    self.arrTiles[currentX][currentY] = self.noTile;
                    [ret addObject:move];
                } else {
                    isPerformMove = YES;
                }
            } else {
                isPerformMove = YES;
            }
            if (isPerformMove) {
                if (newX != currentX || newY != currentY) {
                    XJ1024Move *move = [XJ1024Move moveWithTile:tile mergedTile:nil originColumn:currentX originRow:currentY targetColumn:newX targetRow:newY];
                    tile.column = newX;
                    tile.row = newY;
//                    tile.isMovedThisRound = YES;
                    self.arrTiles[newX][newY] = tile;
                    self.arrTiles[currentX][currentY] = self.noTile;
                    [ret addObject:move];
                }
            }
            // move further in this column
            currentY += yChange;
        }
        // move to the next column, start at the inital row
        currentX += xChange;
        currentY = initialY;
    }
    
    self.movedTileThisRound = [ret count] > 0;
    if (self.movedTileThisRound) {
        // delete the move that contains merged tile
        NSMutableArray *arrMovesNeedRemoved = [NSMutableArray array];
        for (XJ1024Move *move in ret) {
            if (move.mergedTile == nil && move.tile.isMergedThisRound) {
                [arrMovesNeedRemoved addObject:move];
            }
            self.highestValue = MAX(self.highestValue, move.tile.value);
        }
        [ret removeObjectsInArray:arrMovesNeedRemoved];
    }
    return ret;
}

- (void)nextRound {
    for (NSArray *array in self.arrTiles) {
        for (XJ1024Tile *tile in array) {
            if ([tile isKindOfClass:[XJ1024Tile class]]) {
                tile.isMovedThisRound = NO;
                tile.isMergedThisRound = NO;
            }
        }
    }
}
- (BOOL)isMovePossible {
    for (NSArray *array in self.arrTiles) {
        if ([array containsObject:self.noTile]) {
            return YES;
        }
    }
    for (NSArray *array in self.arrTiles) {
        for (XJ1024Tile *tile in array) {
            if ([tile isKindOfClass:[NSNull class]]) {
                // free field
                return YES;
            } else {
                id tileTop = [self tileAtColumn:tile.column row:tile.row+1];
                id tileDown = [self tileAtColumn:tile.column row:tile.row-1];
                id tileLeft = [self tileAtColumn:tile.column-1 row:tile.row];
                id tileRight = [self tileAtColumn:tile.column+1 row:tile.row];
                NSArray *arrAround = @[tileTop, tileDown, tileLeft, tileRight];
                for (XJ1024Tile *tileAround in arrAround) {
                    if ([tileAround isKindOfClass:[XJ1024Tile class]] && tileAround.value == tile.value) {
                        return YES;
                    }
                }
            }
        }
    }
    return NO;
}
#pragma mark - Helper
- (XJ1024Tile *)tileAtColumn:(NSInteger)column row:(NSInteger)row {
    if (![self indexValidWithColumn:column row:row]) {
        return (id)self.noTile;
    }
//    NSAssert([self indexValidWithColumn:column row:row], @"Invalid column<%ld>, or row<%ld>", (long)column, (long)row);
    return self.arrTiles[column][row];
}
- (BOOL)indexValidWithColumn:(NSInteger)column row:(NSInteger)row {
    return column >= 0 && column < self.numColumns && row >= 0 && row < self.numRows;
}
- (XJ1024Tile *)createTileAtColumn:(NSInteger)column row:(NSInteger)row {
    XJ1024Tile *tile = [XJ1024Tile tileWithColumn:column row:row value:arc4random_uniform(2) ? 2 : 4];
    self.arrTiles[column][row] = tile;
    return tile;
}
- (BOOL)indexValidAndUnoccupiedWithColumn:(NSInteger)column row:(NSInteger)row {
    return [self indexValidWithColumn:column row:row] && ([[self tileAtColumn:column row:row] isEqual:self.noTile]);
}
@end
