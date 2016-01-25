//
//  BankCardUploadViewController.m
//  ZRwalletForMerchant
//
//  Created by 文彬 on 15/7/21.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "BankCardUploadViewController.h"
#import "SetPayPasswordViewController.h"
#import "UIColor+NSString.h"
#import "AppNavView.h"

@interface BankCardUploadViewController ()
{
    NSArray *keys;
   
}
@property (nonatomic, strong) AppNavView *navView;

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@property (strong, nonatomic) NSMutableDictionary *infoDict;

@end

@implementation BankCardUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"银行卡绑定";
    [self makeNavView];
    addKeyBoardNotification = YES;//键盘通知打开
    keys = @[@{@"title":@"开 户 名:",@"key":@"accountName",@"placeHold":@"请输入姓名"},
             @{@"title":@"银行名称:",@"key":@"bankName",@"placeHold":@"请输入银行名称"},
             @{@"title":@"银行卡号:",@"key":@"cardNumber",@"placeHold":@"请输入银行卡号码"},
             @{@"title":@"身份证号:",@"key":@"idNumber",@"placeHold":@"请输入身份证号码"}];
    self.infoDict = [[NSMutableDictionary alloc]init];
    
    [self initPageControl];
    
}

-(void)makeNavView
{
    self.navView = [AppNavView new];
    self.navView.delegate = self;
    [self.view addSubview:self.navView];
    
    self.navView.titleLabel.text = @"银行卡绑定";
    self.navView.leftImgView.image = [UIImage imageNamed:@"whiteBack"];
//    [self.navView.navLeftBtn addTarget : self
//                                action : @selector(navLeftBtnDown)
//                      forControlEvents : UIControlEventTouchUpInside
//     ];
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.navView.size = CGSizeMake(SCREEN_WIDTH, Dev_NavigationBar_Height);


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
#pragma mark 功能函数
- (void)initPageControl
{
    //***************headview**************
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-10, 30)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.text = @"为保障收款能到账，请确保提交资料的正确性。";
    [headView addSubview:titleLabel];
    
    self.listTableView.tableHeaderView = headView;
    
  
    //***************footview**************
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(15, 5, SCREEN_WIDTH-30, 45);
    sendBtn.tag = 100;
    [sendBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"commitButton"] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footView addSubview:sendBtn];
    self.listTableView.tableFooterView = footView;
    //************键盘回收****************
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dealTap)];
    [self.listTableView addGestureRecognizer:tap];
}
-(void)dealTap
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.5 animations:^{
        self.listTableView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        
    }];
}
/**
 *  检查页面输入合法性
 *
 *  @return
 */
- (BOOL)checkPageInput
{
    for (int i=0; i<keys.count; i++)
    {
        NSDictionary *dict = keys[i];
        if ([StaticTools isEmptyString:self.infoDict[dict[@"key"]]])
        {
            [SVProgressHUD showErrorWithStatus:dict[@"placeHold"]];
            return NO;
        }
    }
    
    return YES;
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==103) {
        if(SCREEN_HEIGHT<568) //iphone 4s
        {
            
            [UIView animateWithDuration:0.5 animations:^{
                self.listTableView.contentOffset = CGPointMake(0, 60);
            } completion:nil];
            
        }
        //******************Tableview上移*****************
    }
    
}
#pragma mark 处理键盘遮挡问题

//#pragma mark 回收键盘
- (void)hideKeyboard
{
    
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.5 animations:^{
        self.listTableView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSDictionary *dict = keys[textField.tag-100];
    [self.infoDict setObject:textField.text forKey:dict[@"key"]];
    
}

#pragma mark 按钮点击
- (void)buttonClickHandle:(UIButton*)button
{
    [self.view endEditing:YES];
    
    if (button.tag==100)
    {
        if ([self checkPageInput])
        {
            //TODO  联行号
           [self.infoDict setObject:@"102100000030" forKey:@"bankNumber"];
            
            SetPayPasswordViewController *setPayPasswordController = [[SetPayPasswordViewController alloc]init];
            setPayPasswordController.infoDict = [NSMutableDictionary dictionaryWithDictionary:self.infoDict];
            [self.navigationController pushViewController:setPayPasswordController animated:YES];
            
        }
    }
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return keys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    //******************左侧标题文字*************************
    UILabel *leftLabel = [[UILabel alloc]init];
    leftLabel.font = [UIFont systemFontOfSize:16];
    [cell.contentView addSubview:leftLabel];
    [leftLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@10);
        make.width.equalTo(@150);
        make.height.equalTo(@25);
    }];
    
    
    NSDictionary *dict = keys[indexPath.row];
    leftLabel.text = dict[@"title"];
    
    if (indexPath.section==0)
    {
        //******************输入框*************************
        UITextField *inputTxtField = [[UITextField alloc]init];
        inputTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        inputTxtField.tag = 100+indexPath.row;
        if(indexPath.row==2)
        {
            inputTxtField.keyboardType = UIKeyboardTypeNumberPad;
        }
        inputTxtField.delegate = self;
        [cell.contentView addSubview:inputTxtField];
        [inputTxtField makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@90);
            make.top.equalTo(@8);
            make.right.equalTo(@-10);
            make.height.equalTo(@30);
        }];
        
        inputTxtField.placeholder = dict[@"placeHold"];
        
        inputTxtField.text = self.infoDict[dict[@"key"]];
        
    }
    
    return cell;
}
#pragma mark SCrollViewDelege
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark - navBtnClick
-(void)navLeftBtnDown
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
