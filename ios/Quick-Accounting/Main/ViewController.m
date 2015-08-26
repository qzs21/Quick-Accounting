//
//  ViewController.m
//  Quick-Accounting
//
//  Created by Steven on 15/8/26.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置导航栏风格为黑色，让状态栏文字变成白色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    // 跳转界面
    [self replaceAllToStorayboardKey:@"Accounting"
                 toViewControllerKey:@"AddAccountingViewController"
                               param:nil
                            animated:UINavigationControllerAnimatedNone];
}

@end
