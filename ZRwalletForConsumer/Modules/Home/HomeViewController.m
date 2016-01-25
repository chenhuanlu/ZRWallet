//
//  HomeViewController.m
//  ZRwalletForMerchant
//
//  Created by 文彬 on 15/6/29.
//  Copyright (c) 2015年 文彬. All rights reserved.
//
static CGFloat circleProgressWidth;
static CGFloat devWidth = 320;
static int percent;
#import "HomeViewController.h"
#import "UIColor+NSString.h"
#import "AppNavView.h"
#import "ProjectDetailViewController.h"
#import "ValueOfInvestmentViewController.h"
#import "MyPreferentialModel.h"
#import "CarouselsPageViewModel.h"
#import "MJRefresh.h"
#import "NewsViewController.h"

@interface HomeViewController ()
{
    BOOL isFresh; //是否为下拉刷新
}
@property (nonatomic, strong) AppNavView *navView;
@property (nonatomic, strong) UIScrollView *scrView;
//轮播图
@property (nonatomic, strong) CarouselsView *carouselsView;
@property (nonatomic, strong) NSMutableArray *carouselsPicArr;
@property (nonatomic, strong) NSMutableArray *picArr;

@property (nonatomic, strong) UIButton *investBtn;
@property (nonatomic, strong) UILabel *markLabel;
@property (nonatomic, strong) UILabel *companyNameLabel;
@property (nonatomic, strong) UILabel *incomLabel;
@property (nonatomic, strong) UILabel *rateLael;
@property (nonatomic, strong) UILabel *infoLimitLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *infoLimitTitle;
@property (nonatomic, strong) UILabel *infoLabelTitle;
@property (nonatomic, strong) MyPreferentialModel *model;
@property (nonatomic, strong) NSDictionary *result;
@property (nonatomic, strong) UIImageView *isOverDateImg;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [self makeNavView];
    [self makeView];
    
    [self.scrView addHeaderWithTarget:self action:@selector(headerRefeshing)];
 
    //登陆状态下
    if ([[UserDefaults objectForKey:kIsLogin] isEqualToString:@"1"])
    {
        if ([UserDefaults objectForKey:kLockPwd]!=nil)
        {
            [StaticTools showLockViewWithType:LLLockViewTypeCheck];
        }
        [self getUserDataRequest];
       
    }
    
    //首页轮播图数据请求
    [self getCarouselsPageDate];

}
-(void)viewWillAppear:(BOOL)animated
{
    //首页数据请求
    [self baseInfoSend];
    
    //登陆状态下
    if ([[UserDefaults objectForKey:kIsLogin] isEqualToString:@"1"])
    {
        //程序从后台进入前台时 请求是否有未读消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessageRequest) name:kBecomeActivie object:nil];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //TODO 关闭navigationcontroller根视图的右滑返回 在根视图右滑  出现卡死现象
    if (self.navigationController.viewControllers.count == 1)
    {
        return NO;
    }
    
    return YES;
}

- (void)baseInfoSend
{
    [[HttpRequest sharedRequest]sendRequestWithMessage:@"" path:@"p2c/mainProject" param:nil succuss:^(id result) {
        self.result = result;
        if (isFresh)
        {
            isFresh = NO;
            [self.scrView headerEndRefreshing];
        }
        self.model = [MyPreferentialModel new];
        [self.model setValuesForKeysWithDictionary:result];
        [self refreshView];
        
        UITapGestureRecognizer *companyDetailTap = [[UITapGestureRecognizer alloc] initWithTarget : self
                                                                                           action : @selector(projectDetailTap:)];
        [self.firstGoalBar addGestureRecognizer:companyDetailTap];
        self.investBtn.userInteractionEnabled = YES;
        
    } fail:^{
        [self.scrView headerEndRefreshing];

    }];
    
}
//获取轮播图的数据
-(void)getCarouselsPageDate
{
    if (self.carouselsPicArr == nil) {
        self.carouselsPicArr = [NSMutableArray new];
    }

    [[HttpRequest sharedRequest]sendRequestWithMessage:@"" path:@"p2c/getCarouselImage" param:nil succuss:^(id result) {
        
        [self.carouselsPicArr removeAllObjects];
        
        NSArray *appArr = result;
        if (![(NSNull*)appArr isEqual:[NSNull null]]) {
            for (NSDictionary *dic in appArr) {
                CarouselsPageViewModel *model = [CarouselsPageViewModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.carouselsPicArr addObject:model];
            }
        }
        
        self.picArr = [NSMutableArray new];
        [self.picArr removeAllObjects];
        for (int i = 0 ; i < self.carouselsPicArr.count; i++) {
            CarouselsPageViewModel *carouselsModel = [self.carouselsPicArr objectAtIndex:i];
            [self.picArr addObject:carouselsModel.imageUrl];
        }

        [UserDefaults setObject:self.picArr forKey:HOME_CAROUSELS];
        [UserDefaults synchronize];
        
        if (self.carouselsPicArr.count > 0) {
            
            [self.carouselsView initPage];
            
        }else
        {
            [self performSelector:@selector(reloadCarouselsView)
                       withObject:self
                       afterDelay:0.3f];
        }
        
        
    } fail:^{
        
    }];
    
//    if (self.carouselsPicArr.count > 0) {
//        
//        [self.carouselsView initPage];
//
//    }else
//    {
//        [self performSelector:@selector(reloadCarouselsView)
//                   withObject:self
//                   afterDelay:0.3f];
//    }
    
    
}

-(void)makeNavView
{
    self.navView = [AppNavView new];
    self.navView.delegate = self;
    [self.view addSubview:self.navView];
    
    self.navView.titleLabel.text = @"中融钱宝";
    
    self.navView.rightImgView.image = [UIImage imageNamed:@"icon_notice_n.png"];
    
}
-(void)getMessageRequest
{
    //未登陆状态不发送请求
    if ([[UserDefaults objectForKey:kIsLogin] isEqualToString:@"0"])
    {
        return;
    }
    
    //导航栏消息请求
    [[HttpRequest sharedRequest]sendRequestWithMessage:@"" path:@"msg/hasUnRead" param:nil succuss:^(id result) {
        //有新消息
        if ([result[@"hasUnRead"] isEqualToString:@"true"]) {
            CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            shake.delegate = self;
            //设置抖动幅度
            shake.fromValue = [NSNumber numberWithFloat:-0.2];
            shake.toValue = [NSNumber numberWithFloat:+0.2];
            shake.duration = 0.15;
            shake.autoreverses = YES;
            shake.repeatCount = MAXFLOAT;
            [self.navView.navRightBtn.layer addAnimation:shake forKey:@"newMessageNotice"];
            
        }
    } fail:nil];

}
-(void)makeView
{
    self.scrView = [UIScrollView new];
    self.scrView.delegate = self;
    self.scrView.backgroundColor = [UIColor whiteColor];
    self.scrView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrView];
    
    //轮播图
    self.carouselsView = [CarouselsView new];
    self.carouselsView.delegate = self;
//    self.carouselsView.backgroundColor = RGBCOLOR(251, 9, 68);
    self.carouselsView.backgroundColor = [UIColor whiteColor];
    [self.scrView addSubview:self.carouselsView];
    
    self.companyNameLabel = [UILabel new];
    self.companyNameLabel.userInteractionEnabled = YES;
    
    self.companyNameLabel.backgroundColor = [UIColor colorWithString:@"#f0f0f0"];
    self.companyNameLabel.numberOfLines = 2;
    self.companyNameLabel.textColor = [UIColor colorWithString:@"#434343"];
    self.companyNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.scrView addSubview:self.companyNameLabel];
    
    self.investBtn = [UIButton new];
    self.investBtn.backgroundColor = RGBCOLOR(206, 0, 33);
    self.investBtn.layer.masksToBounds = YES;
    self.investBtn.layer.cornerRadius = 4.0;
    [self.investBtn addTarget : self
                       action : @selector(investBtnDown:)
             forControlEvents : UIControlEventTouchUpInside
                             ];
    self.investBtn.userInteractionEnabled = NO;
    [self.investBtn setTitle:@"立即投资" forState:UIControlStateNormal];
    [self.scrView addSubview:self.investBtn];
    
    self.markLabel = [UILabel new];
    self.markLabel.textColor = RGBCOLOR(149, 149, 149);
    self.markLabel.textAlignment = NSTextAlignmentCenter;
    self.markLabel.text = @"保障机构 ：中融保理";
    [self.scrView addSubview:self.markLabel];

    circleProgressWidth = SCREEN_WIDTH - 100;
    //进度条
    self.firstGoalBar = [[KDGoalBar alloc]initWithFrame:
                         CGRectMake((SCREEN_WIDTH - circleProgressWidth)/2,
                                                      SCREEN_WIDTH/2.5 + 35,
                                                       circleProgressWidth,
                                                     circleProgressWidth)];
    [self.scrView addSubview:self.firstGoalBar];
    
    [self.firstGoalBar setAllowDragging:NO];
    [self.firstGoalBar setAllowSwitching:NO];
    [self.firstGoalBar setShowLittleCicle:YES];
    
    self.isOverDateImg = [UIImageView new];
    [self.firstGoalBar addSubview:self.isOverDateImg];
    
    self.incomLabel = [UILabel new];
    self.incomLabel.text = @"年化收益率 %";
    self.incomLabel.textAlignment = NSTextAlignmentCenter;
    self.incomLabel.textColor = [UIColor colorWithString:@"#434343"];
    [self.firstGoalBar addSubview:self.incomLabel];
    
    self.rateLael = [UILabel new];
    self.rateLael.textAlignment = NSTextAlignmentCenter;
    self.rateLael.textColor = RGBCOLOR(206, 0, 33);
    [self.firstGoalBar addSubview:self.rateLael];
    
    self.infoLimitLabel = [UILabel new];
    self.infoLimitLabel.textAlignment = NSTextAlignmentLeft;
    self.infoLimitLabel.textColor =  RGBCOLOR(149, 149, 149);
    [self.firstGoalBar addSubview:self.infoLimitLabel];
    
    self.infoLimitTitle = [UILabel new];
    self.infoLimitTitle.text = @"项目期限";
    self.infoLimitTitle.textAlignment = NSTextAlignmentLeft;
    self.infoLimitTitle.textColor =  RGBCOLOR(149, 149, 149);
    [self.firstGoalBar addSubview:self.infoLimitTitle];
    
     self.infoLabel = [UILabel new];
    self.infoLabel.textAlignment = NSTextAlignmentLeft;
    self.infoLabel.textColor =  RGBCOLOR(149, 149, 149);
    [self.firstGoalBar addSubview:self.infoLabel];
    
    self.infoLabelTitle = [UILabel new];
    self.infoLabelTitle.text = @"项目规模";
    self.infoLabelTitle.textAlignment = NSTextAlignmentLeft;
    self.infoLabelTitle.textColor =  RGBCOLOR(149, 149, 149);
    [self.firstGoalBar addSubview:self.infoLabelTitle];

    if(SCREEN_WIDTH == devWidth)
    {
        self.companyNameLabel.font = [UIFont boldSystemFontOfSize:15];

        self.incomLabel.font = [UIFont systemFontOfSize:17];

        self.rateLael.font = [UIFont systemFontOfSize:50];
        
        self.infoLimitLabel.font = [UIFont systemFontOfSize:12];
        self.infoLimitTitle.font = [UIFont systemFontOfSize:12];
        self.infoLabel.font = [UIFont systemFontOfSize:12];
        self.infoLabelTitle.font = [UIFont systemFontOfSize:12];

        self.investBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];

        self.markLabel.font = [UIFont systemFontOfSize:12];

    }else{
        self.companyNameLabel.font = [UIFont boldSystemFontOfSize:20];
        self.incomLabel.font = [UIFont systemFontOfSize:23];

        self.rateLael.font = [UIFont systemFontOfSize:65];
        self.infoLimitLabel.font = [UIFont systemFontOfSize:16];
        self.infoLimitTitle.font = [UIFont systemFontOfSize:16];

        self.infoLabel.font = [UIFont systemFontOfSize:16];
        self.infoLabelTitle.font = [UIFont systemFontOfSize:16];

        self.investBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22];

        self.markLabel.font = [UIFont systemFontOfSize:14];
    }
}
-(void)reloadCarouselsView
{
    [self.carouselsView initPage];
    
}
-(void)refreshView
{
    float amount = [self.model.amonut floatValue];
    float raisingVolume = [self.model.raisingVolume floatValue];
    percent = amount/raisingVolume *100;
    
    [self.firstGoalBar setPercent:percent animated:NO];

    self.companyNameLabel.text = self.model.projectName;
    self.rateLael.text = self.model.yearRoa;

    UIFont *infoFont;
    if(SCREEN_WIDTH == devWidth)
    {
        infoFont = [UIFont systemFontOfSize:16];

    }else
    {
        infoFont = [UIFont systemFontOfSize:22];
    }
    NSString *infoLimitStr = [NSString stringWithFormat:@"%@天",self.model.projectExpires];

    //改变label字体和颜色
    NSRange range1 = [infoLimitStr rangeOfString:self.model.projectExpires];
    NSMutableAttributedString *attributedStr1 = [[NSMutableAttributedString alloc] initWithString:infoLimitStr];
    
    [attributedStr1 addAttribute : NSForegroundColorAttributeName
                           value : RGBCOLOR(206, 0, 33)
                           range : range1
                                ];
    
    [attributedStr1 addAttribute : NSFontAttributeName
                           value : infoFont
                           range : range1
                                ];
    
    self.infoLimitLabel.attributedText = attributedStr1;
    
    NSString *infoStr = [NSString stringWithFormat:@"%.d万",[self.model.raisingVolume intValue]];
    //改变label字体和颜色
    NSRange range2 = [infoStr rangeOfString:[NSString stringWithFormat:@"%.d",[self.model.raisingVolume intValue]]];
    NSMutableAttributedString *attributedStr2 = [[NSMutableAttributedString alloc] initWithString:infoStr];
    
    [attributedStr2 addAttribute : NSForegroundColorAttributeName
                           value : RGBCOLOR(206, 0, 33)
                           range : range2
                                ];
    
    [attributedStr2 addAttribute : NSFontAttributeName
                           value : infoFont
                           range : range2
                                ];
    
    self.infoLabel.attributedText = attributedStr2;
    //项目过期
    if ([self.model.projectStatus isEqualToString:@"3"]) {
        
        self.isOverDateImg.image = [UIImage imageNamed:@"ip_yhzy_du"];
    }
    else
    {
        self.isOverDateImg.image = nil;
    }

}
-(void)investBtnDown:(UIButton *)btn
{
    //未登录
    if ([[UserDefaults objectForKey:kIsLogin] isEqualToString:@"0"])
    {
        [StaticTools showLoginControllerWithSuccess:^{
            
            if ([self.model.projectStatus isEqualToString:@"3"]) {
                
                [UIAlertView showAlertView:@"项目已过期"];
                return;
            }
            if(percent  == 100)
            {
                [UIAlertView showAlertView:@"项目已投满"];
                return;
                
            }
            else
            {
                [self pushInvestPageView];
                return;
                
            }
            
        } fail:nil];
        
        return;

    }
    if ([self.model.projectStatus isEqualToString:@"3"]) {
        
        [UIAlertView showAlertView:@"项目已过期"];
        return;
    }
    if(percent  == 100)
    {
        [UIAlertView showAlertView:@"项目已投满"];
        return;
        
    }
    else
    {
        [self pushInvestPageView];
        return;

    }
}
-(void)pushInvestPageView
{
    ValueOfInvestmentViewController *valueVC = [ValueOfInvestmentViewController new];
    valueVC.hidesBottomBarWhenPushed = YES;
    valueVC.projectId = self.model.projectId;
    valueVC.yearRoa = [self.model.yearRoa floatValue];
    valueVC.day = [self.model.remainDays integerValue];
    [self.navigationController pushViewController:valueVC animated:YES];
}
-(void)projectDetailTap:(UITapGestureRecognizer *)tap
{
    ProjectDetailViewController *projectVC = [ProjectDetailViewController new];
    projectVC.projectName = self.model.projectName;
    projectVC.paybackTime = self.model.paybackTime;
    projectVC.paybackType = self.model.paybackType;
    projectVC.raisingVolume = self.model.raisingVolume;
    projectVC.yearRoa = self.model.yearRoa;
    projectVC.amonut = self.model.amonut;
    projectVC.projectId = self.model.projectId;
    projectVC.day = [self.model.remainDays integerValue];
    projectVC.projectStatus = self.model.projectStatus;
    projectVC.projectDesp = self.result[@"projectDesp"];
    projectVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:projectVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.navView.size = CGSizeMake(SCREEN_WIDTH, Dev_NavigationBar_Height);
    
    self.scrView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - Dev_NavigationBar_Height);
    self.scrView.viewTop = Dev_NavigationBar_Height;

    self.carouselsView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/2.5);
    
    self.companyNameLabel.size = CGSizeMake(SCREEN_WIDTH, 40);
    self.companyNameLabel.viewTop = self.carouselsView.viewBottom;
    
    self.incomLabel.size = CGSizeMake(circleProgressWidth, 20);
    self.incomLabel.viewTop = circleProgressWidth/5;
    
    self.isOverDateImg.frame = CGRectMake((circleProgressWidth- circleProgressWidth/1.5)/2, circleProgressWidth/3, circleProgressWidth/1.5, circleProgressWidth/3.5);
    
    if (SCREEN_WIDTH == devWidth) {
        
        self.rateLael.size = CGSizeMake(circleProgressWidth, 40);
        self.rateLael.viewTop = self.incomLabel.viewBottom+ 5;
        
        self.infoLimitTitle.size = CGSizeMake(circleProgressWidth/4.5, 17);
        self.infoLimitTitle.viewLeft = circleProgressWidth/5;
        self.infoLimitTitle.viewBottom = 3*circleProgressWidth/4;
        
        self.infoLimitLabel.size = self.infoLimitTitle.size;
        self.infoLimitLabel.viewBottom = self.infoLimitTitle.viewTop;
        self.infoLimitLabel.viewLeft = self.infoLimitTitle.viewLeft;
        
        self.infoLabelTitle.size = self.infoLimitTitle.size;
        self.infoLabelTitle.viewBottom = self.infoLimitTitle.viewBottom;
        self.infoLabelTitle.viewRight = 4*circleProgressWidth/5;
        
        self.infoLabel.size = self.infoLimitLabel.size;
        self.infoLabel.viewBottom = self.infoLimitLabel.viewBottom;
        self.infoLabel.viewRight = self.infoLabelTitle.viewRight;
        
        self.investBtn.size = CGSizeMake(SCREEN_WIDTH - 20, SCREEN_WIDTH/8);
        self.investBtn.viewLeft = 10;
        self.investBtn.viewTop = self.firstGoalBar.viewBottom + 5;

        
        self.markLabel.size = CGSizeMake(SCREEN_WIDTH, 20);
        self.markLabel.viewTop = self.investBtn.viewBottom + 3;

    }else{
    
        self.rateLael.size = CGSizeMake(circleProgressWidth, 60);
        self.rateLael.viewTop = self.incomLabel.viewBottom+ 15;
        
        self.infoLimitTitle.size = CGSizeMake(circleProgressWidth/4, 25);
        self.infoLimitTitle.viewLeft = circleProgressWidth/5;
        self.infoLimitTitle.viewBottom = 4*circleProgressWidth/5;

        self.infoLimitLabel.size = self.infoLimitTitle.size;
        self.infoLimitLabel.viewBottom = self.infoLimitTitle.viewTop;
        self.infoLimitLabel.viewLeft = circleProgressWidth/5;
        
        self.infoLabelTitle.size = self.infoLimitLabel.size;
        self.infoLabelTitle.viewBottom = self.infoLimitTitle.viewBottom;
        self.infoLabelTitle.viewRight = 4*circleProgressWidth/5;
        
        self.infoLabel.size = self.infoLimitLabel.size;
        self.infoLabel.viewBottom = self.infoLimitLabel.viewBottom;
        self.infoLabel.viewRight = self.infoLabelTitle.viewRight;
        
        self.investBtn.size = CGSizeMake(SCREEN_WIDTH - 20, SCREEN_WIDTH/8);
        self.investBtn.viewLeft = 10;
        self.investBtn.viewTop = self.firstGoalBar.viewBottom + 5;

        
        self.markLabel.size = CGSizeMake(SCREEN_WIDTH, 20);
        self.markLabel.viewTop = self.investBtn.viewBottom + 3;
    
    }
    self.scrView.contentSize = CGSizeMake(SCREEN_WIDTH , self.markLabel.viewBottom + 50);
}
#pragma mark refresh
- (void)headerRefeshing
{
    isFresh = YES;
    [self baseInfoSend];
}

