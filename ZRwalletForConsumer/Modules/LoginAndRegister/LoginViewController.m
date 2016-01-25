//
//  LoginViewController.m
//  ZRwalletForMerchant
//
//  Created by 文彬 on 15/7/7.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterOfPhoneNumViewController.h"
#import "ForgetPasswordViewController.h"
#import "MyTabBarController.h"
#import "ForgetPwdOfPhoneInputViewController.h"
#import "UIColor+NSString.h"
#import "SecurityTool.h"
#define kTag_Button_Login 100  //登录
#define kTag_Button_Register 101 //注册
#define kTag_Button_ForgetPwd 102 //忘记密码

@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTxtField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma mark 添加背景图片
    // Do any additional setup after loading the view from its nib.
    [self initPageControl];
    _passwordTxtField.delegate = self;
    _phoneTxtField.delegate = self;
    _phoneTxtField.keyboardType = UIKeyboardTypePhonePad;
    [StaticTools addTopViewInTextFeild:_phoneTxtField withMessage:@" 手机号/用户名"];
    _passwordTxtField.returnKeyType = UIReturnKeyDone;
    self.phoneView.layer.borderColor = [UIColor grayColor].CGColor;
    self.phoneView.layer.borderWidth = 1;
    self.phoneView.layer.cornerRadius = 5;
    self.phoneView.clipsToBounds = YES;
    
    if (ScreenHeight==736) {
        self.RemberLabel.titleLabel.font = [UIFont systemFontOfSize:18];
        self.ForgetLabel.titleLabel.font = [UIFont systemFontOfSize:18];
    }
    else {
        self.RemberLabel.titleLabel.font = [UIFont systemFontOfSize:15];
        self.ForgetLabel.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    
    
    [self.phoneView makeConstraints:^(MASConstraintMaker *make) {
        if (SCREEN_HEIGHT==667||ScreenHeight==736) {
            make.top.equalTo(self.logoImage.bottom).offset(40);
            make.right.equalTo(@-20);
            make.left.equalTo(@20);
            make.height.equalTo(@50);
        }
        else
        {
            make.top.equalTo(self.logoImage.bottom).offset(20);
            make.right.equalTo(@-20);
            make.left.equalTo(@20);
            make.height.equalTo(@40);
  
        }
    }];
    
    self.passwordView.layer.cornerRadius = 5;
    self.passwordView.clipsToBounds = YES;
    self.passwordView.layer.borderWidth = 1;
    self.passwordView.layer.borderColor = [UIColor grayColor].CGColor;
    self.view.backgroundColor = RGBCOLOR(232, 231, 231);
    
    [self.passwordView makeConstraints:^(MASConstraintMaker *make) {
        if (SCREEN_HEIGHT==667||ScreenHeight==736) {
            make.top.equalTo(self.phoneView.bottom).offset(30);
            make.left.equalTo(@20);
            make.right.equalTo(@-20);
            make.height.equalTo(@50);

        }
        else
        {
            make.top.equalTo(self.phoneView.bottom).offset(10);
            make.left.equalTo(@20);
            make.right.equalTo(@-20);
            make.height.equalTo(@40);
        }
        
    }];
    
    [self.RemberBtn makeConstraints:^(MASConstraintMaker *make) {
        
        if (ScreenHeight==736) {
            make.top.equalTo(self.passwordView.bottom).offset(20);
            make.left.equalTo(self.passwordView.left);
            make.width.equalTo(@50);
            make.height.equalTo(@50);
        }
        else
        {
            make.top.equalTo(self.passwordView.bottom).offset(10);
            make.left.equalTo(self.passwordView.left);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }
        
    }];
    
    [self.RemberLabel makeConstraints:^(MASConstraintMaker *make) {
        
        if (ScreenHeight==736) {
            make.left.equalTo(self.RemberBtn.right);
            make.height.equalTo(@50);
            make.top.equalTo(self.RemberBtn);
            make.width.equalTo(@80);
        }
        else
        {
            make.left.equalTo(self.RemberBtn.right);
            make.height.equalTo(@30);
            make.top.equalTo(self.RemberBtn);
            make.width.equalTo(@70);
        }
      
    }];
    
    [self.ForgetLabel makeConstraints:^(MASConstraintMaker *make) {
        if (ScreenHeight==736) {
            make.right.equalTo(self.phoneView.right);
            make.height.equalTo(@50);
            make.top.equalTo(self.RemberBtn);
            make.width.equalTo(@100);

        }
       else
       {
        make.right.equalTo(self.phoneView.right);
        make.height.equalTo(@30);
        make.top.equalTo(self.RemberBtn);
        make.width.equalTo(@70);
       }
    }];
    
    [self.RegisterButton1 makeConstraints:^(MASConstraintMaker *make) {
        if (ScreenHeight==736) {
            make.left.equalTo(self.RemberBtn.left);
            make.right.equalTo(self.RemberLabel.right);
            make.height.equalTo(@40);
            make.top.equalTo(self.RemberBtn.bottom).offset(15);
        }
        else
        {
            make.left.equalTo(self.RemberBtn.left);
            make.right.equalTo(self.RemberLabel.right);
            make.height.equalTo(@40);
            make.top.equalTo(self.RemberBtn.bottom).offset(5);
        }
       
    }];
    
    [self.loginBtn makeConstraints:^(MASConstraintMaker *make) {
        if (ScreenHeight==736) {
            make.right.equalTo(self.ForgetLabel.right);
            make.top.equalTo(self.RegisterButton1.top);
            make.width.equalTo(self.RegisterButton1.mas_width);
        }
        else
        {
            make.right.equalTo(self.ForgetLabel.right);
            make.top.equalTo(self.ForgetLabel.bottom).offset(5);
            make.width.equalTo(self.RegisterButton1.mas_width);
        }
        
    }];
    self.logoImage.contentMode =  UIViewContentModeScaleAspectFit;
    
    //**************** 返回按钮*******************
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 10, 50, 30);
    [backBtn setImage:[UIImage imageNamed:@"an_yhdl_ret"] forState:UIControlStateNormal];
    backBtn.contentMode =  UIViewContentModeScaleAspectFit;
    [backBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(@20);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //一键删除
    textField.clearButtonMode=UITextFieldViewModeAlways;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
     textField.clearButtonMode= UITextFieldViewModeNever;
}
-(void)btn
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UserDefaults removeObjectForKey:kLoginToken];
    [UserDefaults setObject:@"0" forKey:kIsLogin];
    [UserDefaults synchronize];//保存到本地
    
    //注册成功后  将手机号带过来
    if (APPDataCenter.temPhone!=nil)
    {
        self.phoneTxtField.text = APPDataCenter.temPhone;
        self.passwordTxtField.text = nil;
        
        self.RemberBtn.selected = NO;
    }

    [self.navigationController setNavigationBarHidden:YES animated:animated];//过渡没有黑色
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)back
{
    [[HttpRequest sharedRequest] cancelLastRequst];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
    

}
#pragma mark 功能函数
/**
 *  初始化页面函数
 */
