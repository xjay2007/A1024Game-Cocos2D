//
//  SceneMenu.m
//  XJ1024CC2D
//
//  Created by JunXie on 14-7-7.
//  Copyright 2014年 Apportable. All rights reserved.
//

#import "SceneMenu.h"
#import "XJ1024Grid.h"
#import "SceneGame.h"

@implementation SceneMenu

- (void)onMode:(CCControl *)sender {
    NSMutableDictionary *config = [@{
                             GRID_NUM_COLUMNS_KEY: @(NUM_COLUMNS),
                             GRID_NUM_ROWS_KEY: @(NUM_ROWS),
                             GRID_NUM_START_TILES_KEY: @3,
                             GRID_NUM_TARGET_VALUE_KEY: @1024,
                             GRID_NUM_ZERO_VALUE_KEY: @1,
                             GRID_IS_ZERO_FIXED_KEY: @YES} mutableCopy];
    switch ([sender.name integerValue]) {
        case 0:
        {
            config[GRID_NUM_TARGET_VALUE_KEY] = @2048;
            config[GRID_NUM_ZERO_VALUE_KEY] = @0;
            config[GRID_IS_ZERO_FIXED_KEY] = @NO;
            break;
        }
        case 1:
        {
            break;
        }
        case 2:
        {
            config[GRID_IS_ZERO_FIXED_KEY] = @NO;
            break;
        }
        default:
            break;
    }
    [[CCDirector sharedDirector] replaceScene:[SceneGame sceneWithConfig:config]];
}
@end
