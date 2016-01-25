//
//  ProjectDetailViewController.m
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/7/8.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

static NSInteger titleLabelTag = 1000;
static NSInteger valueLabelTag = 2000;
static NSInteger topTitleLabelTag = 3000;
static NSInteger lineViewTag = 4000;
#import "ProjectDetailViewController.h"
#import "AppNavView.h"
#import "UIColor+NSString.h"
#import "THProgressView.h"
#import "ValueOfInvestmentViewController.h"
#import "MoreDetailViewController.h"
@interface ProjectDetailViewController ()
@property (nonatomic, strong) AppNavView *navView;
@property (nonatomic, strong) UIScrollView *scrView;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *topTitleLabel;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UILabel *topPlaneValeLabel;
@property (nonatomic, strong) UILabel *topRateValeLabel;

@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) UIView *listView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIButton *investBtn;

//进度条
@property (nonatomic) CGFloat progress;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSArray *progressViews;
@property (nonatomic, strong) UILabel *scheduleLabel;
@property (nonatomic , strong) UILabel *progressLabel;

@property (nonatomic, strong) UIButton *moreDetailBtn;
@property (nonatomic, strong) UIImageView *goPageImgView;
@property (nonatomic, assign) int percent;
@property (nonatomic, assign) CGFloat projectLabelHeight;//项目名称 动态高度
@property (nonatomic, strong) UIImageView *fullImgView;//投资已满
@end

