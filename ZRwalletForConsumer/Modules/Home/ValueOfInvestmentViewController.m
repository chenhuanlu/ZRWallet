//
//  ValueOfInvestmentViewController.m
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/7/8.
//  Copyright (c) 2015年 文彬. All rights reserved.
//
static NSInteger titleLabelTag = 1000;
static NSInteger valueLabelTag = 2000;
static NSInteger lineViewTag = 4000;

#import "ValueOfInvestmentViewController.h"
#import "AppNavView.h"
#import "UserRechargeViewController.h"
#import "MyBankCardViewController.h"
#import "MyPreferentialModel.h"
#import "UIColor+NSString.h"
#import "SecurityTool.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"

@interface ValueOfInvestmentViewController ()
@property (nonatomic, strong) AppNavView *navView;
@property (nonatomic, strong) UIScrollView *scrView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) UILabel *investmentTitleLabel;
@property (nonatomic, strong) UILabel *investmentValueLabel;

@property (nonatomic, strong) UILabel *incomLabel;

@property (nonatomic, strong) UILabel *agreeLabel;
@property (nonatomic, strong) UIButton *agreeBtn;

@property (nonatomic, strong) UILabel *cueLabel;

@property (nonatomic, strong) UIView *payView;
@property (nonatomic, strong) UILabel *payTitleLabel;
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UITextField *investField;
@property (nonatomic, strong) MyPreferentialModel *model;
@property (nonatomic, strong) NSString *investOrderId;
@property (nonatomic, strong) NSString *payPassword;

//分享窗口
@property (nonatomic, strong) UIView *shareBackView;
@property (nonatomic, strong) UIImageView *sharePopView;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UIButton *shareConfirmBtn;
@property (nonatomic, strong) UILabel *shareLabel;
@property (nonatomic, strong) UILabel *congratulateLabel;

@end

@implementation ValueOfInvestmentViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self responseData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    [self makeNavView];
    [self makeView];
}

