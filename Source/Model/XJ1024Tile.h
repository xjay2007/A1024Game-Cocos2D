//
//  XJ1024Tile.h
//  XJ1024CC2D
//
//  Created by JunXie on 14-7-3.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NodeTile;
@interface XJ1024Tile : NSObject

+ (instancetype)tileWithColumn:(NSInteger)column row:(NSInteger)row value:(NSInteger)value;
- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row value:(NSInteger)value;
@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, weak)   NodeTile  *nodeTile;

@property (nonatomic, assign) BOOL      isMovedThisRound; // 
@property (nonatomic, assign) BOOL      isMergedThisRound;
@end
