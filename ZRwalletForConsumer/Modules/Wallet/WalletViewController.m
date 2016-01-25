//
//  WalletViewController.m
//  ZRwalletForMerchant
//
//  Created by 文彬 on 15/6/29.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "WalletViewController.h"
#import "BringMoneyViewController.h"
#import "UserRechargeViewController.h"
#import "UIColor+NSString.h"
#import "AppNavView.h"
#import "BillListViewController.h"
#import "walletModel.h"
#import "MJRefresh.h"
#import "IncomeHistotyListViewController.h"
#import "MyBankCardViewController.h"

#define space 0.5
#define TopButtonTag 100
#define AmountTag  200

@interface WalletViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UIImageView *HeaderView;
    NSArray *keys;
    BOOL showMore;// 下拉展示可用余额
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@property (nonatomic,strong) NSMutableDictionary *infoDict;

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"钱包";
    self.view.backgroundColor = [UIColor colorWithString:@"#f0f0f0"];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    keys = @[@[@{@"title":@"账户余额(元)",@"key":@"total"},
               @{@"title":@"可用余额(元)",@"key":@"cashBalance"},
               @{@"title":@"冻结资金(元)",@"key":@"frozenAmount"}],
             @[@{@"title":@"可用信用额(元)",@"key":@"creditAvailableAmount"},
               @{@"title":@"账单(元)",@"key":@"billAmount"}]];
   
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ip_nav"] forBarMetrics:UIBarMetricsDefault];
       self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor], UITextAttributeFont:[UIFont boldSystemFontOfSize:18]};
    
    [self initPageControl];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self getAccountInfo];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark 功能函数
/**
 *  初始化页面函数
 */
- (void)initPageControl
{
    //*****************************设置导航栏*********************
   //提现
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.frame = CGRectMake(0, 0, 30, 30);
    [leftButton setTitle:@"提现" forState:UIControlStateNormal];
    leftButton.tintColor = [UIColor whiteColor];
    [leftButton addTarget:self action:@selector(btnClick1:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    //充值
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 30, 30);
    [rightButton setTitle:@"充值" forState:UIControlStateNormal];
    rightButton.tintColor = [UIColor whiteColor];
    [rightButton addTarget:self action:@selector(btnClick2:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    
    [self createHeaderView];
    
}

-(void)createHeaderView
{
    self.listTableView.backgroundColor  = [UIColor clearColor];
    self.listTableView.userInteractionEnabled = YES;
    
    HeaderView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*1/4)];
    HeaderView.image = [UIImage imageNamed:@"ip_yhqb_bjwa"];
    self.listTableView.tableHeaderView = HeaderView;
 
    for (int i = 0; i < 2; i++)
    {
        UIView *TopView = [[UIView alloc] initWithFrame:CGRectMake(i%2*((SCREEN_WIDTH-space)/2+space),20 + i/2*(0.4*(SCREEN_WIDTH-space)/2 + space)-20, (SCREEN_WIDTH-space)/2, HeaderView.size.height)];
        TopView.tag = 2000 + i;
        TopView.backgroundColor = [UIColor clearColor];
        TopView.layer.borderColor = [UIColor colorWithString:@"#f0f0f0"].CGColor;
        TopView.layer.borderWidth = 0.5;
        [HeaderView addSubview:TopView];
        NSArray *leftImgArr = @[@"ip_yhqb_ear.png",@"ip_yhqb_rec.png"];
        UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",leftImgArr[i]]]];
        [TopView addSubview:leftImageView];
        [leftImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@30);
            make.top.equalTo(@10);
            make.height.equalTo(@30);
            make.width.equalTo(@30);
        }];
        
        NSArray *topLabelArr = @[@"待收收益",@"已收收益"];
        UILabel *topLabel = [[UILabel alloc]init];
        topLabel.tag = 100+i;
        topLabel.text = [NSString stringWithFormat:@"%@",topLabelArr[i]];
        [TopView addSubview:topLabel];
        [topLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftImageView.right).offset(5);
            make.height.equalTo(@30);
            make.centerY.equalTo(leftImageView.centerY);
        }];
        
        
        UILabel *temLabel =  [[UILabel alloc] init];
        temLabel.tag = AmountTag + i;
        [TopView addSubview:temLabel];
        if (temLabel.tag==201) {
            temLabel.textColor = [UIColor redColor];
        }
        else
        {
            temLabel.textColor = [UIColor blackColor];
        }
        [temLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topLabel.bottom).offset(5);
            make.left.equalTo(topLabel.left);
            make.height.equalTo(@30);
            make.width.equalTo(@100);
        }];
    }
}
/**
 *  下拉刷新
 */
- (void)headerRefeshing
{
    
    [self getAccountInfo];
}


