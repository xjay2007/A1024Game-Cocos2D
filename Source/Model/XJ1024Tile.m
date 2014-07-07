//
//  XJ1024Tile.m
//  XJ1024CC2D
//
//  Created by JunXie on 14-7-3.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#import "XJ1024Tile.h"

@implementation XJ1024Tile

+ (instancetype)tileWithColumn:(NSInteger)column row:(NSInteger)row value:(NSInteger)value {
    return [[[self class] alloc] initWithColumn:column row:row value:value];
}
- (instancetype)init {
    return [self initWithColumn:NSNotFound row:NSNotFound value:0];
}
- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row value:(NSInteger)value {
    if (self = [super init]) {
        _column = column;
        _row = row;
        _value = value;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    XJ1024Tile *other = object;
    return [other isKindOfClass:[self class]] && other.column == self.column && other.row == self.row && other.value == self.value;
}
@end
