//
//  AddAccountingCell.h
//  Quick-Accounting
//
//  Created by Steven on 15/8/22.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAccountingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *priceField; ///< 单价

@property (weak, nonatomic) IBOutlet UITextField *countField; ///< 数量

@property (weak, nonatomic) IBOutlet UILabel *resultLab; ///< 总数

@property (weak, nonatomic) IBOutlet UILabel *countLab; ///< 当前Index

@property (weak, nonatomic) IBOutlet UIImageView *cellLine;


@end
