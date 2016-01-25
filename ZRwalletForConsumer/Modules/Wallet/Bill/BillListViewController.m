//
//  BillListViewController.m
//  RongXinForIphone
//
//  Created by 文彬 on 15/6/24.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "BillListViewController.h"
#import "BillTableViewCell.h"
#import "MJRefresh.h"
#import "BillDetailViewController.h"
#import "UIImageView+WebCache.h"

@interface BillListViewController ()
{
    NSArray *types;
    NSInteger billType; //0:所有记录 1:入账记录 2：出账记录
    UIButton *titleBtn;
    UIButton *arrowBtn;
    
    int currentPage;
    BOOL isFresh; //是否为下拉刷新
}
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@property (strong, nonatomic) UITableView *billTypeTableView;
@property (strong, nonatomic) UIView *typeView;
@property (strong, nonatomic) NSMutableArray *listDatas;

@end

@implementation BillListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    types = @[@"所有记录",@"入账记录",@"出账记录"];
    billType = 0;
    currentPage=0;
    self.listDatas  = [[NSMutableArray alloc]init];
    
    [self initPageControl];
    
//    [self getBillListWithPage:1];
    [self.listTableView headerBeginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 功能函数
- (void)initPageControl
{
    
    //------------------------上拉下拉加载更多-------------------------------------------
    [self.listTableView addHeaderWithTarget:self action:@selector(headerRefeshing)];
    [self.listTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    
     //------------------------导航栏标题按钮-------------------------------------------
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 110, 40)];
    
    titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake(0, 5, 90, 30);
    [titleBtn setTitle:@"所有记录" forState:UIControlStateNormal];
    [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    titleBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [titleBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:titleBtn];
    
    arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [arrowBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    arrowBtn.backgroundColor = [UIColor clearColor];
    [arrowBtn setBackgroundImage:[UIImage imageNamed:@"billUp"] forState:UIControlStateNormal];
    arrowBtn.frame = CGRectMake(85, 7, 25, 25);
    [titleView addSubview:arrowBtn];
    self.navigationItem.titleView = titleView;
    
    //------------------------流水类型选择-------------------------------------------
    self.typeView = [[UIView alloc]init];
    self.typeView.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
    self.typeView.alpha = 0;
    [self.view addSubview:self.typeView];
    [self.typeView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.top.equalTo(self.view.top);
        make.bottom.equalTo(self.view.bottom);
    }];
    
    UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [downBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self.typeView addSubview:downBtn];
    [downBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    self.billTypeTableView = [[UITableView alloc]init];
    self.billTypeTableView.delegate = self;
    self.billTypeTableView.dataSource = self;
    self.billTypeTableView.scrollEnabled = NO;
    [self.typeView addSubview:self.billTypeTableView];
    [self.billTypeTableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@-150);
        make.right.equalTo(@0);
        make.height.equalTo(@150);
    }];
}


/**
 *  弹出流水类型选择页面
 */
- (void)showBillTypeSelect
{
    [self.billTypeTableView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.typeView.alpha = 1;
        [self.view layoutIfNeeded];
        [arrowBtn setBackgroundImage:[UIImage imageNamed:@"billDown"] forState:UIControlStateNormal];
    }];
}

/**
 *  收起流水类型选择页面
 */
- (void)hideBillTypeSelect
{
    [self.billTypeTableView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@-150);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.typeView.alpha = 0;
        [self.view layoutIfNeeded];
         [arrowBtn setBackgroundImage:[UIImage imageNamed:@"billUp"] forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [titleBtn setTitle:types[billType] forState:UIControlStateNormal];
    }];
}

/**
 *  下拉刷新
 */
- (void)headerRefeshing
{
    isFresh = YES;
    [self getBillListWithPage:1];
}

/**
 *  上拉加载更多
 */
- (void)footerRereshing
{

     [self getBillListWithPage:currentPage+ 1];
}