#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section==0) {
        
        return showMore?3:1;
    }
    if (section==1) {
        return 2;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return kCellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
 
    if (indexPath.section==2) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSArray *ImgArr = @[@"ip_yhqb_tra.png",@"ip_yhqb_his.png"];
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",ImgArr[indexPath.row]]];
        [cell.contentView addSubview:imgView];
        [imgView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.centerY.equalTo(cell.centerY);
            make.height.equalTo(@25);
            make.width.equalTo(@25);
        }];
        
        NSArray *TextArray = @[@"交易记录",@"历史收益"];
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.font = [UIFont systemFontOfSize:16];
        leftLabel.textColor = RGBCOLOR(58, 58, 58);
        leftLabel.text =TextArray[indexPath.row];
        [cell.contentView addSubview:leftLabel];
        [leftLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView.right).offset(10);
            make.centerY.equalTo(cell.centerY);
            make.width.equalTo(@80);
            make.height.equalTo(@50);
        }];
       
        
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if (indexPath.section==0&&indexPath.row==0)
        {
            
            //右侧箭头图片
            UIImageView *stateImgView = [[UIImageView alloc]init];
            stateImgView.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:stateImgView];
            
            if (showMore)
            {
                stateImgView.image = [UIImage imageNamed:@"ip_yhfk_modow"];
                [stateImgView makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(@-10);
                    make.centerY.equalTo(cell.contentView.centerY);
                    make.width.equalTo(@15);
                    make.height.equalTo(@10);
                }];
            }
            else
            {
                stateImgView.image = [UIImage imageNamed:@"ip_aqsz_mo"];
                [stateImgView makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(@-10);
                    make.centerY.equalTo(cell.contentView.centerY);
                    make.width.equalTo(@10);
                    make.height.equalTo(@15);
                }];
            }
        }
        
        
        BOOL isMore = NO;
        if (indexPath.section==0&&indexPath.row!=0)
        {
            isMore = YES;
        }
        //****************左侧标题**********************
        UILabel *leftLabel = [[UILabel alloc]init];
        leftLabel.font = [UIFont systemFontOfSize:isMore?14:16];
        leftLabel.textColor = isMore?[UIColor grayColor]: RGBCOLOR(58, 58, 58);
        [cell.contentView addSubview:leftLabel];
        [leftLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(isMore?30:10));
            make.centerY.equalTo(cell.contentView.centerY);
            make.width.equalTo(@150);
            make.height.equalTo(@30);
        }];
        
        
        //****************右侧数字 **********************
        UILabel *rightLabel = [[UILabel alloc] init];
        [cell.contentView addSubview:rightLabel];
        rightLabel.adjustsFontSizeToFitWidth = YES;
        rightLabel.font = [UIFont systemFontOfSize:isMore?14:16];
        rightLabel.textColor = isMore?[UIColor grayColor]:[UIColor redColor];
        rightLabel.textAlignment = NSTextAlignmentRight;
        [rightLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.centerY);
            if(indexPath.section==0)
            {
                make.right.equalTo(@(-30));
            }
            else
            {
              make.right.equalTo(@(-10));
            }
            
            make.height.equalTo(@35);
            make.width.equalTo(@150);
        }];
        
        NSDictionary *dict = keys[indexPath.section][indexPath.row];
        leftLabel.text = dict[@"title"];
        rightLabel.text = self.infoDict[dict[@"key"]];
       
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//点击时有效果，点击后效果消失
    
    if (indexPath.section == 0)
    {
        showMore = !showMore;
        [self.listTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
    if (indexPath.section==2)
    {
        if (indexPath.row==0) //交易历史
        {
            BillListViewController *blvc = [[BillListViewController alloc] init];
            blvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:blvc animated:YES];

        }
        if (indexPath.row==1) //收益历史
        {
            IncomeHistotyListViewController *incomeHistoryController = [[IncomeHistotyListViewController alloc]init];
            incomeHistoryController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:incomeHistoryController animated:YES];
        }
    }
}


#pragma mark 提现
-(void)btnClick1:(UIButton *)btn1
{
   //提现界面
    if ([[UserDefaults objectForKey:@"bankCard"] isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您还未绑定银行卡,您是否要绑定银行卡" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else
    {
        BringMoneyViewController *bmvc = [[BringMoneyViewController alloc] init];
        bmvc.cashBalance = self.infoDict[@"cashBalance"];
        bmvc.hidesBottomBarWhenPushed = YES;//隐藏标签栏
        [self.navigationController pushViewController:bmvc animated:YES];
    }
   
}
#pragma mark 充值
-(void)btnClick2:(UIButton *)btn2
{
    //充值
    /**
     *  如果没有绑定银行卡，跳转到绑定银行卡界面，若绑定了则直接进入
     */
    if ([[UserDefaults objectForKey:@"bankCard"] isEqualToString:@""])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您还未绑定银行卡,您是否要绑定银行卡" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
    }
    else
    {
        UserRechargeViewController *rvc = [[UserRechargeViewController alloc] init];
        rvc.hidesBottomBarWhenPushed = YES;//隐藏标签栏
        [self.navigationController  pushViewController: rvc animated:YES];
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
       
        MyBankCardViewController *mbcvc = [[MyBankCardViewController alloc] init];
        mbcvc.hidesBottomBarWhenPushed = YES;
        mbcvc.isHaveStr = @"0";
        [self.navigationController pushViewController:mbcvc animated:YES];
    }
}
#pragma mark HTTP
/**
 *  获取账户信息
 */
-(void)getAccountInfo
{
    
    [[HttpRequest sharedRequest]sendRequestWithMessage:@"" path:@"account/queryWalletDetail" param:nil succuss:^(id result) {
        
        self.infoDict = [NSMutableDictionary dictionaryWithDictionary:result];
        double total = [self.infoDict[@"cashBalance"] doubleValue]+[self.infoDict[@"frozenAmount"] doubleValue];
        [self.infoDict setObject:[NSString stringWithFormat:@"%.2f",total] forKey:@"total"];
        
        UILabel *leftLabel = (UILabel*)[[HeaderView viewWithTag:2000] viewWithTag:200];
        leftLabel.text = [NSString stringWithFormat:@"%@元",self.infoDict[@"unEarningAmount"]];
        
        UILabel *rigLhabel = (UILabel*)[[HeaderView viewWithTag:2001] viewWithTag:201];
        rigLhabel.text = [NSString stringWithFormat:@"%@元",self.infoDict[@"userEarningAmount"]];
        [self.listTableView reloadData];
        
        
    } fail:nil];
}
@end
