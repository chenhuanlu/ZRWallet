//
//  PayPasswordViewController.m
//  ZRwalletForMerchant
//
//  Created by 文彬 on 15/7/20.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "PayPasswordViewController.h"

#define kTag_Button_Cancel  100 //取消
#define kTag_Button_Ok       101 //确定

@interface PayPasswordViewController ()

@property (weak, nonatomic) IBOutlet UIView *pwdBgView;
@property (weak, nonatomic) IBOutlet UIView *roundView;
@property (weak, nonatomic) IBOutlet UITextField *pwdTxtField;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIView *upLineView; //分割线
@property (weak, nonatomic) IBOutlet UIView *downLineView; //分割线
@property (weak, nonatomic) IBOutlet UIView *pwdInputBgView; //密码输入背景
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@end

@implementation PayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    [self initPageControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //216 为键盘高度 
    [self.pwdBgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@((SCREEN_HEIGHT-216-self.pwdBgView.frame.size.height)/2-20));
    }];
    [UIView animateWithDuration:0.4 animations:^{
        self.view.alpha = 1;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
           [self.pwdTxtField becomeFirstResponder];
    }];
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

#pragma mark 功能函数

- (void)initPageControl
{
    self.view.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
    self.view.alpha = 0;
    self.roundView.layer.cornerRadius = 5;
    
    if ([self.payMoneyStr isEqualToString:@"0"])
    {
        self.moneyLabel.text = @"支付密码";
    }
    else
    {
         self.moneyLabel.attributedText = [StaticTools getMoneyTextAtributionWithText:[NSString stringWithFormat:@"本次支付共需￥%@",self.payMoneyStr] frontFont:[UIFont systemFontOfSize:15] frontColor:[UIColor blackColor] moneyFont:[UIFont boldSystemFontOfSize:17] moneyColor:[UIColor redColor]];
    }
   
    
    
    [self.upLineView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
    }];
    [self.downLineView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
    }];
    
    self.pwdInputBgView.layer.cornerRadius = 5;
    
    self.cancelBtn.layer.cornerRadius = 3;
    self.okBtn.layer.cornerRadius = 3;
}

/**
 *  隐藏密码输入
 */
- (void)hidePage
{
    [self.pwdBgView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(SCREEN_HEIGHT));
    }];
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        
        if (APPDataCenter.scanNav!=nil) {
            
            [self.view removeFromSuperview];
            APPDataCenter.payPasswordController = nil;
        }
        else
        {
            [self dismissViewControllerAnimated:NO completion:^{
                
            }];
        }
      
    }];
    
}
#pragma mark 按钮点击
- (IBAction)buttonClickHandle:(id)sender
{
    [self.pwdTxtField resignFirstResponder];

    UIButton *button = (UIButton*)sender;
    switch (button.tag)
    {
        case kTag_Button_Cancel:
        {
           
            [self hidePage];
        }
            break;
        case kTag_Button_Ok:
        {
            
            [self hidePage];
            if (self.okClickBlock)
            {
                self.okClickBlock(self.pwdTxtField.text);
            }
            
            
        }
            break;
            
        default:
            break;
    }
}

@end
