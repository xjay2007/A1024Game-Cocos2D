//
//  NodeTile.m
//  XJ1024CC2D
//
//  Created by JunXie on 14-7-3.
//  Copyright 2014年 Apportable. All rights reserved.
//

#import "NodeTile.h"


@implementation NodeTile

- (void)setValue:(NSInteger)value {
    if (_value != value) {
        _value = value;
        
        [self updateValueDisplay];
    }
}

- (void)updateValueDisplay {
    CCSpriteFrame *frm = [self sprFrmWithValue:self.value];
    if (frm) {
        _sprCard.spriteFrame = frm;
    }
}

- (CCSpriteFrame *)sprFrmWithValue:(NSInteger)value {
    if (value >= 0 && value <= 2048) {
        NSString *name = [NSString stringWithFormat:@"cards/cube_%ld.png", (long)log2(value)];
        return [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name];
    }
    return nil;
}

- (CCActionInterval *)actionMergeToValue:(NSInteger)value {
    return [CCActionSequence actions:[CCActionScaleTo actionWithDuration:0.1 scaleX:0.0 scaleY:1.0], [CCActionCallBlock actionWithBlock:^{
        self.value = value;
    }], [CCActionScaleTo actionWithDuration:0.1 scaleX:1.0 scaleY:1.0], nil];
}
@end
