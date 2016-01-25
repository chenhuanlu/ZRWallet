//
//  LoginViewController.h
//  ZRwalletForMerchant
//
//  Created by 文彬 on 15/7/7.
//  Copyright (c) 2015年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 中融钱宝
 //
 // 文件功能描述：登录页面
 
 // 注意事项：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

typedef void(^LoginSuccessBlock)();
typedef void(^LoginFailBlock)();

@interface LoginViewController : BaseViewController

@property (strong, nonatomic) LoginSuccessBlock successBlock;
@property (strong, nonatomic) LoginFailBlock failBlock;
@property (weak, nonatomic) IBOutlet UIButton *RemberBtn;

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
- (IBAction)RemberPasswordBtnClick:(id)sender;

- (IBAction)buttonClickHandle:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *RegisterButton1;
- (IBAction)RegisterBtnclick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIButton *RemberLabel;
@property (weak, nonatomic) IBOutlet UIButton *ForgetLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


@end
