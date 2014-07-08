//
//  NodeTile.m
//  XJ1024CC2D
//
//  Created by JunXie on 14-7-3.
//  Copyright 2014年 Apportable. All rights reserved.
//

#import "NodeTile.h"
#import "CCAnimation.h"


@implementation NodeTile

- (void)didLoadFromCCB {
    [self updateEyeDisplay];
    [self runNormalAction];
}

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
    
    [self updateEyeDisplay];
}

- (void)updateEyeDisplay {
    _sprEyeLeft.visible = self.value != 0;
    _sprEyeRight.visible = _sprEyeLeft.visible;
}

- (CCSpriteFrame *)sprFrmWithValue:(NSInteger)value {
    if (value >= 0 && value <= 2048) {
        NSString *name = [NSString stringWithFormat:@"cards/cube_%ld.png", (long)log2(value)];
//        return [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name];
        return [[CCSprite spriteWithImageNamed:name] spriteFrame];
    }
    return nil;
}

- (CCActionInterval *)actionMergeToValue:(NSInteger)value {
    return [CCActionSequence actions:[CCActionScaleTo actionWithDuration:0.1 scaleX:0.0 scaleY:1.0], [CCActionCallBlock actionWithBlock:^{
        self.value = value;
    }], [CCActionScaleTo actionWithDuration:0.1 scaleX:1.0 scaleY:1.0], [CCActionCallFunc actionWithTarget:self selector:@selector(runHappyAction)], nil];
}

#pragma mark - Eye Mouth Action
- (void)runHappyAction {
    [_sprMouth stopAllActions];
    _sprMouth.scale = 1.0;
    [_sprMouth runAction:[CCActionSequence actions:[CCActionScaleTo actionWithDuration:0.2 scaleX:0.3 scaleY:1.0], [CCActionDelay actionWithDuration:0.5], [CCActionScaleTo actionWithDuration:0.2 scale:1.0], nil]];
}
- (void)runNormalAction {
    NSArray *array = @[[[CCSprite spriteWithImageNamed:@"cards/eye.png"] spriteFrame], [[CCSprite spriteWithImageNamed:@"cards/eye_1.png"] spriteFrame]];
//    NSArray *array = @[[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"cards/eye.png"], [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"cards/eye_1.png"]];
    
    CCActionSequence *seq = [CCActionSequence actionOne:[CCActionAnimate actionWithAnimation:[CCAnimation animationWithSpriteFrames:array delay:1.0/4.0]] two:[CCActionDelay actionWithDuration:CCRANDOM_0_1() * 5.0]];
    [_sprEyeLeft stopAllActions];
    [_sprEyeRight stopAllActions];
    [_sprEyeLeft runAction:seq];
    [_sprEyeRight runAction:[seq copy]];
    
    [self runAction:[CCActionSequence actionOne:[CCActionDelay actionWithDuration:seq.duration] two:[CCActionCallFunc actionWithTarget:self selector:@selector(runNormalAction)]]];
}
@end
