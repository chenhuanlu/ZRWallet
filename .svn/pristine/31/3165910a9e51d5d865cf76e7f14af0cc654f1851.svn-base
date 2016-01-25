//
//  MyManageViewController.m
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/7/1.
//  Copyright (c) 2015年 文彬. All rights reserved.
//
static NSInteger tagNumber = 1000;
static CGFloat topBtnHeight;

#import "MyManageViewController.h"
#import "ProjectDetailViewController.h"
#import "UIColor+NSString.h"
#import "MyManageCell.h"
#import "MyPreferentialModel.h"
#import "AppNavView.h"
#import "MJRefresh.h"

@interface MyManageViewController ()
{
    int currentPage;
    BOOL isFresh;
}
@property (nonatomic, strong) AppNavView *navView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *topBtn;
@property (nonatomic, strong) UIView *topBtnView;
@property (nonatomic, strong) UIView *topBtnLayerView;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) CGFloat titleLabelHeight;

@end

@implementation MyManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    self.type = 0;
    [self makeNavView];
    [self makeView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //------------------------上拉下拉加载更多-------------------------------------------
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefeshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.tableView setFooterHidden:YES];
    
    [self responseData : 1];

}
- (void)responseData:(int)page
{
    
    NSDictionary *dic  = @{ @"currPage"   : @(page),
                            @"perPage"    : @"10",
                            @"type"       : @(self.type)
                            };
    
    [[HttpRequest sharedRequest]sendRequestWithMessage : nil path : @"invest/queryMyInvestHistory" param : dic succuss : ^(id result) {
        
        if (page == 1) {
            
            [self.dataArray removeAllObjects];
        }
        if (isFresh)
        {
            currentPage=1;
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
        if (currentPage<totalPage)
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
    
    self.navView.titleLabel.text = @"我的理财";
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
    
    NSArray *titleArray = @[@"正在投标",@"已完成"];
    for (int i = 0 ; i < 2; i++) {
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
                        action : @selector(btnDown:)
              forControlEvents : UIControlEventTouchUpInside];
        self.topBtn.tag = tagNumber + i;
        [self.topBtnView addSubview:self.topBtn];
    }
    self.tableView = [UITableView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
}
-(void)btnDown:(UIButton *)btn
{
    NSInteger index = btn.tag - tagNumber;
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
    [self responseData : 1];
    
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
    self.tableView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - Dev_NavigationBar_Height - topBtnHeight - 10) ;
    self.tableView.viewTop = self.topBtnView.viewBottom + 1;
      
}
#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"iden";
    MyManageCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[MyManageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    for (id temp in cell.contentView.subviews) {
        [temp removeFromSuperview];
    }
    
    if (self.dataArray.count > 0) {
        MyPreferentialModel *model = self.dataArray[indexPath.row];
        
        NSString *frontStr = [model.exprieDate substringToIndex:8];
        NSMutableString *dateStr = [NSMutableString stringWithString:frontStr];
    
        [dateStr insertString:@"-" atIndex:4];
        [dateStr insertString:@"-" atIndex:7];

        cell.dateLabel.text = [NSString stringWithFormat:@"到期时间:  %@",dateStr];
        cell.investLabel.text = [NSString stringWithFormat:@"投标金额:  %@元",model.amount];
        cell.rateLabel.text =   [NSString stringWithFormat:@"年利率:       %@%%",model.roa];
        cell.incomLabel.text =  [NSString stringWithFormat:@"预计收益:     %.2f元",[model.earnings floatValue]];
        
        cell.titleLabel.text = model.projectName;
        
        cell.titleLabel.size =   [self heightWithLabel : cell.titleLabel.text
                                          fontWithFont : [UIFont systemFontOfSize:14]];
        self.titleLabelHeight = cell.titleLabel.size.height;

    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyPreferentialModel *model = self.dataArray[indexPath.row];
    NSString *titleStr = model.projectName;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        return  SCREEN_WIDTH/4 + [self heightWithLabel:titleStr
                         fontWithFont:[UIFont systemFontOfSize: 14]].height;
    }else
    {
        return SCREEN_WIDTH/4 + self.titleLabelHeight;

    }
}

-(CGSize)heightWithLabel:(NSString *)text fontWithFont:(UIFont *) font
{
    
    NSDictionary *fontDic = @{ NSFontAttributeName : font };
    
    CGSize labelSize = [text
                        boundingRectWithSize : CGSizeMake(SCREEN_WIDTH - 60, MAXFLOAT)
                        options : NSStringDrawingUsesLineFragmentOrigin
                        attributes : fontDic
                        context : nil
                        ].size;
    
    return labelSize;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyPreferentialModel *model = self.dataArray[indexPath.row];
    
    [[HttpRequest sharedRequest]sendRequestWithMessage : nil path : @"p2c/getProject" param : @{@"investOrderId":model.investOrderId } succuss : ^(id result) {

        MyPreferentialModel *detailModel = [MyPreferentialModel new];
        [detailModel setValuesForKeysWithDictionary:result];
        
        ProjectDetailViewController *projectVC = [ProjectDetailViewController new];
        projectVC.projectName = detailModel.projectName;
        projectVC.paybackTime = detailModel.paybackTime;
        projectVC.paybackType = detailModel.paybackType;
        projectVC.raisingVolume = detailModel.raisingVolume;
        projectVC.yearRoa = detailModel.yearRoa;
        projectVC.amonut = detailModel.amonut;
        projectVC.projectId = detailModel.projectId;
        projectVC.day = [detailModel.remainDays integerValue];
        projectVC.projectDesp = result[@"projectDesp"];
        projectVC.type = self.type;
        [self.navigationController pushViewController:projectVC animated:YES];

        
    } fail:^{
       
    }];

}
#pragma mark refresh
- (void)headerRefeshing
{
    isFresh = YES;
    [self responseData : 1];
}

- (void)footerRereshing
{
    [self responseData : currentPage + 1];
}

#pragma mark - navBtnClick
-(void)navLeftBtnDown
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
