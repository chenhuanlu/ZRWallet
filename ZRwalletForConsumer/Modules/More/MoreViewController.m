//
//  MoreViewController.m
//  ZRwalletForMerchant
//
//  Created by 文彬 on 15/6/29.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "MoreViewController.h"
#import "MASConstraint.h"
#import "FeedbackViewController.h"
#import "SecurityViewController.h"
#import "ChangePasswordViewController.h"
#import "AboutViewController.h"
#import "AppNavView.h"
#import "UIColor+NSString.h"
#import "LoginViewController.h"
#import "HelpCenterViewController.h"
@interface MoreViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UIButton *button;
}
@property (nonatomic,strong) NSMutableArray *imgArray;
@property (nonatomic, strong) AppNavView *navView;
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"更 多";
    //初始化
    _dataArray = [[NSMutableArray alloc] init];
    _imgArray = [[NSMutableArray alloc] init];
         // 创建TableView
    [self createTableView];
    UIView *footview = [[UIView alloc] init];
    footview.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footview;
    //创建退出登录按钮
    [self createLoginButton];
    self.view.backgroundColor = RGBCOLOR(232, 231, 231);
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;

    
    //[self.navigationController.navigationBar setBarTintColor:RGBCOLOR(175, 10, 39)];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ip_nav"] forBarMetrics:UIBarMetricsDefault];
   self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor], UITextAttributeFont:[UIFont boldSystemFontOfSize:18]};

   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self freshLoginBtn];
}
-(void)makeNavView
{
   
    self.navView = [AppNavView new];
    [self.view addSubview:self.navView];
    self.navView.titleLabel.text = @"设置";
    self.navView.size = CGSizeMake(SCREEN_WIDTH, Dev_NavigationBar_Height);
    
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

#pragma mark 创建退出登录按钮
- (void)freshLoginBtn
{
    if ([[UserDefaults objectForKey:kIsLogin] isEqualToString:@"0"]) {
        
        //button.hidden = YES;// 未登录 隐藏
        [button setTitle:@"登录/注册" forState:UIControlStateNormal];
    }
    else if ([[UserDefaults objectForKey:kIsLogin] isEqualToString:@"1"])
    {
        //button.hidden = NO;  //登录  不隐藏
        [button setTitle:@"退出登录" forState:UIControlStateNormal];
    }
}
-(void)createLoginButton
{
    button = [UIButton buttonWithType:UIButtonTypeCustom];
   
   // [button setTitle:@"退出登录" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:button];
    if (SCREEN_HEIGHT==667||SCREEN_HEIGHT==736) {
        button.titleLabel.font = [UIFont boldSystemFontOfSize:22];
        
    }
    else
    {
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }

    button.layer.cornerRadius = 3;
    button.clipsToBounds = YES;
    button.backgroundColor = RGBCOLOR(206, 0, 33);
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-100);
        make.height.equalTo(@(SCREEN_WIDTH/8));
    }];
    //触发点击事件
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    //[self freshLoginBtn];
}
-(void)btnClick:(UIButton *)btn
{
    //退出登录
    if ([[UserDefaults objectForKey:kIsLogin] isEqualToString:@"1"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定要退出登录" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
   
    }
    else if ([[UserDefaults objectForKey:kIsLogin] isEqualToString:@"0"])
    {
        [StaticTools showLoginControllerWithSuccess:^{
            
            
        } fail:^{
            
        }];
        
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [UserDefaults setObject:@"0" forKey:kIsLogin];
        [UserDefaults synchronize];
        [self freshLoginBtn];
    }
    
    
}
#pragma mark 创建设置列表
-(void)createTableView
{
    NSArray *arr = @[@"意见反馈",@"安全设置",@"帮  助",@"关于我们"];
    NSArray *imgarr = @[@"ip_shsz_op.png",@"ip_aqsz_pay.png",@"ip_shsz_qus.png",@"ip_shsz_ab.png"];
    [_dataArray addObjectsFromArray:arr];
    [_imgArray addObjectsFromArray:imgarr];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
   
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
}
#pragma mark 实现UITableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    // 每一行显示的信息
    
    UIImageView *cellImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",_imgArray[indexPath.row]]]];
    [cell.contentView addSubview:cellImage];
    [cellImage makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.mas_left).offset(15);
        make.centerY.equalTo(cell.mas_centerY);
        make.width.equalTo(@27);
        make.height.equalTo(@27);
    }];
    UILabel *cellLabel = [[UILabel alloc] init];
    cellLabel.font = [UIFont systemFontOfSize:16];
    cellLabel.textColor =  RGBCOLOR(58, 58, 58);
    cellLabel.text = _dataArray[indexPath.row];
    [cellLabel sizeToFit];
    [cell.contentView addSubview:cellLabel];
    [cellLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cellImage.mas_left).offset(40);
        make.centerY.equalTo(cellImage.mas_centerY);
        make.width.equalTo(@100);
    }];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

// 点击事件的触发
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//点击时有效果，点击后效果消失
    //cell点击事件
   
    
    if (indexPath.row==0) // 意见反馈
    {
         FeedbackViewController *fvc = [[FeedbackViewController alloc] init];
        fvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fvc animated:YES];
        
    }
   
    else if (indexPath.row==1)
    {
        
        
        if ([[UserDefaults objectForKey:kIsLogin] isEqualToString:@"0"])
        {
            
            [StaticTools showLoginControllerWithSuccess:^{
                
                SecurityViewController *svc = [[SecurityViewController alloc] init];
                svc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:svc animated:YES];

                
            } fail:^{
                
            }];
            
            return;
        }
        
        SecurityViewController *svc = [[SecurityViewController alloc] init];
        svc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:svc animated:YES];
    }

    else if (indexPath.row==2) {
        //常见问题
        HelpCenterViewController *helpVC = [HelpCenterViewController new];
        helpVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:helpVC animated:YES];
    }
   
    else
    {
        AboutViewController *avc = [[AboutViewController alloc] init];
        avc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:avc animated:YES];//关于
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