#pragma mark 进度条
- (void)viewDidUnload
{
    self.secondGoalBar = nil;
    self.firstGoalBar = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
#pragma mark CarouselsViewDelegate
-(NSArray *)getPageOfImgArr
{
    if (self.carouselsPicArr.count > 0) {
        
        return self.picArr;
        
    }
    else
    {
       return  [UserDefaults objectForKey:HOME_CAROUSELS];
    
    }
  
}
-(NSTimeInterval)getTimerOfPageControl;
{
    return 5.0f;
    
}
- (void)didClickPage:(CarouselsView *)csView atIndex:(NSInteger)index
{
    
}
#pragma mark navBtnClick
-(void)navRightBtnDown
{
    //未登录
    if ([[UserDefaults objectForKey:kIsLogin] isEqualToString:@"0"])
    {
        [StaticTools showLoginControllerWithSuccess:^{
            
            [self pushNewsPageView];
            
        } fail:nil];
        
    }else
    {
        [self pushNewsPageView];
    }

}
-(void)pushNewsPageView
{
    NewsViewController *newsVC = [NewsViewController new];
    newsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newsVC animated:YES];
}
#pragma mark UserInfoData
-(void)getUserDataRequest
{
    [[HttpRequest sharedRequest]sendRequestWithMessage:@"" path:@"getInfo" param:nil succuss:^(id result) {

        [UserDefaults setObject:result[@"accountName"] forKey:USER_NICKNAME];
        [UserDefaults setObject:result[@"avatarPath"] forKey:USER_PHOTO];
        [UserDefaults setObject:result[@"bankCard"] forKey:USER_BANKCARD];
        [UserDefaults synchronize];

    } fail:nil];

}

@end