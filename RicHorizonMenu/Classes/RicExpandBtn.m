//
//  RicExpandBtn.m
//  john
//
//  Created by rice on 15/8/23.
//  Copyright (c) 2015年 rice. All rights reserved.
//

#import "RicExpandBtn.h"

@implementation RicExpandBtn

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect bounds = self.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat touchAreaRadius = self.touchAreaRadius > 44.0f ? self.touchAreaRadius : 44.0f;
    CGFloat widthDelta = MAX(touchAreaRadius - bounds.size.width, 0);
    CGFloat heightDelta = MAX(touchAreaRadius - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
