//
//  XJ1024Move.h
//  XJ1024CC2D
//
//  Created by JunXie on 14-7-7.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  XJ1024Tile;
@interface XJ1024Move : NSObject
@property (nonatomic, strong, readonly) XJ1024Tile    *   tile;
@property (nonatomic, strong, readonly) XJ1024Tile    *   mergedTile;

@property (nonatomic, readonly) NSInteger               originColumn;
@property (nonatomic, readonly) NSInteger               originRow;
@property (nonatomic, readonly) NSInteger               targetColumn;
@property (nonatomic, readonly) NSInteger               targetRow;

@property (nonatomic, assign) NSInteger                 score;

+ (instancetype)moveWithTile:(XJ1024Tile *)tile
                  mergedTile:(XJ1024Tile *)mergedTile
                originColumn:(NSInteger)originColumn
                   originRow:(NSInteger)originRow
                targetColumn:(NSInteger)targetColumn
                   targetRow:(NSInteger)targetRow;
- (instancetype)initWithTile:(XJ1024Tile *)tile
                  mergedTile:(XJ1024Tile *)mergedTile
                originColumn:(NSInteger)originColumn
                   originRow:(NSInteger)originRow
                targetColumn:(NSInteger)targetColumn
                   targetRow:(NSInteger)targetRow;
@end
