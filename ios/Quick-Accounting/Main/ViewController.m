//
//  ViewController.m
//  Quick-Accounting
//
//  Created by Steven on 15/8/26.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <NSObjectExtend.h>
#import <BlocksKit.h>

/**
 *  检测新版本的URL
 */
#define CHECK_NEW_VERSION_URL @"https://github.com/qzs21/Quick-Accounting/raw/master/config/version.json"

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
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // 更换默认的JSON解析器
    [manager GET:CHECK_NEW_VERSION_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if ([data isKindOfClass:NSDictionary.class])
        {
            
            NSString * build = data[@"base"][@"build"];
            NSString * version = data[@"base"][@"version"];
            NSString * info = data[@"base"][@"info"];
            NSString * url = data[@"base"][@"url"];
            
            NSLog(@"[UIDevice appBuildVersion]: %@", [UIDevice appBuildVersion]);
            NSUInteger currentBuild = [[UIDevice appBuildVersion] integerValue];
            NSUInteger newBuild = [build integerValue];
            if (newBuild > currentBuild && url.length)
            {
                [[UIAlertView bk_showAlertViewWithTitle:@"有新版本更新哦！"
                                                message:[NSString stringWithFormat:@"版本:%@(build_%@)\n更新内容:%@", version, build, info]
                                      cancelButtonTitle:@"取消"
                                      otherButtonTitles:@[@"更新"]
                                                handler:^(UIAlertView *alertView, NSInteger buttonIndex)
                {
                    if (buttonIndex)
                    {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                    }
                }] show];
            }
        }
    } failure:nil];
}

@end
