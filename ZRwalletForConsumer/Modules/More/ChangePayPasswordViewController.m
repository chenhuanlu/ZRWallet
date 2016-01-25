//
//  ChangePayPasswordViewController.m
//  ZRwalletForConsumer
//
//  Created by 陈焕鲁 on 15/6/30.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "ChangePayPasswordViewController.h"
#import "RemberPayPasswordViewController.h"
#import "SecurityCheckoutViewController.h"
@interface ChangePayPasswordViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}
@end

@implementation ChangePayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.title = @"修改支付密码";
    UILabel *NavTitleLabel = [[UILabel alloc] init];
    NavTitleLabel.frame = CGRectMake(0, 0, 80, 30);
    NavTitleLabel.textColor = [UIColor whiteColor];
    NavTitleLabel.text = @"修改支付密码";
    self.navigationItem.titleView = NavTitleLabel;
    //初始化
    _dataArray = [[NSMutableArray alloc] init];
  self.view.backgroundColor = RGBCOLOR(232, 231, 231);
    
    // 创建TableView
    [self createTableView];
}

#pragma mark 创建设置列表
-(void)createTableView
{
    
    NSArray *arr = @[@"我记得原支付密码",@"我忘记支付密码了"];
    [_dataArray addObjectsFromArray:arr];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.bounces = NO;
    _tableView.showsVerticalScrollIndicator = NO;
//    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
     UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    _tableView.tableFooterView = footView;
    
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
    for (UIView * view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    NSString *info = _dataArray[indexPath.row];
    cell.textLabel.text = info;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    [cell.textLabel sizeToFit];
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
       if(indexPath.row==0)
    {
        //记得支付密码
        RemberPayPasswordViewController *rppvc = [[RemberPayPasswordViewController alloc] init];
        rppvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rppvc animated:YES];
    }
    if (indexPath.row==1) {
        //忘记支付密码
        SecurityCheckoutViewController *scvc = [[SecurityCheckoutViewController alloc] init];
        scvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:scvc animated:YES];
    }
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



@end
