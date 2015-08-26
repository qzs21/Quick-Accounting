//
//  AccountingInfo.h
//  Quick-Accounting
//
//  Created by Steven on 15/8/22.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountingInfo : NSObject

@property (nonatomic, assign) double price; ///< 单价

@property (nonatomic, assign) double count; ///< 数量

@property (nonatomic, readonly) double result; ///< 计算结果

@property (nonatomic, readonly) BOOL isDirty; ///< 初始化以后是否修改过数据

@end
