//
//  BringMoneyViewController.m
//  ZRwalletForConsumer
//
//  Created by 陈焕鲁 on 15/7/6.
//  Copyright (c) 2015年 文彬. All rights reserved.
//
static NSInteger amountTextFieldTag = 7000;
#import "BringMoneyViewController.h"
#import "UIColor+NSString.h"
#import "SecurityTool.h"

#define  Num @"0123456789."
#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
@interface BringMoneyViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    NSString *moneyStr;
}

@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, weak) IBOutlet UITableView *listTableView;

@end
@implementation BringMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    addKeyBoardNotification = YES;
    self.navigationItem.title = @"提现";
    [self createUI];
}
-(void)createUI
{
    
    //*****************footView*********************************
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    
    UIButton *footBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    footBtn.frame = CGRectMake(15, 5, SCREEN_WIDTH-30, 40);
    footBtn.layer.cornerRadius = 5;
    footBtn.clipsToBounds = YES;
    [footBtn setTitle:@"提现" forState:UIControlStateNormal];
    [footBtn setBackgroundImage:[UIImage imageNamed:@"commitButton"] forState:UIControlStateNormal];
    [footView addSubview:footBtn];
    [footBtn addTarget:self action:@selector(CommitClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.listTableView.tableFooterView = footView;// 添加断尾
    
    self.listTableView.backgroundColor = [UIColor clearColor];//将tableView设置成透明色
    
    
    //*****************点击收键盘*********************************
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [self.listTableView addGestureRecognizer:tapGuesture];
    
    
}
#pragma mark 功能函数
- (void)hideKeyboard
{
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.listTableView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        
    }];
}
-(void)CommitClick:(UIButton *)commitBtn
{
    [self.view endEditing:YES];
    
    if ([StaticTools isEmptyString:moneyStr])
    {
        [SVProgressHUD showErrorWithStatus:@"提现金额不能为空"];
        return;
    }
    UITextField *tempTextField = (UITextField *)[self.view viewWithTag:amountTextFieldTag];
    if ([self.cashBalance integerValue] < [tempTextField.text integerValue])
    {
        [SVProgressHUD showErrorWithStatus:@"账户余额不足"];
        return;
    }
    else
    {
        if ([moneyStr integerValue] < 100)
        {
            
            [SVProgressHUD showErrorWithStatus:@"可提现金额不能小于100元"];
            return;
        }
    }
    

    [StaticTools showPayPasswordWithMoney:@"0" ClickOk:^(id password) {
        
        
        [[HttpRequest sharedRequest] sendRequestWithMessage:nil path:@"account/withdraw" param:@{@"payPassword":[SecurityTool md5:password],@"amount":moneyStr} succuss:^(id result) {

            
            [SVProgressHUD showSuccessWithStatus:@"提现成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        } fail:nil];
        
        
        
    }];


    
}
////#pragma mark 清除余额密码自动清空
//- (BOOL)textFieldShouldClear:(UITextField *)textField;
//{
//    inputTextField.text = @"";
//    return YES;
//}

#pragma mark 处理键盘遮挡问题
//键盘显示时调用
- (void)keyBoardShowWithHeight:(float)height
{
   if(SCREEN_HEIGHT<568) //iphone 4s
   {
    
       [UIView animateWithDuration:0.5 animations:^{
           self.listTableView.contentOffset = CGPointMake(0, 100);
       } completion:nil];
       
   }
    //******************Tableview上移*****************
}

//输入框开始编辑
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{

    moneyStr = textField.text;

}

#pragma mark 回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return section==0?1:1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    return kCellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return 30;
    }
    return 30;         //设置tableView的尾部视图的高度
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==0) {
        
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        
        UILabel *footLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH, 20)];
        footLabel.font = [UIFont systemFontOfSize:13];
        footLabel.text = @"账户可用余额";
        footLabel.textColor = [UIColor grayColor];
        [footView addSubview:footLabel];
        return footView;
    }
    
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    //****************左侧标题**********************
    UILabel *leftLabel = [[UILabel alloc]init];
    leftLabel.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:leftLabel];
    [leftLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(cell.contentView.centerY);
        make.width.equalTo(@120);
        make.height.equalTo(@30);
    }];
    
    //****************右侧输入框**********************
    UITextField *inputTextField = [[UITextField alloc]init];
    inputTextField.tag = amountTextFieldTag;
    inputTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;// 自动大写去掉
    [cell.contentView addSubview:inputTextField];
    [StaticTools addTopViewInTextFeild:inputTextField withMessage:@"提现金额"];
    inputTextField.delegate = self;
    [inputTextField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLabel.right).offset(10);
        make.centerY.equalTo(cell.contentView.centerY);
        make.right.equalTo(@-10);
        make.height.equalTo(@35);
    }];
    
    if (indexPath.section==0) {
        leftLabel.text = @"可提现金额（元）";
        inputTextField.text = self.cashBalance;
        inputTextField.textColor =[UIColor redColor];
        inputTextField.enabled = NO;//不可点击
       
    }
    else if(indexPath.section==1)
    {
        // 一键清理
        inputTextField.clearButtonMode = YES;
        if (indexPath.row==0) {
            leftLabel.text = @"提现金额（元）";
            inputTextField.placeholder = @"请输入提现金额";
            inputTextField.keyboardType = UIKeyboardTypeNumberPad;
            
            //设置键盘类型
            //inputTextField.keyboardType = UIKeyboardTypeASCIICapable;
        }
    }
    
    return cell;
}

#pragma mark   uiscrollviewdelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


@end
