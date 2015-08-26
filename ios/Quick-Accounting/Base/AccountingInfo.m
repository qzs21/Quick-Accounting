//
//  AccountingInfo.m
//  Quick-Accounting
//
//  Created by Steven on 15/8/22.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "AccountingInfo.h"

@interface AccountingInfo()
{
    double _result;
    BOOL mIsDirty;
}
@end

@implementation AccountingInfo

- (instancetype)init
{
    if (self = [super init])
    {
        _count = 1.0;
    }
    return self;
}

- (void)setPrice:(double)price
{
    _price = price;
    _result = 0;
    mIsDirty = YES;
}

- (void)setCount:(double)count
{
    _count = count;
    _result = 0;
    mIsDirty = YES;
}

- (BOOL)isDirty
{
    return mIsDirty;
}

- (double)result
{
    if (_result == 0)
    {
        _result = _price * _count;
    }
    return _result;
}

@end
