//
//  NewsViewController.m
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/7/21.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

static CGFloat topBtnHeight;
static NSInteger tagNumber = 1000;

#import "NewsViewController.h"
#import "AppNavView.h"
#import "UIColor+NSString.h"
#import "MyPreferentialModel.h"
#import "NewsViewCell.h"
#import "AdvertDetailViewController.h"
#import "MJRefresh.h"

@interface NewsViewController ()
{
    int currentPage;
    BOOL isFresh; //是否为下拉刷新
}
@property (nonatomic, strong) AppNavView *navView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *infoDicArr;

@property (nonatomic, strong) UIButton *topBtn;
@property (nonatomic, strong) UIView *topBtnView;
@property (nonatomic, strong) UIView *topBtnLayerView;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.type = 1;
    [self makeNavView];
    [self makeView];
    //------------------------上拉下拉加载更多-------------------------------------------
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefeshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.tableView setFooterHidden:YES];
    
     [self getNewsListData:1];
}

-(void)getNewsListData:(int)page
{
    NSDictionary *dic = @{ @"currPage" :  @(page),
                           @"perPage"  :  @"10",
                           @"atype"    :  @(self.type)
                         };
  
    [[HttpRequest sharedRequest]sendRequestWithMessage:nil path:@"msg/getMsgList" param:dic succuss:^(id result) {
        
        if (page == 1) {
            
            [self.dataArray removeAllObjects];
        }
        if (isFresh)
        {
            currentPage = 1;
            isFresh = NO;
            [self.dataArray removeAllObjects];
            [self.tableView headerEndRefreshing];
        }
        else
        {
            currentPage++;
            [self.tableView footerEndRefreshing];
        }
        
        int totalPage = [result[@"totalPage"] intValue];
        
        if (currentPage < totalPage)
        {
            [self.tableView setFooterHidden:NO];
        }
        else
        {
            [self.tableView setFooterHidden:YES];
        }

        if (self.dataArray == nil) {
            self.dataArray = [NSMutableArray new];
        }
        
        NSArray *dataArr = result[@"list"];
        self.infoDicArr = dataArr;
        
        if (![(NSNull*)dataArr isEqual:[NSNull null]]) {
            for (NSDictionary *dic in dataArr) {
                MyPreferentialModel *preferentialModel = [[MyPreferentialModel alloc] init];
                [preferentialModel setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:preferentialModel];
            }
        }
        [self.tableView reloadData];

        
    } fail:^{
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }];

}
-(void)makeNavView
{
    self.navView = [AppNavView new];
    self.navView.delegate = self;
    [self.view addSubview:self.navView];
    self.navView.titleLabel.text = @"消息列表";
    
    self.navView.leftImgView.image = [UIImage imageNamed:@"whiteBack"];
    
}
-(void)makeView
{
    topBtnHeight = 50;
    self.topBtnView = [UIView new];
    self.topBtnView.backgroundColor = [UIColor whiteColor];
    [self.topBtnView addLine];
    self.topBtnView.userInteractionEnabled = YES;
    [self.view addSubview:self.topBtnView];
    
    self.topBtnLayerView = [UIView new];
    self.topBtnLayerView.backgroundColor = [UIColor clearColor];
    self.topBtnLayerView.layer.borderWidth = 1.2;
    self.topBtnLayerView.layer.borderColor = RGBCOLOR(206, 0, 33).CGColor;
    self.topBtnLayerView.layer.cornerRadius = 4.0;
    self.topBtnLayerView.layer.masksToBounds = YES;
    [self.topBtnView addSubview:self.topBtnLayerView];
    
    NSArray *titleArray = @[@"商户活动",@"系统活动"];
    for (int i = 0 ; i < titleArray.count; i++) {
        self.topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.topBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        
        self.topBtn.layer.cornerRadius = 4.0;
        self.topBtn.layer.masksToBounds = YES;
        [self.topBtn setTitleColor: RGBCOLOR(206, 0, 33) forState:UIControlStateNormal];
        [self.topBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateSelected];
        [self.topBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        if(i == 0)
        {
            self.topBtn.selected = YES;
            self.topBtn.backgroundColor =  RGBCOLOR(206, 0, 33);
        }
        [self.topBtn addTarget : self
                        action : @selector(topBtnDown:)
              forControlEvents : UIControlEventTouchUpInside];
        self.topBtn.tag = tagNumber + i;
        [self.topBtnView addSubview:self.topBtn];
    }
    
    self.tableView = [UITableView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = [UIColor colorWithString:@"#f0f0f0"];
    [self.view addSubview:self.tableView];
}
-(void)topBtnDown:(UIButton *)btn
{
    NSInteger index = btn.tag - tagNumber + 1;
    for (int i = 0 ; i < 2; i++) {
        UIButton *tempBtn = (UIButton *)[self.view viewWithTag:tagNumber + i];
        if(tempBtn == btn)
        {
            tempBtn.selected = YES;
            tempBtn.backgroundColor =  RGBCOLOR(206, 0, 33);
        }
        else
        {
            tempBtn.selected = NO;
            tempBtn.backgroundColor = [UIColor clearColor];
        }
    }
    self.type = index;
    
    [self getNewsListData:1];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.navView.size = CGSizeMake(SCREEN_WIDTH, Dev_NavigationBar_Height);
    
    self.topBtnView.size = CGSizeMake(SCREEN_WIDTH, topBtnHeight);
    self.topBtnView.viewTop = Dev_NavigationBar_Height;
    
    self.topBtnLayerView.size = CGSizeMake(SCREEN_WIDTH - 20, topBtnHeight - 20);
    self.topBtnLayerView.viewLeft = 10;
    self.topBtnLayerView.viewTop = 10;
    
    for ( int i = 0; i < 2; i++) {
        self.topBtn = (UIButton *)[self.view viewWithTag:tagNumber + i];
        
        self.topBtn.size = CGSizeMake((SCREEN_WIDTH - 20)/2, topBtnHeight - 20);
        self.topBtn.viewTop = 10;
        self.topBtn.viewLeft = 10 + i*(SCREEN_WIDTH - 20)/2;
    }

    self.tableView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - Dev_NavigationBar_Height - topBtnHeight) ;
    self.tableView.viewTop = self.topBtnView.viewBottom + 1;

}
#pragma mark refresh

- (void)headerRefeshing
{
    isFresh = YES;
    [self getNewsListData:1];
}

- (void)footerRereshing
{
    [self getNewsListData:currentPage + 1];
}

#pragma mark - tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellHeight + 65;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"iden";
    NewsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[NewsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    for (id temp in cell.contentView.subviews) {
        [temp removeFromSuperview];
    }
    
    if (self.dataArray.count > 0) {

        MyPreferentialModel *model = self.dataArray[indexPath.row];
        
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:
                             [model.publishDate doubleValue]/1000];

        NSString *publishTimeStr = [dateFormatter stringFromDate:publishDate];
        cell.dateLabel.text = publishTimeStr;
        
        cell.newsLabel.text = model.content;
        cell.newsLabel.numberOfLines = 0;
        cell.newsLabel.size = [self heightWithLabel : cell.newsLabel.text
                                       fontWithFont : [UIFont systemFontOfSize:14]];
        cell.newsLabel.viewLeft = 35;
        cell.newsLabel.viewTop = 35;
        self.cellHeight = [self heightWithLabel : cell.newsLabel.text
                                   fontWithFont : [UIFont systemFontOfSize:14]].height ;
        
        cell.titleLabel.text = model.title;
        //0 未读  1已读
        if ([model.read isEqualToString:@"0"]) {
            cell.readImgView.image = [UIImage imageNamed:@"ip_gg_an"];
            
        }if ([model.read isEqualToString:@"1"]) {
            cell.readImgView.image = nil;

        }
        
    }
    
    return cell;
}
-(CGSize)heightWithLabel:(NSString *)text fontWithFont:(UIFont *) font
{
    
    NSDictionary *fontDic = @{ NSFontAttributeName : font };
    
    CGSize labelSize = [text
                        boundingRectWithSize : CGSizeMake(SCREEN_WIDTH - 50, MAXFLOAT)
                        options : NSStringDrawingUsesLineFragmentOrigin
                        attributes : fontDic
                        context : nil
                        ].size;
    
    return labelSize;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdvertDetailViewController *advertVC = [AdvertDetailViewController new];
    advertVC.infoDict = self.infoDicArr[indexPath.row];
    [self.navigationController pushViewController:advertVC animated:YES];
    
    MyPreferentialModel *model = self.dataArray[indexPath.row];
    model.read = @"1";
    [self.tableView reloadData];
    
    [[HttpRequest sharedRequest]sendRequestWithMessage:@"" path:@"msg/markAsRead" param:@{@"msgId":model.id} succuss:^(id result) {
        
    } fail:nil];
    
}
#pragma mark - navBtnClick
-(void)navLeftBtnDown
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
