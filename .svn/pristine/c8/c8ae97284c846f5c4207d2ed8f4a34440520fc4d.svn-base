//
//  PaymentViewController.h
//  ZRwalletForMerchant
//
//  Created by 文彬 on 15/7/21.
//  Copyright (c) 2015年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 中融钱宝
 //
 // 文件功能描述：付款页面
 
 // 注意事项：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "MyPreferentialModel.h"
#import "AppNavView.h"

@interface PaymentViewController : BaseViewController<UIAlertViewDelegate,NavViewDelegate>

@property (strong, nonatomic) NSString *orderId; //订单id

@property (strong, nonatomic) MyPreferentialModel *selectPreferntial; //选择的优惠券

- (IBAction)buttonClickHandle:(id)sender;

- (void)refreshStatus;

@end