- (void)initPageControl
{
    [self initNavgationcontrollerLeftButton];
    
    self.navigationItem.title = @"用户登录";
        [self.navigationController.navigationBar setBarTintColor:RGBCOLOR(206, 0, 33)];
    //***********************导航栏设置*********************
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor], UITextAttributeFont:[UIFont boldSystemFontOfSize:18]};
    [self.navigationController.navigationBar setBarTintColor:RGBCOLOR(206, 0, 33)];
     //************用户名和密码输入框设置*************
    UILabel *showLabel = [[UILabel alloc] init];
    showLabel.text = @"显示密码";
    showLabel.font = [UIFont systemFontOfSize:10];
    showLabel.textColor = [UIColor grayColor];

     //********************记住用户名和密码*********************
    [self.RemberBtn setImage:[UIImage imageNamed:@"agree_no.png"] forState:UIControlStateNormal];
    [self.RemberBtn setImage:[UIImage imageNamed:@"icon_s2.png"] forState:UIControlStateSelected];
    
    NSString *rememberPassword = [UserDefaults objectForKey:kREMEBERPWD];
    
    if ([rememberPassword isEqualToString:@"1"]) {
        
        self.RemberBtn.selected = YES;
        self.passwordTxtField.text = [UserDefaults objectForKey:kPASSWORD];
    }
    else
    {
        self.RemberBtn.selected = NO;
    }
    
   
    if ([UserDefaults objectForKey:PHONENUM]!=nil)
    {
        self.phoneTxtField.text = [UserDefaults objectForKey:PHONENUM];
    }
    
    //*******************显示密码*************************
    
    
}





