//
//  ValueOfInvestmentViewController.h
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/7/8.
//  Copyright (c) 2015年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 中融钱包
 //
 // 文件功能描述：首页 - 项目详情 - 投资金额
 
 // 注意事项：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "AppNavView.h"
@interface ValueOfInvestmentViewController : UIViewController<UIScrollViewAccessibilityDelegate,UITextFieldDelegate,NavViewDelegate>
@property (nonatomic, strong) NSString *projectId;
@property (nonatomic, assign) float yearRoa;
@property (nonatomic, assign) NSInteger day;

@end