@implementation ProjectDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    [self makeNavView];
    [self makeView];
    [self refreshView];
}
-(void)isFullView
{
    self.fullImgView = [UIImageView new];
    self.fullImgView.frame = CGRectMake(0, (SCREEN_HEIGHT - 2*SCREEN_WIDTH)/2, 2*SCREEN_WIDTH, 2*SCREEN_WIDTH);
    self.fullImgView.image = [UIImage imageNamed:@"fullstamp"];
    [self.view addSubview:self.fullImgView];

    [UIView animateWithDuration:0.5 animations:^{
        
        self.fullImgView.frame = CGRectMake(SCREEN_WIDTH/4, (SCREEN_HEIGHT - SCREEN_WIDTH/2)/2, SCREEN_WIDTH/2, SCREEN_WIDTH/2);
        
    } completion:^(BOOL finished) {
        
    }];

}
-(void)makeNavView
{
    self.navView = [AppNavView new];
    self.navView.delegate = self;
    [self.view addSubview:self.navView];
    self.navView.titleLabel.text = @"项目详情";
    
    self.navView.leftImgView.image = [UIImage imageNamed:@"whiteBack"];

}
-(void)makeView
{
    self.scrView = [UIScrollView new];
    self.scrView.showsVerticalScrollIndicator = NO;
    self.scrView.backgroundColor = [UIColor colorWithString:@"#f0f0f0"];
    self.scrView.delegate = self;
    [self.view addSubview:self.scrView];

    self.topView = [UIView new];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self.topView addLine];
    [self.scrView addSubview:self.topView];
    
    NSArray *topTitleArr = @[@"计划金额",@"年利率"];
    for (int i = 0 ; i < topTitleArr.count ; i++) {
        self.topTitleLabel = [UILabel new];
        self.topTitleLabel.text = topTitleArr[i];
        self.topTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.topTitleLabel.font = [UIFont systemFontOfSize:16];
        self.topTitleLabel.textColor = [UIColor colorWithString:@"#434343"];
        self.topTitleLabel.tag = topTitleLabelTag + i;
        [self.topView addSubview:self.topTitleLabel];
    }
    
    self.topLineView = [UIView new];
    self.topLineView.backgroundColor = [UIColor colorWithString:@"#f0f0f0"];
    [self.topView addSubview:self.topLineView];
    
    self.topPlaneValeLabel = [UILabel new];
    self.topPlaneValeLabel.font = [UIFont systemFontOfSize:22];
    self.topPlaneValeLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:self.topPlaneValeLabel];
    
    self.topRateValeLabel = [UILabel new];
    self.topRateValeLabel.font = [UIFont systemFontOfSize:22];
    self.topRateValeLabel.textColor = RGBCOLOR(206, 0, 28);
    self.topRateValeLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:self.topRateValeLabel];
    /*-----------进度条----------*/
    CGSize progressViewSize = { SCREEN_WIDTH - 60, 30.0f };
    
    THProgressView *topProgressView = [[THProgressView alloc] initWithFrame:
                                       CGRectMake(SCREEN_WIDTH/2 - 20 +CGRectGetMidX(self.topView.frame) -
                                                  progressViewSize.width / 2.0f,
                                                  CGRectGetMidY(self.topView.frame) -
                                                  progressViewSize.height / 2.0f + SCREEN_WIDTH/3,
                                                  progressViewSize.width,
                                                  progressViewSize.height)];
    topProgressView.borderTintColor = [UIColor colorWithString:@"#f0f0f0"];
    topProgressView.progressTintColor = RGBCOLOR(206, 0, 33);
    [self.topView addSubview:topProgressView];
    
    self.progressViews = @[topProgressView ];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];

    self.scheduleLabel = [UILabel new];
    self.scheduleLabel.text = @"当前进度";
    self.scheduleLabel.font = [UIFont systemFontOfSize:9];
    [self.topView addSubview:self.scheduleLabel];

    self.progressLabel = [UILabel new];
    self.progressLabel.textAlignment = NSTextAlignmentRight;
    self.progressLabel.font = [UIFont systemFontOfSize:12];
    self.progressLabel.textColor = RGBCOLOR(206, 0, 33);
    [self.topView addSubview:self.progressLabel];
    
     /*-----------进度条----------*/
    self.listView = [UIView new];
    self.listView.backgroundColor = [UIColor whiteColor];
    [self.listView addLine];
    [self.scrView addSubview:self.listView];
    
    self.titleArr = [ProjectDetailViewController getTitleArr];

    for (int i = 0 ; i < self.titleArr.count; i++) {
        
        self.titleLabel = [UILabel new];
        self.titleLabel.tag = titleLabelTag + i;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textColor = [UIColor colorWithString:@"#434343"];
        self.titleLabel.text = self.titleArr[i];
        [self.listView addSubview:self.titleLabel];
        
        self.valueLabel = [UILabel new];
        self.valueLabel.tag = valueLabelTag + i;
        self.valueLabel.numberOfLines = 0;
        self.valueLabel.textAlignment = NSTextAlignmentRight;
        self.valueLabel.font = [UIFont systemFontOfSize:15];
        self.valueLabel.textColor = RGBCOLOR(125, 125, 125);

        [self.listView addSubview:self.valueLabel];
        
        if (i != self.titleArr.count - 1) {
            self.lineView = [UIView new];
            self.lineView.tag = lineViewTag + i;
            self.lineView.backgroundColor = [UIColor colorWithString:@"#f0f0f0"];
            [self.listView addSubview:self.lineView];
        }
    }
    
    self.investBtn = [UIButton new];
    self.investBtn.backgroundColor = RGBCOLOR(206, 0, 33);
    self.investBtn.layer.masksToBounds = YES;
    self.investBtn.layer.cornerRadius = 4.0;
    [self.investBtn addTarget:self
                       action:@selector(investBtnDown)
             forControlEvents:UIControlEventTouchUpInside
     ];
    [self.investBtn setTitle:@"立即投资" forState:UIControlStateNormal];
    [self.scrView addSubview:self.investBtn];

    self.moreDetailBtn = [UIButton new];
    self.moreDetailBtn.backgroundColor = [UIColor whiteColor];
    [self.moreDetailBtn setTitle:@"更多详情" forState:UIControlStateNormal];
    self.moreDetailBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.moreDetailBtn addLine];
    [self.moreDetailBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.moreDetailBtn addTarget : self
                         action : @selector(moreDetailBtnDown)
               forControlEvents : UIControlEventTouchUpInside];
    [self.scrView addSubview:self.moreDetailBtn];
    
    self.goPageImgView = [UIImageView new];
    self.goPageImgView.image = [UIImage imageNamed:@"my_goPage.png"];
    [self.moreDetailBtn addSubview:self.goPageImgView];
    
}
-(void)refreshView
{
    self.topPlaneValeLabel.text = [NSString stringWithFormat:@"%.d万",[self.raisingVolume intValue]];
    self.topRateValeLabel.text = [NSString stringWithFormat:@"%@%%",self.yearRoa];
    
    float amount = [self.amonut floatValue];
    float raisingVolume = [self.raisingVolume floatValue];
    self.percent = amount/raisingVolume *100;
    
    //已投满
    if(self.percent  == 100)
    {
        [self isFullView];
    
    }
    self.progressLabel.text = [NSString stringWithFormat:@"%d%%",self.percent];
    
    self.titleLabel = (UILabel *)[self.view viewWithTag:valueLabelTag];
    self.titleLabel.text = self.projectName;
    
    self.projectLabelHeight = [self heightWithLabel : self.titleLabel.text
                                       fontWithFont : [UIFont systemFontOfSize:15]].height;
    
    self.titleLabel = (UILabel *)[self.view viewWithTag:valueLabelTag + 1];
    self.titleLabel.text = @"保理";
    
    self.titleLabel = (UILabel *)[self.view viewWithTag:valueLabelTag + 2];
    self.titleLabel.text = @"中融保理";
    
    self.titleLabel = (UILabel *)[self.view viewWithTag:valueLabelTag + 3];
    self.titleLabel.text = self.paybackType;

    self.titleLabel = (UILabel *)[self.view viewWithTag:valueLabelTag + 4];
    self.titleLabel.text = self.paybackTime;

    self.titleLabel = (UILabel *)[self.view viewWithTag:valueLabelTag + 5];
    self.titleLabel.text = @"100元";
    
    //已完成的项目
    if (self.type == 1) {
        self.investBtn.hidden = YES;
    }
    
    
    
 }
