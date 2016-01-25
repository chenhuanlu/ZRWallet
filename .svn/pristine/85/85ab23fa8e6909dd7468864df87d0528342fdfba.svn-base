//
//  TradeDetailViewController.m
//  ZRwalletForConsumer
//
//  Created by 陈焕鲁 on 15/7/10.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "TradeDetailViewController.h"
#import "TradeDetailCell.h"
@interface TradeDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArray;
    UITableView *_tableview;
}
@end

@implementation TradeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableview = [[UITableView alloc] init];
    _dataArray = [NSMutableArray array];
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.userInteractionEnabled = NO;
    _tableview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableview];
    
//    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
//    //footView.backgroundColor = [UIColor redColor];
//    _tableview.tableFooterView = footView;
    
    self.navigationItem.title = @"交易详情";
}
#pragma mark 实现UITableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    TradeDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TradeDetailCell" owner:self options:nil] firstObject];
    }
    if (indexPath.row==0) {
        UIImageView *cellImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_s2"]];
        [cell.contentView addSubview:cellImageView];
        [cellImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.centerY.equalTo(cell.centerY);
        }];
        UILabel *tradeSucessLabel = [[UILabel alloc] init];
        [tradeSucessLabel sizeToFit];
        tradeSucessLabel.text =@"交易成功";
        [cell.contentView addSubview:tradeSucessLabel];
        [tradeSucessLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cellImageView.right).offset(10);
            make.centerY.equalTo(cell.centerY);
            make.height.equalTo(@50);
            make.width.equalTo(@150);
        }];
    }
    if (indexPath.row==1)
        
    {
        cell.LeftTopLabel.text  = [NSString stringWithFormat:@"%@金额",self.tradeType];
        UILabel *BigLabel = [[UILabel alloc] init];
        //BigLabel.textAlignment = NSTextAlignmentCenter;
        BigLabel.text = @"-3000000.00";
        BigLabel.font = [UIFont boldSystemFontOfSize:35];
        [cell.contentView addSubview:BigLabel];
        [BigLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@-5);
            make.left.equalTo(cell.LeftTopLabel.right);
            make.width.equalTo(@300);
        }];
        
    }
    
    if (indexPath.row==2) {
        
        if ([self.typeId isEqualToString:@"1"]) {
            cell.LeftTopLabel.text= [NSString stringWithFormat:@"%@账户",self.tradeType];
            
            cell.RightTopLabel.text = @"文彬";
            
            cell.RightMidLabel.text =@"招商银行";
            
            cell.RightBottomLabel.text =@"62260798****133";
            
        }else{
            //消费页面重写
            cell.LeftTopLabel.text= [NSString stringWithFormat:@"%@账户",self.tradeType];
            
            cell.RightTopLabel.text = @"文+++彬";
            
            cell.RightMidLabel.text =@"招商+++银行";
            
            cell.RightBottomLabel.text =@"62260+++798****133";
        
        }
        
    }
    
    if (indexPath.row==3) {
        
        cell.LeftTopLabel.text = [NSString stringWithFormat:@"%@金额",self.tradeType];
        
        cell.LeftMidLabel.text = @"创建时间";
        
        cell.LeftBottomLabel.text = @"交 易 号";
        
        cell.RightTopLabel.text = [NSString stringWithFormat:@"%@",self.tradeType];;
        
        cell.RightMidLabel.text =@"2015-12-12 12:12";
        
        cell.RightBottomLabel.text = @"122314235364564746";
        
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 50;
    }
    return 100;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
