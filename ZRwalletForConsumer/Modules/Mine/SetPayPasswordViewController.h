//
//  SetPayPasswordViewController.h
//  ZRwalletForConsumer
//
//  Created by 文彬 on 15/7/25.
//  Copyright (c) 2015年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 中融钱宝
 //
 // 文件功能描述：银行卡绑定完后设置支付密码
 
 // 注意事项：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "AppNavView.h"
@interface SetPayPasswordViewController : BaseViewController<UITextFieldDelegate,NavViewDelegate>

@property (strong, nonatomic) NSMutableDictionary *infoDict;

@end
