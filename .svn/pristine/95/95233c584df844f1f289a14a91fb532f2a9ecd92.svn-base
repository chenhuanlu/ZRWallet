//
//  MyVIpViewController.m
//  ZRwalletForConsumer
//
//  Created by 陈焕鲁 on 15/7/22.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "MyVIpViewController.h"
#import "AppNavView.h"
#import "UIColor+NSString.h"
#import "VIPCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
@interface MyVIpViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    int currentPage;
    BOOL isFresh; //是否为下拉刷新
}
@property (nonatomic, strong) AppNavView *navView;
@property (strong,nonatomic) NSMutableArray *loadData;
@property (nonatomic, strong) NSString *merPhone;

@end

@implementation MyVIpViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavView];
    //初始化
    _dataArray = [[NSMutableArray alloc] init];
    
//    [self DownloaddataWithPage:1];
    
    // 创建TableView
    [self createTableView];
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
    //[_tableView headerBeginRefreshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    [_tableView headerBeginRefreshing];
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    isFresh = YES;
    [self DownloaddataWithPage:1];
    //[_tableView headerEndRefreshing];
}
- (void)footerRereshing
{

    [self DownloaddataWithPage:currentPage+1];//很关键。
    [_tableView footerEndRefreshing];
}


-(void)makeNavView
{
    self.navView = [AppNavView new];
    self.navView.delegate = self;
    [self.view addSubview:self.navView];
    
    self.navView.titleLabel.text = @"我的商户";
    self.navView.leftImgView.image = [UIImage imageNamed:@"whiteBack"];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.navView.size = CGSizeMake(SCREEN_WIDTH, Dev_NavigationBar_Height);
    
    
}
#pragma mark - navBtnClick
-(void)navLeftBtnDown
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 创建设置列表
-(void)createTableView
{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, ScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}
#pragma mark 实现UITableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataArray==nil)
    {
        return 0;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    VIPCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell ==nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"VIPCell" owner:self options:nil] objectAtIndex:0];
        cell = [[[NSBundle mainBundle]loadNibNamed:@"VIPCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
     //每一行显示的信息
    VIPmodel *model = _dataArray[indexPath.row];
    [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:model.avatarPath] placeholderImage:nil];
    cell.locationLabel.text = model.location;
    cell.merChantNameLabel.text = model.merchantNo;
    cell.bussinessLabel.text = model.business;
    cell.merchantNameabel.text = model.merchantName;
    [cell.headerImage sd_setRoundImageWithURL:[NSURL URLWithString:model.avatarPath] placeholderImage:[UIImage imageNamed:@"ip_shhyxx_def"]];
    self.merPhone = model.merPhone;
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
// 点击事件的触发
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    VIPmodel *model = _dataArray[indexPath.row];
    self.merPhone = model.merPhone;
    [self responseDeleData];
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
//        NSLog(@"Unhandled editing style! %d", editingStyle);
    }

}
- (void)responseDeleData
{
    
    NSDictionary *dic = @{ @"merchantPhone" : self.merPhone};
    
    [[HttpRequest sharedRequest]sendRequestWithMessage : nil path : @"merchant/remMember" param : dic succuss : ^(id result) {
        
        [_tableView reloadData];
        
    } fail:^{
       
    }];
}

#pragma http
- (void)DownloaddataWithPage:(int)page
{

    NSDictionary *dic = @{ @"currPage" : [NSString stringWithFormat:@"%d",page],
                           @"perPage"  : @"10",
                           @"isFocus"   : @"1",
                           @"merchantName" :@""
                           };
    [[HttpRequest sharedRequest]sendRequestWithMessage:@"" path:@"merchant/queryMer" param:dic succuss:^(id result) {
          NSLog(@"---7---%@",result);
       //************刷新*****************
        
        [_tableView footerEndRefreshing];
        if (isFresh)
        {
            currentPage=1;
            isFresh = NO;
            [_dataArray removeAllObjects];
            [_tableView headerEndRefreshing];
        }
        else
        {
            currentPage++;
            [_tableView footerEndRefreshing];
        }
        
        int totalPage = [result[@"totalPage"] intValue];
        if (currentPage<totalPage)
        {
            [_tableView setFooterHidden:NO];
            
        }
        else
        {
            [_tableView setFooterHidden:YES];
        }

        NSArray *dataArr = result[@"list"];
        
        if (![(NSNull*)dataArr isEqual:[NSNull null]]) {
            for (NSDictionary *dic in dataArr) {
                
                VIPmodel*model = [[VIPmodel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
                
            }
        }
              [_tableView reloadData];
    } fail:^{
        
         [_tableView headerEndRefreshing];
         [_tableView footerEndRefreshing];
        
    }];
    
}
@end
