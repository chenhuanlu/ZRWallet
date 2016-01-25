//
//  BillDetailViewController.h
//  ZRwalletForMerchant
//
//  Created by 文彬 on 15/7/9.
//  Copyright (c) 2015年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 中融钱宝
 //
 // 文件功能描述：账单--详情 根据orderType 复用 1：充值 4:理财收益  5：提现   9：二维码消费
                                            3：投资  6投资到期 归还本金
 // 注意事项：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface BillDetailViewController : BaseViewController

@property (strong, nonatomic) NSString *orderId;
@property (strong, nonatomic) NSString *orderType;

@end
