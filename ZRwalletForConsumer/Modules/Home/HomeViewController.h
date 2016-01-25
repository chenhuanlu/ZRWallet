//
//  HomeViewController.h
//  ZRwalletForMerchant
//
//  Created by 文彬 on 15/6/29.
//  Copyright (c) 2015年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 中融钱包
 //
 // 文件功能描述：首页
 
 // 注意事项：
 //
 ----------------------------------------------------------------*/

#import <UIKit/UIKit.h>
#import "CarouselsView.h"
#import "KDGoalBar.h"
#import "AppNavView.h"
@interface HomeViewController : UIViewController<CarouselsViewDelegate,UIScrollViewAccessibilityDelegate,NavViewDelegate>
@property (nonatomic, strong)  KDGoalBar *firstGoalBar;
@property (weak, nonatomic)  KDGoalBar *secondGoalBar;


@end
