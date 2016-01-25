//
//  IncomeHistotyListViewController.m
//  ZRwalletForMerchant
//
//  Created by 文彬 on 15/7/11.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "IncomeHistotyListViewController.h"

@interface IncomeHistotyListViewController ()
{
    UIButton *titleBtn;
    UIButton *arrowBtn;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (strong, nonatomic) NSMutableArray *listDatas;
@property (strong, nonatomic) NSString *currentMonth;

@end

@implementation IncomeHistotyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.listDatas = [[NSMutableArray alloc]init];
    
    [self initPageControl];
    
    [self getIncomeList];
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
#pragma mark 功能函数
- (void)initPageControl
{
    self.currentMonth = [StaticTools getDateStrWithDate:[NSDate date] withCutStr:@"-" hasTime:NO];
    self.currentMonth = [self.currentMonth substringToIndex:7];
    
    self.listTableView.separatorColor = [UIColor clearColor];
    self.listTableView.backgroundColor = [UIColor clearColor];
    
    //------------------------导航栏标题按钮-------------------------------------------
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 110, 40)];
    
    titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake(0, 5, 90, 30);
    [titleBtn setTitle:self.currentMonth forState:UIControlStateNormal];
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
}

#pragma mark 按钮点击
- (void)buttonClickHandle:(UIButton*)button
{
    [arrowBtn setBackgroundImage:[UIImage imageNamed:@"billDown"] forState:UIControlStateNormal];
    [StaticTools showDateSelectWithIndexDate:titleBtn.titleLabel.text type:kDatePickerTypeNoDay clickOk:^(NSString *selectDateStr) {
        
        [arrowBtn setBackgroundImage:[UIImage imageNamed:@"billUp"] forState:UIControlStateNormal];
        
        NSString *current = [StaticTools getDateStrWithDate:[NSDate date] withCutStr:@"" hasTime:NO];
        current = [current substringToIndex:6];
        
        NSString *select = [selectDateStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
//        if ([select intValue]>[current intValue])
//        {
//            [SVProgressHUD showErrorWithStatus:@"查询月份不能晚于当前月份"];
//            return ;
//        }
  
        [titleBtn setTitle:selectDateStr forState:UIControlStateNormal];
        
        
        [self.listDatas removeAllObjects];
        [self.listTableView reloadData];
        [self getIncomeList];
        
    }];
}
#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listDatas.count;;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
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
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }

    NSDictionary *dict = self.listDatas[indexPath.section];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%@",titleBtn.titleLabel.text,dict.allKeys[0]];
    cell.detailTextLabel.text = dict.allValues[0];
    
    return cell;
}

#pragma mark HTTP
/**
 *  获取历史收益
 */
- (void)getIncomeList
{
    //历史收益
    NSDictionary *dic = @{ @"qValue" : [titleBtn.titleLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""],@"qType":@"2"};
    [[HttpRequest sharedRequest]sendRequestWithMessage:nil path:@"account/queryHistoryEarnings" param:dic succuss:^(id result) {
        

        NSDictionary *infoDict = (NSDictionary*)result;
        
        float total;
        for (int i=1;i<32;i++)
        {
            NSString *keys = [NSString stringWithFormat:@"%d",i];
            NSString *money = infoDict[keys];
            
            if ([money floatValue]>0)
            {
                total += [money floatValue];
                [self.listDatas addObject:@{keys:money}];
            }
        }
        
        self.totalLabel.text = [NSString stringWithFormat:@"%.2f",total];
        [self.listTableView reloadData];
        
    } fail:nil];
}

@end
