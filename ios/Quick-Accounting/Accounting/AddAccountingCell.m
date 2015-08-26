//
//  AddAccountingCell.m
//  Quick-Accounting
//
//  Created by Steven on 15/8/22.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "AddAccountingCell.h"
#import <ReactiveCocoa.h>

@implementation AddAccountingCell

- (void)awakeFromNib
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    [[self.priceField rac_signalForControlEvents:UIControlEventEditingDidBegin] subscribeNext:^(UITextField * x) {
        // 开始编辑时选中所有文本
        NSString * text = x.text;
        x.text = nil;
        [x setMarkedText:text selectedRange:NSMakeRange(0, text.length)];
    }];
    [[self.countField rac_signalForControlEvents:UIControlEventEditingDidBegin] subscribeNext:^(UITextField * x) {
        // 开始编辑时选中所有文本
        NSString * text = x.text;
        x.text = nil;
        [x setMarkedText:text selectedRange:NSMakeRange(0, text.length)];
    }];
}

@end
