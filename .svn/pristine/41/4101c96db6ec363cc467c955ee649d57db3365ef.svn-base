//
//  AboutViewController.m
//  ZRwalletForConsumer
//
//  Created by 陈焕鲁 on 15/6/30.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "AboutViewController.h"
#import "MASUtilities.h"
#import "UIColor+NSString.h"

#define kTag_Sheet_Phone 100
#define kTag_Sheet_Net 101

@interface AboutViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    NSMutableArray *_dataArray1;
    NSMutableArray *_dataArray2;
    UITableView *_tableView;
}
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //初始化数据和tableView
    self.navigationItem.title = @"关于我们";
    _dataArray = [[NSMutableArray alloc] init];
    _dataArray1 = [[NSMutableArray alloc] init];
    _dataArray2 = [[NSMutableArray alloc] init];
    NSArray *arr1 = @[@"版本号",@"官方微信",@"客服电话",@"官方网址"];
    NSArray *arr2 = @[@"1.0.0",@"rilipay",@"400-030-1515",@"www.rilipay.com"];
    NSArray *arr3 = @[@"ip_shgywm_ver.png",@"ip_gy_we.png",@"ip_gy_te.png",@"ip_gy_ver.png"];
    [_dataArray addObjectsFromArray:arr1];
    [_dataArray1 addObjectsFromArray:arr2];
    [_dataArray2 addObjectsFromArray:arr3];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    //self.view.backgroundColor =RGBCOLOR(232, 231, 231);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
#pragma mark 添加公司logo和公司名称
    //logo
    UIImageView *HeaderView = [[UIImageView alloc] init];
    HeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH,120);
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ip_shyhdl_logo.png"]];
    logoImage.contentMode = UIViewContentModeScaleAspectFit;//等比例缩放
   
    [HeaderView addSubview:logoImage];
    [logoImage makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.width.equalTo(@80);
        make.height.equalTo(@80);
        make.centerX.equalTo(HeaderView.centerX);
    }];
    _tableView.tableHeaderView = HeaderView;
    [logoImage makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(HeaderView.mas_centerY);
        make.centerX.equalTo(HeaderView.mas_centerX);
    }];
    //公司名称
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    _tableView.tableFooterView = footView;
    UILabel *label = [[UILabel alloc] init];
    label.text = @"中融钱宝科技有限公司";
    label.font = [UIFont  systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(30);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right).offset(-30);;
        make.height.equalTo(@30);
        
    }];

    
}
#pragma mark -UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == kTag_Sheet_Net)
    {
        if (buttonIndex==0)
        {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.rilipay.com"]];
        }
    }
    else
    {
        if (buttonIndex==0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:4000301515"]];
        }
    }
    
}

#pragma mark 实现UITableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell ==nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    // 每一行显示的信息
   
    UIImageView *leftImage = [[UIImageView alloc] init];
    leftImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_dataArray2[indexPath.row]]];
    [cell.contentView addSubview:leftImage];
    [leftImage makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.centerY);
        make.left.equalTo(@10);
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.text = _dataArray[indexPath.row];
    [cell.contentView addSubview:leftLabel];
    [leftLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.centerY);
        make.left.equalTo(leftImage.right).offset(15);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    
    leftLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.text = _dataArray1[indexPath.row];
    rightLabel.font = [UIFont systemFontOfSize:15];
    rightLabel.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:rightLabel];
    [rightLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.centerY);
        make.right.equalTo(cell.right).offset(-10);
        make.width.equalTo(@120);
        make.height.equalTo(@30);
    }];
        if (indexPath.row==2) {
       rightLabel.textColor = RGBCOLOR(209, 117, 59);
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //**********去掉cell的点击效果***********
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row!=2) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    }
    if (indexPath.row==2)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"拨打客服" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拨打400-030-1515" otherButtonTitles: nil];
        sheet.tag = kTag_Sheet_Phone;
        [sheet showInView:self.view];
    }
    else if(indexPath.row==3)
    {
        
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"访问官网" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"访问http://www.rilipay.com" otherButtonTitles: nil];
        sheet.tag = kTag_Sheet_Net;
        [sheet showInView:self.view];
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