/**
 *  检测页面输入合法性
 *
 *  @return
 */
- (BOOL)checkPageInput
{
    if ([StaticTools isEmptyString:self.phoneTxtField.text])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入用户名"];
        return NO;
    }
    else if([StaticTools isEmptyString:self.passwordTxtField.text])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return NO;
    }
    return YES;
}
#pragma mark 按钮点击事件
- (IBAction)RemberPasswordBtnClick:(id)sender {
    
    //记住密码
    self.RemberBtn.selected = self.RemberBtn.selected ? NO : YES;

}

- (IBAction)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    switch (button.tag)
    {
        case kTag_Button_Login: //登录
        {
//            [UserDefaults setObject:@"1" forKey:kIsLogin];
//            [UserDefaults synchronize];
//            [self dismissViewControllerAnimated:YES completion:nil];
            //return; //TODO
            
            if ([self checkPageInput])
            {
                [self login];
            }
        }
            break;
        case kTag_Button_Register: //注册
        {
            RegisterOfPhoneNumViewController *phoneInputController = [[RegisterOfPhoneNumViewController alloc]init];
            [self.navigationController pushViewController:phoneInputController animated:YES];
        }
            break;
        case kTag_Button_ForgetPwd: //忘记密码
        {
            ForgetPwdOfPhoneInputViewController *fotgetPwdController = [[ForgetPwdOfPhoneInputViewController alloc]init];
            [self.navigationController pushViewController:fotgetPwdController animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark HTTP
/**
 *  登录
 */
- (void)login
{
    [[HttpRequest sharedRequest] sendRequestWithMessage:@"正在登陆" path:@"getTocken" param:@{@"phoneNumber":self.phoneTxtField.text, @"password":[SecurityTool md5:self.passwordTxtField.text]} succuss:^(id result) {
        
        [UserDefaults setObject:self.phoneTxtField.text forKey:PHONENUM];
        [UserDefaults setObject:self.passwordTxtField.text forKey:PASSWORD];
        
        [UserDefaults setObject:@"1" forKey:kIsLogin];
        if (self.RemberBtn.selected==YES)
        {
            [UserDefaults setObject:@"1" forKey:kREMEBERPWD];
            [UserDefaults setObject:self.passwordTxtField.text forKey:kPASSWORD];
        }
        else
        {
            [UserDefaults removeObjectForKey:PASSWORD];
            [UserDefaults setObject:@"0" forKey:kREMEBERPWD];
            self.passwordTxtField.text = nil;
        }
        [UserDefaults synchronize];
        [self dismissViewControllerAnimated:YES completion:^{
            
            if ([UserDefaults objectForKey:kLockPwd]==nil)
            {
                [StaticTools showLockViewWithType:LLLockViewTypeCreate];
            }
        }];
        //获取用户 数据
        [self getUserDataRequest];
        
        if (self.successBlock!=nil) {
            self.successBlock();
        }
        
    } fail:^{
        if (self.failBlock!=nil) {
            self.failBlock();
        }
    }];
}
-(void)getUserDataRequest
{
    [[HttpRequest sharedRequest]sendRequestWithMessage:@"" path:@"getInfo" param:nil succuss:^(id result) {
        
        [UserDefaults setObject:result[@"accountName"] forKey:USER_NICKNAME];
        [UserDefaults setObject:result[@"avatarPath"] forKey:USER_PHOTO];
        [UserDefaults setObject:result[@"bankCard"] forKey:USER_BANKCARD];
        [UserDefaults synchronize];
        
        
    } fail:nil];
    
}

- (IBAction)RegisterBtnclick:(id)sender {
    RegisterOfPhoneNumViewController *phoneInputController = [[RegisterOfPhoneNumViewController alloc]init];
    [self.navigationController pushViewController:phoneInputController animated:YES];
}
@end
