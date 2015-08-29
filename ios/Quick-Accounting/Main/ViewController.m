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
    
    
    [[AFHTTPRequestOperationManager manager] GET:CHECK_NEW_VERSION_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:NSDictionary.class])
        {
            NSDictionary * data = responseObject;
            
            NSString * build = data[@"base"][@"build"];
            NSString * version = data[@"base"][@"version"];
            NSString * info = data[@"base"][@"info"];
            NSString * url = data[@"base"][@"url"];
            
            NSUInteger currentVersion = [[UIDevice appBuildVersion] integerValue];
            NSUInteger newVersion = [build integerValue];
            if (newVersion > currentVersion && url.length)
            {
                [[UIAlertView bk_showAlertViewWithTitle:@"有新版本更新哦！"
                                                message:[NSString stringWithFormat:@"%@(build:%@)\n%@", version, build, info]
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