- (void)responseData
{
    NSDictionary *dic = @{ @"projectId" : self.projectId };
    [[HttpRequest sharedRequest]sendRequestWithMessage:@"" path:@"p2c/queryInvestOrderLimit" param:dic succuss:^(id result) {
        self.model = [MyPreferentialModel new];
        [self.model setValuesForKeysWithDictionary:result];
        [self refreshView];
        
    } fail:nil];
    
}
-(void)makeNavView
{
    self.navView = [AppNavView new];
    self.navView.delegate = self;
    [self.view addSubview:self.navView];
    self.navView.titleLabel.text = @"投资金额";
    
    self.navView.leftImgView.image = [UIImage imageNamed:@"whiteBack"];
    
}
-(void)makeView
{
    self.scrView = [UIScrollView new];
    self.scrView.showsVerticalScrollIndicator = NO;
    self.scrView.backgroundColor = [UIColor colorWithString:@"#f0f0f0"];
    self.scrView.delegate = self;
    [self.view addSubview:self.scrView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.scrView addGestureRecognizer:singleTap];
    
    //first Part
    self.topView = [UIView new];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self.topView addLine];
    [self.scrView addSubview:self.topView];
    
    NSArray *titleArr = [ValueOfInvestmentViewController getTitleArr];
    for (int i = 0 ; i < titleArr.count; i++) {
        
        self.titleLabel = [UILabel new];
        self.titleLabel.tag = titleLabelTag + i;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textColor = RGBCOLOR(125, 125, 125);
        self.titleLabel.text = titleArr[i];
        [self.topView addSubview:self.titleLabel];
        
        self.valueLabel = [UILabel new];
        self.valueLabel.tag = valueLabelTag + i;
        self.valueLabel.textAlignment = NSTextAlignmentRight;
        self.valueLabel.font = [UIFont systemFontOfSize:15];
        self.valueLabel.textColor = RGBCOLOR(125, 125, 125);
        [self.topView addSubview:self.valueLabel];
        
        UILabel *tempTitleLabel = (UILabel *)[self.view viewWithTag:valueLabelTag];
        tempTitleLabel.textColor = [UIColor blackColor];
        tempTitleLabel.font = [UIFont systemFontOfSize:19];
    
        if (i != titleArr.count - 1) {
            self.lineView = [UIView new];
            self.lineView.tag = lineViewTag + i;
            self.lineView.backgroundColor = [UIColor colorWithString:@"#f0f0f0"];
            [self.topView addSubview:self.lineView];
        }
    }
    
    //second Part
    self.middleView = [UIView new];
    self.middleView.backgroundColor = [UIColor whiteColor];
    [self.middleView addLine];
    [self.scrView addSubview:self.middleView];
    
    self.investmentTitleLabel = [UILabel new];
    self.investmentTitleLabel.font = [UIFont systemFontOfSize:15];
    self.investmentTitleLabel.textColor = RGBCOLOR(125, 125, 125);
    self.investmentTitleLabel.text = @"投资金额（元）";
    [self.middleView addSubview:self.investmentTitleLabel];
    
    self.investField = [UITextField new];
    self.investField.placeholder = @"输入100的整倍数";
    self.investField.textAlignment = NSTextAlignmentRight;
    self.investField.delegate = self;
    [self.investField setValue:[UIFont systemFontOfSize:15]forKeyPath:@"_placeholderLabel.font"];
    self.investField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.investField.backgroundColor = [UIColor clearColor];
    self.investField.keyboardType = UIKeyboardTypeNumberPad;
    self.investField.returnKeyType = UIReturnKeyDefault;
    [StaticTools addTopViewInTextFeild:self.investField withMessage:@"投资金额"];
    [self.middleView addSubview:self.investField];
    
    self.incomLabel = [UILabel new];
    self.incomLabel.font = [UIFont systemFontOfSize:12];
    self.incomLabel.textColor = RGBCOLOR(125, 125, 125);
    self.incomLabel.textAlignment = NSTextAlignmentRight;
    [self.scrView addSubview:self.incomLabel];
    
    self.agreeBtn = [UIButton new];
    [self.agreeBtn addTarget:self
                      action:@selector(agreeBtnDown)
            forControlEvents:UIControlEventTouchUpInside];
    
    [self.agreeBtn setImage:[UIImage imageNamed:@"agree_no.png"] forState:UIControlStateNormal];
    [self.agreeBtn setImage:[UIImage imageNamed:@"icon_s2.png"] forState:UIControlStateSelected];
    self.agreeBtn.selected = YES;
    [self.scrView addSubview:self.agreeBtn];

    self.agreeLabel = [UILabel new];
    self.agreeLabel.text = @"同意按如下《投资合同范本》的格式和条款生成借款协议和《移动支付协议》";
    self.agreeLabel.numberOfLines = 2;
    self.agreeLabel.font = [UIFont systemFontOfSize:13];
    self.agreeLabel.textColor = RGBCOLOR(123, 123, 123);
    [self.scrView addSubview:self.agreeLabel];

    NSRange range1 = [self.agreeLabel.text rangeOfString:@"《投资合同范本》"];
    NSRange range2 = [self.agreeLabel.text rangeOfString:@"《移动支付协议》"];

    NSMutableAttributedString *attributedStr1 = [[NSMutableAttributedString alloc]
                                                 initWithString:self.agreeLabel.text];
    [attributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(24, 107, 244)
                                                                range:range1];
    [attributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(24, 107, 244)
                                                                range:range2];
    self.agreeLabel.attributedText = attributedStr1;
    
    self.cueLabel = [UILabel new];
    self.cueLabel.text = @"快捷支付服务由连连支付提供";
    self.cueLabel.textAlignment = NSTextAlignmentCenter;
    self.cueLabel.font = [UIFont systemFontOfSize:12];
    self.cueLabel.textColor = RGBCOLOR(123, 123, 123);
    [self.scrView addSubview:self.cueLabel];

    //forth View
    self.payView = [UIView new];
    self.payView.backgroundColor = [UIColor whiteColor];
    [self.payView addLine];
    [self.view addSubview:self.payView];

    self.payTitleLabel = [UILabel new];
    self.payTitleLabel.font = [UIFont systemFontOfSize:15];
    self.payTitleLabel.textColor = RGBCOLOR(125, 125, 125);
    self.payTitleLabel.text = @"本次共需支付          元";
    [self.payView addSubview:self.payTitleLabel];
    
    self.confirmBtn = [UIButton new];
    self.confirmBtn.backgroundColor = RGBCOLOR(206, 0, 33);
    self.confirmBtn.layer.masksToBounds = YES;
    self.confirmBtn.layer.cornerRadius = 4.0;
    [self.confirmBtn addTarget : self
                        action : @selector(confirmBtnDown)
              forControlEvents : UIControlEventTouchUpInside
     ];
    [self.confirmBtn setTitle:@"确 认" forState:UIControlStateNormal];
    [self.payView addSubview:self.confirmBtn];

}
-(void)refreshView
{
    self.valueLabel = (UILabel *)[self.view viewWithTag:valueLabelTag];
    self.valueLabel.text = [NSString stringWithFormat:@"%d",[self.model.projectRemain intValue]];
    
    self.valueLabel = (UILabel *)[self.view viewWithTag:valueLabelTag + 1];
    self.valueLabel.text = [NSString stringWithFormat:@"%d",[self.model.cashRemain intValue]];

}
-(void)singleTap:(UITapGestureRecognizer *)tap
{
    [self.scrView endEditing:YES];
}
-(void)confirmBtnDown
{
    NSInteger value = [self.investField.text integerValue];
    
    if ([self.model.cashRemain integerValue] < value) {
        if ([[UserDefaults objectForKey:USER_BANKCARD] isEqualToString:@""]) {
            
            [UIAlertView showAlertView:@"您还没有绑定银行卡，请绑定银行卡" delegate:self];

        }else
        {
            [UIAlertView showAlertView:@"您余额不足，请及时充值" delegate:self];

        }
        return;
    }
    if ( value % 100 != 0) {
        [UIAlertView showAlertView:@"请输入100的整数倍"];
        
        return;
    }if (self.investField.text.length == 0 ||self.agreeBtn.selected == NO) {
        [UIAlertView showAlertView:@"请完善投资内容"];
        return;
    }

    [StaticTools showPayPasswordWithMoney:self.investField.text ClickOk:^(id password) {
        self.payPassword = [SecurityTool md5:password];
        [self insertRequest1];

    }];
    return;
  
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([[UserDefaults objectForKey:USER_BANKCARD] isEqualToString:@""]) {

        if (buttonIndex == 1) {
            MyBankCardViewController  *bankVC = [MyBankCardViewController new];
            bankVC.isHaveStr = @"0";
            [self.navigationController pushViewController:bankVC animated:YES];
            
        }
        
    }else
    {
        if (buttonIndex == 1) {
            UserRechargeViewController *rechargeVC = [UserRechargeViewController new];
            rechargeVC.isHiddenNav = YES;
            [self.navigationController pushViewController:rechargeVC animated:YES];
            
        }
        
    }
}
-(void)insertRequest1
{
    NSDictionary *dic = @{ @"amount"      : self.investField.text,
                           @"projectId"   : self.projectId
                                           };
    
    [[HttpRequest sharedRequest]sendRequestWithMessage:nil path:@"invest/createInvestOrder" param: dic succuss:^(id result) {
        
        self.investOrderId = result[@"investOrderId"];
        [self insertRequest2];
        
    } fail:nil];
}
-(void)insertRequest2
{
    NSDictionary *dic = @{ @"payPassword" : self.payPassword,
                           @"orderId"     : self.investOrderId
                         };
    
    [[HttpRequest sharedRequest]sendRequestWithMessage:@"正在加载" path:@"/invest/invest" param: dic succuss:^(id result) {
        
        [self makeSharePopView];
        
    } fail:nil];
}
-(void)makeSharePopView
{
    self.shareBackView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.shareBackView];
    self.shareBackView.alpha = 1;
    [self.shareBackView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
    
    self.sharePopView = [UIImageView new];
    
    self.sharePopView.size = CGSizeMake(SCREEN_WIDTH - 20, 160);
    self.sharePopView.viewTop = SCREEN_HEIGHT;
    self.sharePopView.viewLeft = 10;

    self.sharePopView.image = [UIImage imageNamed:@"ip_yhtzcg_suc"];
    self.sharePopView.layer.cornerRadius = 7.0;
    self.sharePopView.layer.masksToBounds = YES;
    self.sharePopView.userInteractionEnabled = YES;
    [self.shareBackView addSubview:self.sharePopView];

    self.cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancleBtn setImage:[UIImage imageNamed:@"ip_yhtzcg_sh"] forState:UIControlStateNormal];
    self.cancleBtn.userInteractionEnabled = YES;
    [self.cancleBtn addTarget:self action:@selector(popViewAlphaChange) forControlEvents:UIControlEventTouchUpInside];
    [self.sharePopView addSubview: self.cancleBtn];

    self.shareConfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareConfirmBtn.backgroundColor = RGBCOLOR(206, 0, 31);
    self.shareConfirmBtn.userInteractionEnabled = YES;
    [self.shareConfirmBtn setTitle:@"马上分享" forState:UIControlStateNormal];
    [self.shareConfirmBtn addTarget:self action:@selector(shareBtnDown) forControlEvents:UIControlEventTouchUpInside];
    self.shareConfirmBtn.layer.cornerRadius = 3.0;
    self.shareConfirmBtn.layer.masksToBounds = YES;
    self.shareConfirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.shareConfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sharePopView addSubview:self.shareConfirmBtn];
    
    self.congratulateLabel = [UILabel new];
    self.congratulateLabel.text = @"恭喜您，投资成功！";
    self.congratulateLabel.font = [UIFont systemFontOfSize:15];
    self.congratulateLabel.textAlignment = NSTextAlignmentCenter;
    self.congratulateLabel.textColor =  RGBCOLOR(206, 0, 31);
    [self.sharePopView addSubview:self.congratulateLabel];
    
    self.shareLabel = [UILabel new];
    self.shareLabel.text = @"分享给朋友，一起赚收益!";
    self.shareLabel.font = [UIFont boldSystemFontOfSize:16];
    self.shareLabel.textAlignment = NSTextAlignmentCenter;
    self.shareLabel.textColor =  [UIColor whiteColor];
    [self.sharePopView addSubview:self.shareLabel];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.sharePopView.size = CGSizeMake(SCREEN_WIDTH - 20, 160);
        self.sharePopView.viewCenterY = SCREEN_HEIGHT/2;
        self.sharePopView.viewLeft = 10;
        
    } completion:^(BOOL finished) {
        
    }];

}
-(void)shareBtnDown
{
    [UIView animateWithDuration:0.5 animations:^{
        
        self.shareBackView.alpha = self.shareBackView.alpha == 0?1:0;
        
        self.sharePopView.size = CGSizeMake(SCREEN_WIDTH - 20, 160);
        self.sharePopView.viewBottom = 0;
        self.sharePopView.viewLeft = 10;
        
    } completion:^(BOOL finished) {
        
        [self WXShare];
        
    }];

}
-(void)WXShare
{
    NSString *allText = @"更多赚钱机会！尽在中融钱宝";
    
    NSString *tmpPath = NSTemporaryDirectory();
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd-HH:mm:ss"];
    NSDate *now = [NSDate date];
    NSString *dateNow = [dateFormatter stringFromDate:now];
    NSString *FileName=[[tmpPath stringByAppendingPathComponent:@"ShareImage"] stringByAppendingString:dateNow];
    
    UIImage *img = [UIImage imageNamed:@"icon108"];
    NSData *imgData = UIImageJPEGRepresentation(img, 1.0);
    [imgData writeToFile:FileName atomically:YES];
    
    id<ISSContent> publishContent = [ShareSDK content : allText
                                       defaultContent : @"http://www.zrqianbao.com"
                                                image : [ShareSDK imageWithPath:FileName]
                                                title : @"中融钱宝"
                                                  url : @"http://www.zrqianbao.com"
                                          description : @"我分享的内容是：~~~~~~~~~~~~~~~~"
                                            mediaType : SSPublishContentMediaTypeNews];
    
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,nil];
    
    [ShareSDK showShareActionSheet : nil
                         shareList : shareList
                           content : publishContent
                     statusBarTips : YES
                       authOptions : nil
                      shareOptions : nil
                            result : ^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败");
                                }
                                else if (state == SSResponseStateCancel)
                                {
                                    [self makeSharePopView];
                                }
                            }];
  
}

