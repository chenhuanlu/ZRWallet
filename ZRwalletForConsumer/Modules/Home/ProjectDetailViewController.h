//
//  ProjectDetailViewController.h
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/7/8.
//  Copyright (c) 2015年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 中融钱包
 //
 // 文件功能描述：首页 - 项目详情
 
 // 注意事项：
 //
 ----------------------------------------------------------------*/

#import <UIKit/UIKit.h>
#import "AppNavView.h"
@interface ProjectDetailViewController : UIViewController<UIScrollViewAccessibilityDelegate,NavViewDelegate>

@property (nonatomic, strong) NSString *projectName;
@property (nonatomic, strong) NSString *paybackType;
@property (nonatomic, strong) NSString *paybackTime;
@property (nonatomic, strong) NSString *raisingVolume;
@property (nonatomic, strong) NSString *yearRoa;
@property (nonatomic, strong) NSString *amonut;
@property (nonatomic, strong) NSString *projectId;
@property (nonatomic, strong) NSString *projectStatus;


@property (nonatomic, strong) NSDictionary *projectDesp;

@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger type;

@end
