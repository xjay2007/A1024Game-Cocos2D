//
//  XJ1024Grid.h
//  XJ1024CC2D
//
//  Created by JunXie on 14-7-3.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XJ1024Tile.h"
#import "XJ1024Move.h"

static NSString *const GRID_NUM_COLUMNS_KEY = @"numCols";
static NSString *const GRID_NUM_ROWS_KEY = @"numRows";
static NSString *const GRID_NUM_START_TILES_KEY = @"numStartTiles";
static NSString *const GRID_NUM_TARGET_VALUE_KEY = @"numTargetValue";
static NSString *const GRID_NUM_ZERO_VALUE_KEY = @"numZeroValue";
static NSString *const GRID_IS_ZERO_FIXED_KEY = @"isZeroFixed";

@interface XJ1024Grid : NSObject

@property (nonatomic, readonly) NSUInteger          numColumns;
@property (nonatomic, readonly) NSUInteger          numRows;
@property (nonatomic, readonly) NSUInteger          numStartTiles;
@property (nonatomic, readonly) NSInteger           targetValue;

@property (nonatomic, assign) NSUInteger            score;
@property (nonatomic, readonly) NSInteger           highestValue;

+ (instancetype)gridWithConfig:(NSDictionary *)config;
- (instancetype)initWithConfig:(NSDictionary *)config;

#pragma mark - Spawn
- (NSArray *)spawnStartTiles;
- (XJ1024Tile *)spawnRandomTile;
#pragma mark - Move
- (NSArray *)moveTilesWithDirection:(UISwipeGestureRecognizerDirection)direction;
- (BOOL)movedTileThisRound;

- (void)nextRound;
- (BOOL)isMovePossible;

#pragma mark - Helper
- (XJ1024Tile *)tileAtColumn:(NSInteger)column row:(NSInteger)row;
- (BOOL)indexValidWithColumn:(NSInteger)column row:(NSInteger)row;
@end
