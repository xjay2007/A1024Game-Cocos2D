//
//  SceneGame.m
//  XJ1024CC2D
//
//  Created by JunXie on 14-7-3.
//  Copyright 2014年 Apportable. All rights reserved.
//

#import "SceneGame.h"
#import "NodeGrid.h"

@interface SceneGame ()
@property (nonatomic, strong) UISwipeGestureRecognizer      *   swipeRight;
@property (nonatomic, strong) UISwipeGestureRecognizer      *   swipeLeft;
@property (nonatomic, strong) UISwipeGestureRecognizer      *   swipeUp;
@property (nonatomic, strong) UISwipeGestureRecognizer      *   swipeDown;
@end

@implementation SceneGame

- (void)didLoadFromCCB {
    NSDictionary *config = @{
                             GRID_NUM_COLUMNS_KEY: @(NUM_COLUMNS),
                             GRID_NUM_ROWS_KEY: @(NUM_ROWS),
                             GRID_NUM_START_TILES_KEY: @3,
                             GRID_NUM_TARGET_VALUE_KEY: @1024,
                             GRID_NUM_ZERO_VALUE_KEY: @1};
    self.grid = [XJ1024Grid gridWithConfig:config];
    
    _nodeGrid.grid = self.grid;
    _nodeGrid.positionStart = TILE_START_POSITION;
    _nodeGrid.tileWidth = TILE_WIDTH;
    _nodeGrid.tileHeight = TILE_HEIGHT;
    
    [self.grid addObserver:self forKeyPath:@"score" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)dealloc
{
    [self.grid removeObserver:self forKeyPath:@"score"];
}

- (void)onEnter {
    [super onEnter];
    
    [self addSwipeGestureRecognizer];
    [self enableSwipeGestureRecognizer:NO];
    
    [self gameStart];
}

- (void)onExit {
    [self removeSwipeGestureRecognizer];
    
    [super onExit];
}

- (void)gameStart {
    NSArray *arrTiles = [self.grid spawnStartTiles];
    [_nodeGrid animateSpawnTiles:arrTiles completion:^{
        [self enableSwipeGestureRecognizer:YES];
    }];
}

#pragma mark - Swipe

- (void)addSwipeGestureRecognizer {
    
    self.swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    self.swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [[CCDirector sharedDirector].view addGestureRecognizer:self.swipeLeft];
    
    self.swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    self.swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [[CCDirector sharedDirector].view addGestureRecognizer:self.swipeRight];
    
    self.swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    self.swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [[CCDirector sharedDirector].view addGestureRecognizer:self.swipeUp];
    
    self.swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    self.swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [[CCDirector sharedDirector].view addGestureRecognizer:self.swipeDown];
    
}
- (void)removeSwipeGestureRecognizer {
    
    [self.swipeLeft removeTarget:self action:@selector(swipe:)];
    [self.swipeRight removeTarget:self action:@selector(swipe:)];
    [self.swipeUp removeTarget:self action:@selector(swipe:)];
    [self.swipeDown removeTarget:self action:@selector(swipe:)];
    
    [[CCDirector sharedDirector].view removeGestureRecognizer:self.swipeRight];
    [[CCDirector sharedDirector].view removeGestureRecognizer:self.swipeLeft];
    [[CCDirector sharedDirector].view removeGestureRecognizer:self.swipeUp];
    [[CCDirector sharedDirector].view removeGestureRecognizer:self.swipeDown];
}

- (void)enableSwipeGestureRecognizer:(BOOL)enabled {
    self.swipeLeft.enabled = enabled;
    self.swipeRight.enabled = enabled;
    self.swipeUp.enabled = enabled;
    self.swipeDown.enabled = enabled;
}

- (void)swipe:(UISwipeGestureRecognizer *)sender {
    if (![sender isKindOfClass:[UISwipeGestureRecognizer class]]) {
        return;
    }
    [self move:sender.direction];
}
- (void)move:(UISwipeGestureRecognizerDirection)direction {
    NSArray *moves = [self.grid moveTilesWithDirection:direction];
    if ([moves count]) {
        NSInteger score = 0;
        for (XJ1024Move *move in moves) {
            score += move.score;
        }
        [self enableSwipeGestureRecognizer:NO];
        [_nodeGrid animateMoveTiles:moves completion:^{
            self.grid.score += score;
            [self updateScore];
            [self nextRound];
        }];
    }
}
- (void)nextRound {
    if (self.grid.movedTileThisRound) {
        if (self.grid.highestValue == self.grid.targetValue) {
            [self win];
        } else {
            [self.grid nextRound];
            XJ1024Tile *newTile = [self.grid spawnRandomTile];
            [_nodeGrid animateSpawnTiles:@[newTile] completion:^{
//                [self enableSwipeGestureRecognizer:YES];
                if ([self.grid isMovePossible]) {
                    //
                    [self enableSwipeGestureRecognizer:YES];
                } else {
                    [self lose];
                }
            }];
        }
    }
}

- (void)win {
    NSLog(@"win");
    
    [self resetScene];
}

- (void)lose {
    NSLog(@"Lose");
    
    [self resetScene];
}

- (void)resetScene {
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"SceneGame"]];
}

#pragma mark - UI
- (void)updateScore {
    _labelScore.string = [@(self.grid.score) stringValue];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqual:@"score"] && object == self.grid) {
        [self updateScore];
    }
}
@end
