//
//  MyBankCardViewController.m
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/6/30.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "MyBankCardViewController.h"
#import "UIColor+NSString.h"
#import "AppNavView.h"
#import "BankCardUploadViewController.h"

#define COLOR_BORDER [UIColor colorWithString:@"#f0f0f0"].CGColor

@interface MyBankCardViewController ()
@property (nonatomic, strong) AppNavView *navView;
@property (nonatomic, strong) UIScrollView *scrView;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UILabel *userType;
@property (nonatomic, strong) UILabel *userNum;
@property (nonatomic, strong) UILabel *topCueLabel;
@property (nonatomic, strong) UILabel *bottomCueLabel;
@property (nonatomic, strong) UIView *addBankCardView;
@property (nonatomic, strong) UILabel *addBankLabel;
@property (nonatomic, strong) UIImageView *goPageImgView;
@property (nonatomic, strong) UIImageView *phoneImgView;


@end

@implementation MyBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithString:@"#f0f0f0"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    
    self.scrView = [UIScrollView new];
    self.scrView.delegate = self;
    self.scrView.userInteractionEnabled = YES;
    [self.view addSubview:self.scrView];
    
    [self makeNavView];

    
    if ([self.isHaveStr isEqualToString:@"0"]) {
        [self makeAddBankCardView];
    }else{
        [self makeView];
    }
}
-(void)makeNavView
{
    self.navView = [AppNavView new];
    self.navView.delegate = self;
    [self.view addSubview:self.navView];
    
    self.navView.titleLabel.text = @"我的银行卡";
    self.navView.leftImgView.image = [UIImage imageNamed:@"whiteBack"];
//    [self.navView.navLeftBtn addTarget : self
//                                action : @selector(navLeftBtnDown)
//                      forControlEvents : UIControlEventTouchUpInside
//     ];
    
}
-(void)makeView
{
    self.topCueLabel = [UILabel new];
    self.topCueLabel.text = @"提现操作将把账户余额转入该银行卡内";
    self.topCueLabel.textColor = RGBCOLOR(121, 121, 121);
    self.topCueLabel.font = [UIFont systemFontOfSize:12];
    self.topCueLabel.textAlignment = NSTextAlignmentLeft;
    [self.scrView addSubview:self.topCueLabel];
    
    self.topView = [UIView new];
    self.topView.backgroundColor = [UIColor whiteColor];
    self.topView.layer.borderColor = COLOR_BORDER;
    self.topView.layer.borderWidth = 1;
    [self.topView addLine];
    [self.scrView addSubview:self.topView];
    
    self.bottomCueLabel = [UILabel new];
    self.bottomCueLabel.numberOfLines = 2;
    self.bottomCueLabel.userInteractionEnabled = YES;
    self.bottomCueLabel.textColor =  RGBCOLOR(58, 58, 58);
    self.bottomCueLabel.font = [UIFont systemFontOfSize:13];
    self.bottomCueLabel.textAlignment = NSTextAlignmentLeft;
    [self.scrView addSubview:self.bottomCueLabel];
    
    NSString *cueStr = @"为了您的资金安全，不建议更换快捷卡。如遇特殊情况请致电客服：400-030-1515";
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:cueStr];
    NSRange range = [cueStr rangeOfString:@"400-030-1515"];
    [contentStr addAttribute : NSForegroundColorAttributeName
                       value : RGBCOLOR(206, 0, 33)
                       range : range];
    self.bottomCueLabel.attributedText = contentStr;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneBtnDown)];
    [self.bottomCueLabel addGestureRecognizer:singleTap];
    
    self.phoneImgView = [UIImageView new];
    self.phoneImgView.image = [UIImage imageNamed:@"ip_wdyhk_te"];
    [self.scrView addSubview:self.phoneImgView];
    
    UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneBtnDown)];
    [self.phoneImgView addGestureRecognizer:imgTap];

    self.photoView = [UIImageView new];
    self.photoView.image = [UIImage imageNamed:@"ip_wdyhk_bank-1"];
    self.photoView.layer.masksToBounds = YES;
    self.photoView.layer.cornerRadius = 4.0;
    [self.topView addSubview:self.photoView];
    
    self.userType = [UILabel new];
    self.userType.text = @"招商银行";
    [self.topView addSubview:self.userType];
    
    self.userNum = [UILabel new];
    self.userNum.text = self.bankCardNum;
    //@"622202 **** 1553";
    self.userNum.textColor = RGBCOLOR(121, 121, 121);
    [self.topView addSubview:self.userNum];
    
}

