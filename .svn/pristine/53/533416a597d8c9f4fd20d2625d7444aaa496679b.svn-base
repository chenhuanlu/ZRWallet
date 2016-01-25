//
//  RegisterOfPhoneNumViewController.m
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/8/24.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

static int backViewTag = 1000;
static int textFieldImgViewTag = 2000;
static int textFieldTag = 3000;

#import "RegisterOfPhoneNumViewController.h"
#import "RegisterOfBaseInfoViewController.h"
#import "UIColor+NSString.h"
@interface RegisterOfPhoneNumViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UITextField *invitationCodeField;

@property (nonatomic, strong) UIImageView *textFieldImgView;

@property (nonatomic, strong) UILabel *agreeLabel;
@property (nonatomic, strong) UIButton *agreeBtn;

@property (nonatomic, strong) UIButton *nextStepBtn;


@end

@implementation RegisterOfPhoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    self.view.backgroundColor = RGBCOLOR(239, 244, 244);
    [self makeView];
}
- (void)makeView
{
    NSArray *picArrary = @[@"ip_shdl_usar",@"ip_shdl_usar"];
    NSArray *placeholderArrary = @[@"请输入手机号",@"请输入邀请码"];
    
    for (int i = 0 ; i < 2; i ++) {
        
        self.backView = [UIView new];
        self.backView.backgroundColor = [UIColor whiteColor];
        self.backView.tag = backViewTag + i;
        [self.backView addLine];
        [self.view addSubview:self.backView];
        
        self.textFieldImgView = [UIImageView new];
        self.textFieldImgView.image = [UIImage imageNamed:picArrary[i]];
        self.textFieldImgView.tag = textFieldImgViewTag + i;
        [self.backView addSubview:self.textFieldImgView];
        
        self.textField = [UITextField new];
        self.textField.placeholder = placeholderArrary[i];
        self.textField.delegate = self;
        self.textField.keyboardType = UIReturnKeyDefault;
        self.textField.returnKeyType = UIReturnKeyDone;
        self.textField.tag = textFieldTag + i;
        [self.backView addSubview:self.textField];
        
    }

    self.agreeBtn = [UIButton new];
    [self.agreeBtn addTarget:self
                      action:@selector(agreeBtnDown)
            forControlEvents:UIControlEventTouchUpInside];
    
    [self.agreeBtn setImage:[UIImage imageNamed:@"agree_no.png"] forState:UIControlStateNormal];
    [self.agreeBtn setImage:[UIImage imageNamed:@"icon_s2.png"] forState:UIControlStateSelected];
    self.agreeBtn.selected = YES;
    [self.view addSubview:self.agreeBtn];
    
    self.agreeLabel = [UILabel new];
    self.agreeLabel.text = @"同意中融钱宝《使用协议》及《隐私条款》";
    self.agreeLabel.font = [UIFont systemFontOfSize:13];
    self.agreeLabel.textColor = RGBCOLOR(123, 123, 123);
    [self.view addSubview:self.agreeLabel];
    
    NSRange range1 = [self.agreeLabel.text rangeOfString:@"《使用协议》"];
    NSRange range2 = [self.agreeLabel.text rangeOfString:@"《隐私条款》"];
    
    NSMutableAttributedString *attributedStr1 = [[NSMutableAttributedString alloc]
                                                 initWithString:self.agreeLabel.text];
    [attributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(24, 107, 244)
                           range:range1];
    [attributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(24, 107, 244)
                           range:range2];
    self.agreeLabel.attributedText = attributedStr1;

    self.nextStepBtn = [UIButton new];
    self.nextStepBtn.backgroundColor = RGBCOLOR(206, 0, 33);
    self.nextStepBtn.layer.masksToBounds = YES;
    self.nextStepBtn.layer.cornerRadius = 4.0;
    [self.nextStepBtn addTarget:self
                        action:@selector(nextStepBtnDown)
              forControlEvents:UIControlEventTouchUpInside
     ];
    [self.nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    self.nextStepBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:self.nextStepBtn];

}
#pragma mark 功能函数
- (BOOL)checkPageInput
{
    self.phoneField = (UITextField *)[self.view viewWithTag:textFieldTag];
    
    if ([StaticTools isEmptyString:self.phoneField.text])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return NO ;
    }
    else if(![StaticTools isMobileNumber:self.phoneField.text])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入一个正确的手机号"];
        return NO;
    }
    
    if(!self.agreeBtn.selected)
    {
        [SVProgressHUD showErrorWithStatus:@"请同意中融钱包使用协议"];
        return NO;
    }
    return YES;
}

-(void)nextStepBtnDown
{
    if ([self checkPageInput])
    {
        [self validataPhone];
    }

}
#pragma mark HTTP
/**
 *  验证手机号是否注册  未注册时 后台将发送一条短信验证码
 */
- (void)validataPhone
{
    self.invitationCodeField = (UITextField *)[self.view viewWithTag:textFieldTag + 1];

    [[HttpRequest sharedRequest] sendRequestWithMessage:nil path:@"reg/validateUserPhone" param:@{@"phoneNumber":self.phoneField.text}  succuss:^(id result) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:result delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        RegisterOfBaseInfoViewController *baseInfoController = [[RegisterOfBaseInfoViewController alloc]init];
        baseInfoController.phoneNum = self.phoneField.text;
        baseInfoController.invitationCode = self.invitationCodeField.text;
        [self.navigationController pushViewController:baseInfoController animated:YES];
        
    } fail:nil];
    
}

-(void)agreeBtnDown
{
    self.agreeBtn.selected = self.agreeBtn.selected ? NO : YES;
}
#pragma mark TextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField.tag != textFieldTag + 1) {
        UITextField *text = (UITextField*)[self.view viewWithTag:textField.tag+1];
        [text becomeFirstResponder];
        
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    for (int i = 0 ; i < 2; i++) {
       
        self.backView = (UIView *)[self.view viewWithTag:backViewTag + i];
        self.backView.size = CGSizeMake(SCREEN_WIDTH, 40);
        self.backView.viewTop = 20 + i*(self.backView.size.height + 10);
        
        self.textFieldImgView = (UIImageView *)[self.view viewWithTag:textFieldImgViewTag + i];
        self.textFieldImgView.size = CGSizeMake(12, 20);
        self.textFieldImgView.viewLeft = 30;
        self.textFieldImgView.viewCenterY = self.backView.size.height/2;

        self.textField = (UITextField *)[self.view viewWithTag:textFieldTag + i];
        self.textField.size = CGSizeMake(self.backView.size.width - self.textFieldImgView.viewRight , 30);
        self.textField.viewTop = 5;
        self.textField.viewLeft = self.textFieldImgView.viewRight + 30;
        
    }
    self.agreeBtn.size = CGSizeMake(18, 18);
    self.agreeBtn.viewLeft = 20;
    self.agreeBtn.viewTop = self.backView.viewBottom + 30;
    
    self.agreeLabel.size = CGSizeMake(SCREEN_WIDTH - 65, 20);
    self.agreeLabel.viewLeft = self.agreeBtn.viewRight + 10;
    self.agreeLabel.viewTop = self.agreeBtn.viewTop;
    
    self.nextStepBtn.size = CGSizeMake(SCREEN_WIDTH - 20, SCREEN_WIDTH/8);
    self.nextStepBtn.viewLeft = 10;
    self.nextStepBtn.viewTop = self.agreeLabel.viewBottom + 70;

}
@end
