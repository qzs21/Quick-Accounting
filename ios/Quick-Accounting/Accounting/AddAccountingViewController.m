//
//  AddAccountingViewController.m
//  Quick-Accounting
//
//  Created by Steven on 15/8/22.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "AddAccountingViewController.h"
#import "AddAccountingCell.h"
#import "AccountingInfo.h"
#import <KeyboardManager.h>
#import <APNumberPad/APNumberPad.h>
#import "UIColor+Random.h"

@interface AddAccountingViewController () <UITableViewDataSource, UITableViewDelegate, APNumberPadDelegate>

@property (nonatomic, strong) NSMutableArray <AccountingInfo *> * cellInfoItems;

@property (nonatomic, strong) NSMutableArray <UIColor *> * colorItems;

@property (nonatomic, strong) UILabel * totalLabel;

- (IBAction)onClearButtonTouch:(UIBarButtonItem *)sender;

@end

@implementation AddAccountingViewController

PROPERTY_GET_METHOD(cellInfoItems, NSMutableArray);
PROPERTY_GET_METHOD(colorItems, NSMutableArray);

#pragma mark - APNumberPadDelegate

- (void)numberPad:(APNumberPad *)numberPad functionButtonAction:(UIButton *)functionButton textInput:(UIResponder<UITextInput> *)textInput {
    [textInput insertText:@"."];
}

- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    self.title = @"快速算帐";
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 95.0f;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self do_once_with_key:@"viewDidAppear:" block:^{
        [self addCellInfoItemAndScrollToBottom:YES];
    }];
}

- (void)addCellInfoItemAndScrollToBottom:(BOOL)scrollToBottom
{
    [self.cellInfoItems addObject:[[AccountingInfo alloc] init]];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.cellInfoItems.count-1 inSection:0]]
                     withRowAnimation:UITableViewRowAnimationFade];
    if (scrollToBottom)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]
                              atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)updateTotalLable
{
    double total = 0;
    for (AccountingInfo * info in self.cellInfoItems)
    {
        total += info.result;
    }
    self.totalLabel.text = [NSString stringWithFormat:@"¥: %.02lf", total];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.cellInfoItems.count;
    }
    else
    {
        return 3;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 60.0f;
    }
    else
    {
        if (indexPath.row == 1)
        {
            return 44.0f;
        }
        else
        {
            return 20.0f;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 64.0f;
    }
    else
    {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView * cell = [tableView dequeueReusableCellWithIdentifier:@"total"];
        UILabel * lab = (id)[cell viewWithTag:1000];
        lab.adjustsFontSizeToFitWidth = YES;
        self.totalLabel = lab;
        [self updateTotalLable];
        
        // 用UIView包装Cell，才能避免偶尔丢失header
        UIView *view = [[UIView alloc] initWithFrame:[cell frame]];
        cell.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [view addSubview:cell];
        return view;
    }
    else
    {
        return nil;
    }
}

- (APNumberPad *)setNumberPadWithField:(UITextField *)field
{
    APNumberPad *numberPad = [APNumberPad numberPadWithDelegate:self];
    [numberPad.leftFunctionButton setTitle:@"." forState:UIControlStateNormal];
    [numberPad.leftFunctionButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    numberPad.leftFunctionButton.enabled = [field.text rangeOfString:@"."].location == NSNotFound;
    numberPad.leftFunctionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    field.inputView = numberPad;
    return numberPad;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        AddAccountingCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        AccountingInfo * info = self.cellInfoItems[indexPath.row];
        
        // 按照数据设置text
        cell.priceField.text = [NSString stringWithFormat:@"%@", @(info.price)];
        cell.countField.text = [NSString stringWithFormat:@"%@", @(info.count)];
        cell.resultLab.text = [NSString stringWithFormat:@"¥: %.02lf", info.result];
        if (indexPath.row >= self.colorItems.count)
        {
            [self.colorItems addObject:[UIColor randomColor]];
        }
        cell.countLab.backgroundColor = self.colorItems[indexPath.row];
        
        // 如果数字为0，清空输入框
        if (info.price == 0) { cell.priceField.text = nil; }
        if (info.count == 0) { cell.countField.text = nil; }
        
        // 自定义数字键盘
        [self setNumberPadWithField:cell.priceField];
        [self setNumberPadWithField:cell.countField];
        
        // 输入时刷新总数
        [[[cell.priceField rac_signalForControlEvents:UIControlEventEditingChanged] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UITextField * x) {
            // 更新price
            info.price = x.text.doubleValue;
            // 更新子总数
            cell.resultLab.text = [NSString stringWithFormat:@"¥: %.02lf", info.result];
            // 更新所有总数
            [self updateTotalLable];
            APNumberPad *numberPad = (id)x.inputView;
            numberPad.leftFunctionButton.enabled = [x.text rangeOfString:@"."].location == NSNotFound;
        }];
        [[[cell.countField rac_signalForControlEvents:UIControlEventEditingChanged] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UITextField * x) {
            // 更新count
            info.count = x.text.doubleValue;
            // 更新子总数
            cell.resultLab.text = [NSString stringWithFormat:@"¥: %.02lf", info.result];
            // 更新所有总数
            [self updateTotalLable];
            // 更新小数点按钮可按
            APNumberPad *numberPad = (id)x.inputView;
            numberPad.leftFunctionButton.enabled = [x.text rangeOfString:@"."].location == NSNotFound;
        }];
                
        // 开始输入时，如果是最后一个，自动添加条目
        @weakify(self);
        [[[cell.countField rac_signalForControlEvents:UIControlEventEditingDidBegin] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UITextField * x) {
            if (indexPath.row == self.cellInfoItems.count - 1)
            {
                @strongify(self);
                
                if (self.cellInfoItems.lastObject.isDirty)
                {
                    [self addCellInfoItemAndScrollToBottom:NO];
                }
            }
        }];
        
        return cell;
    }
    else
    {
        UITableViewCell * cell = nil;
        if (indexPath.row == 1)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"add" forIndexPath:indexPath];
        }
        else
        {
            cell = [[UITableViewCell alloc] init];
            cell.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 1)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self addCellInfoItemAndScrollToBottom:YES];
    }
}
- (IBAction)onClearButtonTouch:(UIBarButtonItem *)sender
{
    NSMutableArray * items = [NSMutableArray array];
    for (NSInteger i = 0; i < self.cellInfoItems.count; i++)
    {
        [items addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [self.cellInfoItems removeAllObjects];
    [self.colorItems removeAllObjects];
    
    if (items.count)
    {
        [self.tableView deleteRowsAtIndexPaths:items withRowAnimation:UITableViewRowAnimationFade];
    }
    [self updateTotalLable];
    [self addCellInfoItemAndScrollToBottom:NO];
}

@end
