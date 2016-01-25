//
//  ForgetPasswordViewController.h
//  ZRwalletForMerchant
//
//  Created by 文彬 on 15/7/7.
//  Copyright (c) 2015年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 中融钱宝
 //
 // 文件功能描述：忘记密码--设置新密码
 
 // 注意事项：
 //
 ----------------------------------------------------------------*/


#import <UIKit/UIKit.h>

@interface ForgetPasswordViewController : BaseViewController<UITextFieldDelegate>

@property (strong, nonatomic) NSString *phoneNum; //前一个页面传过来的手机号

@end