-(void)makeAddBankCardView
{
    self.topCueLabel = [UILabel new];
    self.topCueLabel.text = @"为了您的收款及时到账，请绑定一张银行卡，用作提取通道。";
    self.topCueLabel.textColor = RGBCOLOR(121, 121, 121);
    self.topCueLabel.numberOfLines = 2;
    self.topCueLabel.font = [UIFont systemFontOfSize:12];
    self.topCueLabel.textAlignment = NSTextAlignmentLeft;
    [self.scrView addSubview:self.topCueLabel];
    
    self.addBankCardView = [UIButton new];
    self.addBankCardView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *addBankCardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addBankCardViewTap)];
    [self.addBankCardView addGestureRecognizer:addBankCardTap];
    
    [self.addBankCardView addLine];
    [self.scrView addSubview:self.addBankCardView];
    
    self.addBankLabel = [UILabel new];
    self.addBankLabel.text = @"绑定银行卡";
    self.addBankLabel.font = [UIFont systemFontOfSize:16];
    self.addBankLabel.textAlignment = NSTextAlignmentLeft;
    self.addBankLabel.textColor = [UIColor colorWithString:@"#434343"];
    [self.addBankCardView addSubview:self.addBankLabel];
    
    self.goPageImgView = [UIImageView new];
    self.goPageImgView.image = [UIImage imageNamed:@"my_goPage.png"];
    [self.addBankCardView addSubview:self.goPageImgView];

}
-(void)addBankCardViewTap
{
    BankCardUploadViewController *bankCardUploadController = [[BankCardUploadViewController alloc]init];
    [self.navigationController pushViewController:bankCardUploadController animated:YES];
}
-(void)phoneBtnDown
{
    
    NSURL *phoneURL = [NSURL URLWithString:@"tel:400-030-1515"];
    UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:phoneCallWebView];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.navView.size = CGSizeMake(SCREEN_WIDTH, Dev_NavigationBar_Height);

    self.scrView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - Dev_NavigationBar_Height);
    self.scrView.viewTop = Dev_NavigationBar_Height;
    self.scrView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT );
    
    self.topCueLabel.size = CGSizeMake(SCREEN_WIDTH - 40, 30);
    self.topCueLabel.viewLeft = 20;
    self.topCueLabel.viewTop = 15;
    
    self.topView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/4);
    self.topView.viewTop = self.topCueLabel.viewBottom + 5;
    
    self.bottomCueLabel.size = CGSizeMake(SCREEN_WIDTH - 40, 40);
    self.bottomCueLabel.viewLeft = 20;
    self.bottomCueLabel.viewTop = self.topView.viewBottom + 10;
    
    self.phoneImgView.size = CGSizeMake(17, 17);
    self.phoneImgView.viewRight = SCREEN_WIDTH - 65;
    self.phoneImgView.viewBottom = self.bottomCueLabel.viewBottom - 2;
    
    self.photoView.size = CGSizeMake(self.topView.size.height/2,self.topView.size.height/2.5 );
    self.photoView.viewCenterY = self.topView.size.height/2;
    self.photoView.viewLeft = 20;
    
    self.userType.size = CGSizeMake(SCREEN_WIDTH/4, 20);
    self.userType.viewLeft = self.photoView.viewRight + 20;
    self.userType.viewTop = self.topView.size.height/4;
    
    self.userNum.size = CGSizeMake(SCREEN_WIDTH/2, 20);
    self.userNum.viewLeft = self.userType.viewLeft;
    self.userNum.viewBottom = 3*self.topView.size.height/4 + 5;
    
    self.addBankCardView.size = CGSizeMake(SCREEN_WIDTH, kCellHeight);
    self.addBankCardView.viewTop = self.topCueLabel.viewBottom + 10;
    
    self.addBankLabel.size = CGSizeMake(SCREEN_WIDTH/2, self.addBankCardView.size.height);
    self.addBankLabel.viewLeft = 20;
    
    self.goPageImgView.size = CGSizeMake(22, 22);
    self.goPageImgView.viewRight = self.addBankCardView.viewRight - 10;
    self.goPageImgView.viewCenterY = self.addBankCardView.size.height/2;
    
}
#pragma mark - navBtnClick
-(void)navLeftBtnDown
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