#pragma mark 按钮点击事件
- (void)buttonClickHandle:(UIButton*)buton
{
    if (buton==titleBtn||buton==arrowBtn)
    {
        if (self.typeView.alpha==1)
        {
            [self hideBillTypeSelect];
        }
        else
        {
            [self showBillTypeSelect];
        }
    }
    else
    {
        [self hideBillTypeSelect];
    }
  
    
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (tableView==self.billTypeTableView)
    {
        return 1;
    }
    return self.listDatas.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.billTypeTableView)
    {
        return 3;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.billTypeTableView)
    {
        return 50;
    }
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.billTypeTableView)
    {
        
        
        static NSString *cellId = @"celliden";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        for (UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        
        cell.textLabel.text = types[indexPath.row];
        if (indexPath.row==billType)
        {
            UIImageView *rightImg = [[UIImageView alloc]init];
            rightImg.backgroundColor = [UIColor clearColor];
            rightImg.image = [UIImage imageNamed:@"redCheck"];
            [cell.contentView addSubview:rightImg];
            [rightImg makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@10);
                make.right.equalTo(@-15);
                make.width.equalTo(@30);
                make.height.equalTo(@30);
            }];
        }
     
        return cell;
    }

    
    
    static NSString *cellIdentifier = @"cellIdentifier";
    BillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BillTableViewCell" owner:self options:nil] objectAtIndex:0];
    }

    cell.operationTypeLabel.adjustsFontSizeToFitWidth = YES;
    
    NSDictionary *dict = self.listDatas[indexPath.section];
   
    cell.moneyLabel.text =[NSString stringWithFormat:@"%@元",dict[@"changeAmount"]] ;
    cell.timeLabel.text =  dict[@"operationDate"];
    UIImage *placeHold = [UIImage imageNamed:@"ip_shhyxx_def"];
    //1：充值 2：信用消费 3：投资 4：收益 5：提现   6投资到期归还本金  9：余额消费 10：余额、授信混合消费
    if ([dict[@"operationType"] isEqualToString:@"1"])
    {
        cell.operationTypeLabel.text = @"充值";
        cell.headImgView.image = [UIImage imageNamed:@"ip_shls_cz"];
    }
   else if ([dict[@"operationType"] isEqualToString:@"2"]|| //消费--信用额付款
            [dict[@"operationType"] isEqualToString:@"9"]|| //@"消费--账户余额付款";
            [dict[@"operationType"] isEqualToString:@"10"]) // @"消费--账户余额加信用额付款";
    {
        cell.operationTypeLabel.text = [NSString stringWithFormat:@"消费--%@",dict[@"merName"]];
        [cell.headImgView sd_setRoundImageWithURL:[NSURL URLWithString:dict[@"merAvatar"]] placeholderImage:placeHold];
    }
   else if ([dict[@"operationType"] isEqualToString:@"3"])
   {
       cell.operationTypeLabel.text = @"理财投资";
      cell.headImgView.image = [UIImage imageNamed:@"ip_shls_tzlc"];
   }
   else if ([dict[@"operationType"] isEqualToString:@"4"])
   {
       cell.operationTypeLabel.text = @"理财收益";
       cell.headImgView.image = [UIImage imageNamed:@"ip_shls_ghbj"];
   }
   else if ([dict[@"operationType"] isEqualToString:@"5"])
   {
       cell.operationTypeLabel.text = @"提现";
       cell.headImgView.image = [UIImage imageNamed:@"ip_shls_tx"];
   }
   else if ([dict[@"operationType"] isEqualToString:@"6"])
   {
       cell.operationTypeLabel.text = @"投资到期，归还本金";
       cell.headImgView.image = [UIImage imageNamed:@"ip_shls_ghbj"];
   }
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView==self.billTypeTableView)
    {
        [self hideBillTypeSelect];
        if (billType==indexPath.row)
        {
            return;
        }
        
        billType = indexPath.row;
        [self.billTypeTableView reloadData];
        
        [self.listDatas removeAllObjects];
        [self.listTableView reloadData];
        currentPage =0;
//        [self getBillListWithPage:1];
        [self.listTableView headerBeginRefreshing];
        
        
    }
    else if(tableView==self.listTableView)
    {
        NSDictionary *dict = self.listDatas[indexPath.section];
        BillDetailViewController *detailController = [[BillDetailViewController alloc]init];
        detailController.hidesBottomBarWhenPushed = YES;
        
        detailController.orderType = dict[@"operationType"] ;
        detailController.orderId = dict[@"orderId"];
      
        [self.navigationController pushViewController:detailController animated:YES];
    }
    
}

#pragma mark HTTP
/**
 *  获取流水列表
 *
 *  @param page
 */
- (void)getBillListWithPage:(int)page
{
    NSString *type;
    if (billType==0)
    {
        type = @"all";
    }
    else if(billType==1)
    {
        type = @"in";
    }
    else if(billType==2)
    {
        type = @"out";
    }
    
    NSDictionary *dict = @{@"transType":type,
                           @"currPage":[NSString stringWithFormat:@"%d",page],
                           @"perPage":@"10"};
    
    
    [[HttpRequest sharedRequest] sendRequestWithMessage:@"" path:@"account/queryTrans" param:dict succuss:^(id result) {
        
        [self.listTableView footerEndRefreshing];
        [self.listTableView headerEndRefreshing];
        
        if (isFresh)
        {
            currentPage=1;
            isFresh = NO;
            [self.listDatas removeAllObjects];
        }
        else
        {
            currentPage++;
            
        }
        
        int totalPage = [result[@"totalPage"] intValue];
        if (currentPage<totalPage)
        {
            [self.listTableView setFooterHidden:NO];
        }
        else
        {
            [self.listTableView setFooterHidden:YES];
        }
        
        [self.listDatas addObjectsFromArray:result[@"list"]];
        [self.listTableView reloadData];
        
        
    } fail:^{
        
        [self.listTableView headerEndRefreshing];
        [self.listTableView footerEndRefreshing];
    }];
    
}
@end
