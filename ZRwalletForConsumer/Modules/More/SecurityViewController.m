//
//  SecurityViewController.m
//  ZRwalletForConsumer
//
//  Created by 陈焕鲁 on 15/6/30.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "SecurityViewController.h"
#import "ChangePasswordViewController.h"
#import "ChangePayPasswordViewController.h"
#import "LLLockViewController.h"

@interface SecurityViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView    *_tableView;
}

@end

@implementation SecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"安全设置";
    // 创建TableView
    [self createTableView];
    
}

#pragma mark 创建设置列表
-(void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ScreenHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = RGBCOLOR(231, 231, 231);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
}

#pragma mark 实现UITableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // 每一行显示的信息
    for (UIView * view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UIImageView * cellImage = [[UIImageView alloc]init];
    [cell.contentView addSubview:cellImage];
    [cellImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(cell.mas_centerY);
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.font = [UIFont systemFontOfSize:16];
    [leftLabel sizeToFit];
    [cell.contentView addSubview:leftLabel];
    [leftLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cellImage.right).offset(10);
        make.centerY.equalTo(cellImage.mas_centerY);
        make.width.equalTo(@100);
    }];
    
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.font = [UIFont systemFontOfSize:14];
    [rightLabel sizeToFit];
    [cell.contentView addSubview:rightLabel];
    //对左边的标签添加约束
    [rightLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.mas_right).offset(-10);
        make.width.equalTo(@80);
        make.bottom.equalTo(leftLabel.bottom);
    }];
    
    if (indexPath.section==0)
    {
        leftLabel.text = @"登录密码";
        cell.imageView.image = [UIImage imageNamed:@"ip_aqsz_la"];
        rightLabel.text = @"点击修改";
    }
    if (indexPath.section==1)
    {
        cell.imageView.image = [UIImage imageNamed:@"ip_zwmm_po"];
        leftLabel.text = @"手势密码";
        rightLabel.text = @"点击修改";
    }
    else if(indexPath.section==2)
    {
        if ([[UserDefaults objectForKey:@"bankCard"] isEqualToString:@""]) {
            cell.hidden = YES;
        }
        else{
            leftLabel.text =@"支付密码";
            cell.imageView.image = [UIImage imageNamed:@"ip_aqsz_pay"];
            rightLabel.text = @"点击修改";
        }
        
        
    }
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
    if (indexPath.section==0)
    {
       
        ChangePasswordViewController *cpvc = [[ChangePasswordViewController alloc] init];
        cpvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cpvc animated:YES];
       

    }
    if (indexPath.section==1)
    {
        LLLockViewController *lockVc = [[LLLockViewController alloc] init];
        lockVc.nLockViewType = LLLockViewTypeModify;
        [self.navigationController pushViewController:lockVc animated:YES];
    }
    else if (indexPath.section==2)
    {
        ChangePayPasswordViewController *cppvc = [[ChangePayPasswordViewController alloc] init];
        [self.navigationController pushViewController:cppvc animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