-(void)moreDetailBtnDown
{
    MoreDetailViewController *moreVC = [MoreDetailViewController new];
    moreVC.projectId = self.projectId;
    moreVC.projectDesp = self.projectDesp;
    [self.navigationController pushViewController:moreVC animated:YES];

}
+(NSArray *)getTitleArr
{
    return @[ @"项目名称",
              @"项目类型",
              @"保理机构",
              @"还款方式",
              @"还款日期",
              @"起投金额"
            ];

}
-(void)investBtnDown
{
    //未登录
    if ([[UserDefaults objectForKey:kIsLogin] isEqualToString:@"0"])
    {
        [StaticTools showLoginControllerWithSuccess:^{
            
            if ([self.projectStatus isEqualToString:@"3"]) {
                
                [UIAlertView showAlertView:@"项目已过期"];
                return;
                
            }if(self.percent  == 100)
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
    }if ([self.projectStatus isEqualToString:@"3"]) {
        
        [UIAlertView showAlertView:@"项目已过期"];
        return;

    }if(self.percent  == 100)
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
    valueVC.projectId = self.projectId;
    valueVC.yearRoa = [self.yearRoa floatValue];
    valueVC.day = self.day;
    [self.navigationController pushViewController:valueVC animated:YES];

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

    self.topView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/2.5);
  
    for (int i = 0 ; i < 2 ; i++) {
        
        UILabel *tempLabel = (UILabel *)[self.view viewWithTag:topTitleLabelTag + i];
        tempLabel.size = CGSizeMake(SCREEN_WIDTH/2, 20);
        tempLabel.viewTop = 20;
        tempLabel.viewLeft = tempLabel.size.width*i;

    }
    self.topLineView.size = CGSizeMake(1, self.topView.size.height/2 );
    self.topLineView.viewTop = 10;
    self.topLineView.viewLeft = SCREEN_WIDTH/2;
    
    self.topPlaneValeLabel.size = CGSizeMake(SCREEN_WIDTH/2, 40);
    self.topPlaneValeLabel.viewTop = 40;

    self.topRateValeLabel.size = self.topPlaneValeLabel.size;
    self.topRateValeLabel.viewTop = self.topPlaneValeLabel.viewTop;
    self.topRateValeLabel.viewRight = self.view.viewRight;
    
    self.progressLabel.size = CGSizeMake(35, 10);
    self.progressLabel.viewRight = self.view.viewRight - 20;
    self.progressLabel.viewBottom = self.topView.viewBottom - 10;
    
    self.scheduleLabel.size = CGSizeMake(40, 10);
    self.scheduleLabel.viewRight = self.view.viewRight - 10;
    self.scheduleLabel.viewBottom = self.progressLabel.viewTop - 5;

    self.listView.size = CGSizeMake(SCREEN_WIDTH, kCellHeight*5 + self.projectLabelHeight + 20);
    self.listView.viewTop = self.topView.viewBottom + 10;
    
    for (int i = 0; i < 6 ; i++) {
       
        UILabel *tempValueLabel = (UILabel *)[self.view viewWithTag:valueLabelTag + i];
        UILabel *temptitleLabel = (UILabel *)[self.view viewWithTag:titleLabelTag + i];

        
        if (valueLabelTag + i == valueLabelTag)
        {
            tempValueLabel.size = CGSizeMake(SCREEN_WIDTH/2, self.projectLabelHeight + 20);
            temptitleLabel.size = tempValueLabel.size;

        }else
        {
            tempValueLabel.size = CGSizeMake(SCREEN_WIDTH/2, kCellHeight);
            temptitleLabel.size = tempValueLabel.size;
        }
        
        tempValueLabel.viewTop = (i-1)*tempValueLabel.size.height + self.projectLabelHeight + 20;
        tempValueLabel.viewRight = self.view.viewRight - 20;
        
        temptitleLabel.viewTop = tempValueLabel.viewTop;
        temptitleLabel.viewLeft = 20;

        UIView *tempLineViw = (UIView *)[self.view viewWithTag:lineViewTag + i];
        tempLineViw.size = CGSizeMake(SCREEN_WIDTH - 10, 1);
        tempLineViw.viewTop = tempValueLabel.viewBottom;
        tempLineViw.viewLeft = 5;
    }
    
    self.moreDetailBtn.size = CGSizeMake(SCREEN_WIDTH, kCellHeight);
    self.moreDetailBtn.viewTop = self.listView.viewBottom + 20;
    
    self.goPageImgView.size = CGSizeMake(22, 22);
    self.goPageImgView.viewCenterY = self.moreDetailBtn.size.height/2;
    self.goPageImgView.viewRight = self.moreDetailBtn.viewRight - 10;
    
    self.investBtn.size = CGSizeMake(SCREEN_WIDTH - 20, SCREEN_WIDTH/8);
    self.investBtn.viewLeft = 10;
    self.investBtn.viewTop = self.moreDetailBtn.viewBottom + 20;
   
    self.scrView.contentSize = CGSizeMake(SCREEN_WIDTH , self.investBtn.viewBottom + 10);
    
}
#pragma getCellHight
-(CGSize)heightWithLabel:(NSString *)text fontWithFont:(UIFont *) font
{
    
    NSDictionary *fontDic = @{ NSFontAttributeName : font };
    
    CGSize labelSize = [text
                        boundingRectWithSize : CGSizeMake(SCREEN_WIDTH/2, MAXFLOAT)
                        options : NSStringDrawingUsesLineFragmentOrigin
                        attributes : fontDic
                        context : nil
                        ].size;
    
    return labelSize;
    
}

#pragma  mark 进度条
- (void)updateProgress
{
    NSString *percentStr = [NSString stringWithFormat:@"%d",self.percent];
    float percent = [percentStr floatValue]/100;
    [UIView animateWithDuration:0.1 animations:^{
        self.progress = percent;
        
    } completion:^(BOOL finished) {
        
    }];
    
    [self.progressViews enumerateObjectsUsingBlock:^(THProgressView *progressView, NSUInteger idx, BOOL *stop) {
        [progressView setProgress:self.progress animated:YES];
    }];
}
#pragma mark - navBtnClick
-(void)navLeftBtnDown
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
