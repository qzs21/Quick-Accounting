//
//  UIColor+Random.m
//  Quick-Accounting
//
//  Created by Steven on 15/8/23.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "UIColor+Random.h"

@implementation UIColor (Random)

+(UIColor *)randomColor
{
    static BOOL seed = NO;
    if (!seed) {
        seed = YES;
        srandom((unsigned int)time((time_t *)NULL));
    }
    CGFloat red = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];//alpha为1.0,颜色完全不透明
}

@end