-(void)popViewAlphaChange
{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.shareBackView.alpha = self.shareBackView.alpha==0?1:0;
        
    } completion:^(BOOL finished) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
  
}

+(NSArray *)getTitleArr
{
    return @[ @"该项目可投资金额（元）",
              @"可用余额（元）"
            ];
    
}
-(void)agreeBtnDown
{
    self.agreeBtn.selected = self.agreeBtn.selected ? NO : YES;
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    self.navView.size = CGSizeMake(SCREEN_WIDTH, Dev_NavigationBar_Height);
    
    self.scrView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - Dev_NavigationBar_Height);
    self.scrView.viewTop = Dev_NavigationBar_Height;

    self.topView.size = CGSizeMake(SCREEN_WIDTH, kCellHeight * 2);
    self.topView.viewTop = 10;
    
    for (int i = 0; i < 3 ; i++) {
        UILabel *tempLabel = (UILabel *)[self.view viewWithTag:titleLabelTag + i];
        tempLabel.size = CGSizeMake(SCREEN_WIDTH/1.9, self.topView.size.height/2);
        tempLabel.viewTop = i*tempLabel.size.height;
        tempLabel.viewLeft = 20;
        
        UILabel *tempValueLabel = (UILabel *)[self.view viewWithTag:valueLabelTag + i];
        tempValueLabel.size = CGSizeMake(SCREEN_WIDTH/2, tempLabel.size.height);
        tempValueLabel.viewTop = i*tempValueLabel.size.height;
        tempValueLabel.viewRight = self.view.viewRight - 20;
        
        UIView *tempLineViw = (UIView *)[self.view viewWithTag:lineViewTag + i];
        tempLineViw.size = CGSizeMake(SCREEN_WIDTH - 10, 1);
        tempLineViw.viewTop = tempLabel.viewBottom;
        tempLineViw.viewLeft = 5;
    }
    
    self.middleView.size = CGSizeMake(SCREEN_WIDTH, kCellHeight);
    self.middleView.viewTop = self.topView.viewBottom + 20;
    
    self.investmentTitleLabel.size = CGSizeMake(SCREEN_WIDTH/1.9, self.middleView.size.height);
    self.investmentTitleLabel.viewLeft = 20;
    
    self.investField.size = CGSizeMake(SCREEN_WIDTH/2, self.middleView.size.height);
    self.investField.viewRight = self.middleView.viewRight - 20;
    
    self.incomLabel.size = CGSizeMake(SCREEN_WIDTH/2, 20);
    self.incomLabel.viewRight = self.view.viewRight - 10;
    self.incomLabel.viewTop = self.middleView.viewBottom + 10;
    
    self.agreeBtn.size = CGSizeMake(18, 18);
    self.agreeBtn.viewLeft = 20;
    self.agreeBtn.viewTop = self.incomLabel.viewBottom + 30;
    
    self.agreeLabel.size = CGSizeMake(SCREEN_WIDTH - 65, 40);
    self.agreeLabel.viewLeft = self.agreeBtn.viewRight + 10;
    self.agreeLabel.viewTop = self.agreeBtn.viewTop - 3;

    self.payView.size = CGSizeMake(SCREEN_WIDTH, 70);
    self.payView.viewBottom = SCREEN_HEIGHT - 10;
    
    self.payTitleLabel.size = CGSizeMake(SCREEN_WIDTH/1.5, self.payView.size.height);
    self.payTitleLabel.viewLeft = 20;
    
    self.confirmBtn.size = CGSizeMake(80, 30);
    self.confirmBtn.viewRight = self.payView.viewRight - 20;
    self.confirmBtn.viewCenterY = self.payView.size.height/2;
    
    self.cueLabel.size = CGSizeMake(SCREEN_WIDTH, 20);
    self.cueLabel.viewTop = self.agreeLabel.viewBottom + 10;
    
    self.cancleBtn.size = CGSizeMake(20 , 20);
    self.cancleBtn.viewTop = 10;
    self.cancleBtn.viewRight = self.sharePopView.viewRight - 20;
    
    self.congratulateLabel.size = CGSizeMake(SCREEN_WIDTH, 20);
    self.congratulateLabel.viewTop = 20;
    
    self.shareLabel.size = self.congratulateLabel.size;
    self.shareLabel.viewTop = self.congratulateLabel.viewBottom + 2;
    
    self.shareConfirmBtn.frame = CGRectMake(self.sharePopView.size.width/4, self.sharePopView.size.height*3/4, self.sharePopView.size.width/1.7, 30);
    
    self.scrView.contentSize = CGSizeMake(SCREEN_WIDTH, self.payView.viewBottom + 20);

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark textfield 的delegate实现
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.payTitleLabel.text = [NSString stringWithFormat:@"本次共需支付%@元",self.investField.text];
    
    float incomNum = [self.investField.text floatValue]*self.yearRoa/100/365*self.day;
    self.incomLabel.text = [NSString stringWithFormat:@"到期收益%.2f元",incomNum];
    NSRange range0 = [self.incomLabel.text rangeOfString:[NSString stringWithFormat:@"%.2f",incomNum]];
    
    NSMutableAttributedString *attributedStr0 = [[NSMutableAttributedString alloc]
                                                 initWithString:self.incomLabel.text];
    
    [attributedStr0 addAttribute:NSForegroundColorAttributeName
                           value:RGBCOLOR(206, 0, 31)
                           range:range0];
    [attributedStr0 addAttribute:NSFontAttributeName
                           value:[UIFont systemFontOfSize:17]
                           range:range0];
    self.incomLabel.attributedText = attributedStr0;

    return YES;
}
#pragma mark - navBtnClick
-(void)navLeftBtnDown
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
