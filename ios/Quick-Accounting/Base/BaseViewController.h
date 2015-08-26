//
//  BaseViewController.h
//  Quick-Accounting
//
//  Created by Steven on 15/8/22.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NSObjectExtend.h>
#import <ReactiveCocoa.h>
#import <BlocksKit.h>
#import <BlocksKit+UIKit.h>


@interface BaseViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITableView * tableView;

@end
