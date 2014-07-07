//
//  XJ1024Move.m
//  XJ1024CC2D
//
//  Created by JunXie on 14-7-7.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "XJ1024Move.h"

@interface XJ1024Move ()

@property (nonatomic, strong) XJ1024Tile      *   tile;
@property (nonatomic, strong) XJ1024Tile      *   mergedTile;
@property (nonatomic, assign) NSInteger         originColumn;
@property (nonatomic, assign) NSInteger         originRow;
@property (nonatomic, assign) NSInteger         targetColumn;
@property (nonatomic, assign) NSInteger         targetRow;
@end
@implementation XJ1024Move


+ (instancetype)moveWithTile:(XJ1024Tile *)tile mergedTile:(XJ1024Tile *)mergedTile originColumn:(NSInteger)originColumn originRow:(NSInteger)originRow targetColumn:(NSInteger)targetColumn targetRow:(NSInteger)targetRow {
    return [[[self class] alloc] initWithTile:tile mergedTile:mergedTile originColumn:originColumn originRow:originRow targetColumn:targetColumn targetRow:targetRow];
}
- (instancetype)initWithTile:(XJ1024Tile *)tile mergedTile:(XJ1024Tile *)mergedTile originColumn:(NSInteger)originColumn originRow:(NSInteger)originRow targetColumn:(NSInteger)targetColumn targetRow:(NSInteger)targetRow {
    if (self = [super init]) {
        self.tile = tile;
        self.mergedTile = mergedTile;
        self.originColumn = originColumn;
        self.originRow = originRow;
        self.targetColumn = targetColumn;
        self.targetRow = targetRow;
        
        self.score = 0;
    }
    return self;
}
@end
