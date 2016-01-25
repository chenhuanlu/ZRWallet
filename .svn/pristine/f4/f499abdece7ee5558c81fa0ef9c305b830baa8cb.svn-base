//
//  SecurityCheckoutViewController.m
//  ZRwalletForConsumer
//
//  Created by 陈焕鲁 on 15/7/12.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "SecurityCheckoutViewController.h"
#import "UIColor+NSString.h"
#import "NextViewController.h"
@interface SecurityCheckoutViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic,strong)UIButton *NextButton;
@property (nonatomic,strong)UITableView *listTableView;
@property (nonatomic,strong)UITextField *textfield1;
@property (nonatomic,strong)UITextField *textfield2;
@property (nonatomic,strong)UILabel *leftLabel;
@end

@implementation SecurityCheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title = @"身份信息验证";
    self.view.backgroundColor = RGBCOLOR(236, 236, 236);
    [self createUI];
    addKeyBoardNotification = YES;
   
}
-(void)createUI
{ //*****************footView*********************************
    

    self.listTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    [self.view addSubview:self.listTableView];
    
    self.listTableView.backgroundColor = [UIColor clearColor];//将tableView设置成透明色
        //*****************点击收键盘*********************************
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [self.listTableView addGestureRecognizer:tapGuesture];
    
    //*****************footView*********************************
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    
    self.NextButton= [UIButton buttonWithType:UIButtonTypeCustom];
    self.NextButton.frame = CGRectMake(15, 5, SCREEN_WIDTH-30, (SCREEN_WIDTH/8));
    self.NextButton.layer.cornerRadius = 5;
    self.NextButton.clipsToBounds = YES;
    [self.NextButton setTitle:@"下一步" forState:UIControlStateNormal];
    if (SCREEN_HEIGHT==667||SCREEN_HEIGHT==736) {
        self.NextButton.titleLabel.font = [UIFont boldSystemFontOfSize:22];
        
    }
    else
    {
        self.NextButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }

    [self.NextButton setBackgroundImage:[UIImage imageNamed:@"ip_anjy_ob"] forState:UIControlStateNormal];
    [footView addSubview:self.NextButton];
    [self.NextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.listTableView.tableFooterView = footView;// 添加断尾
   
}
-(void)nextClick
{
    
    if ([self.textfield1.text isEqualToString:@""]&&![self.textfield2.text isEqualToString:@""]
        ) {
        [SVProgressHUD showErrorWithStatus:@"请输入身份证号"];
        return;
        
    }
    else if (![self.textfield1.text isEqualToString:@""]&&[self.textfield2.text isEqualToString:@""])
    {
         [SVProgressHUD showErrorWithStatus:@"请输入银行卡号"];
        return;
    }
    else if([self.textfield1.text isEqualToString:@""]&&[self.textfield2.text isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入身份证号和银行卡号"];
        return;
    }
    //下一步
    NSDictionary *dict = @{@"idNumber":self.textfield1.text,
                           @"bankCardNumber":self.textfield2.text};
    [[HttpRequest sharedRequest] sendRequestWithMessage:nil path:@"getPayPasswordSms" param:dict succuss:^(id result) {
        NextViewController *nvc = [[NextViewController alloc] init];
        nvc.textfield11text = self.textfield1.text;
        nvc.textfield22text = self.textfield2.text;
        [self.navigationController pushViewController:nvc animated:YES];
    } fail:^{
        //[SVProgressHUD showErrorWithStatus:@"填写信息不一致"];
    }];

}
#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return kCellHeight;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 10;         //设置tableView的尾部视图的高度
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 30;

    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        headerView.backgroundColor = RGBCOLOR(232, 231, 231);
        UILabel *footLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH, 20)];
        footLabel.font = [UIFont systemFontOfSize:13];
        footLabel.text = @"请填写与注册信息一致的身份证号码和银行卡号";
        footLabel.textColor = [UIColor grayColor];
        [headerView addSubview:footLabel];
        [footLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.top.equalTo(headerView.top);
            make.width.equalTo(@(SCREEN_WIDTH));
            make.height.equalTo(@30);
        }];
        
        return headerView;
        
    }
    else
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        return view;
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
    //**************** 去掉点击选中效果**************************
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    self.leftLabel = [[UILabel alloc]init];
    self.leftLabel.font = [UIFont systemFontOfSize:16];
    [cell.contentView addSubview:self.leftLabel];
    [self.leftLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(cell.contentView.centerY);
        make.width.equalTo(@80);
        make.height.equalTo(@40);
    }];
    
    //****************第一个输入框**********************
   
        if (indexPath.section==0)
        {
            self.textfield1 = [[UITextField alloc]init];
            self.textfield1.returnKeyType = UIReturnKeyDone;
            self.textfield1.clearButtonMode = UITextFieldViewModeAlways;
            self.textfield1.keyboardType = UIKeyboardTypeASCIICapable;
            self.textfield1.autocapitalizationType = UITextAutocapitalizationTypeNone;// 自动大写去掉
            [cell.contentView addSubview:self.textfield1];
            self.textfield1.delegate = self;
            [self.textfield1 makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@90);
                make.centerY.equalTo(cell.centerY);
                make.width.equalTo(@200);
                make.height.equalTo(@45);
            }];
            self.textfield1.clearButtonMode = YES;
            self.textfield1.placeholder = @"请输入身份证号码";
            self.leftLabel.text = @"身份证号:";
        }
        
        if (indexPath.section==1)
        {
            self.textfield2 = [[UITextField alloc]init];
            self.textfield2.clearButtonMode = UITextFieldViewModeAlways;
            self.textfield2.returnKeyType = UIReturnKeyDone;
            self.textfield2.keyboardType = UIKeyboardTypeASCIICapable;
            self.textfield2.autocapitalizationType = UITextAutocapitalizationTypeNone;// 自动大写去掉
            [cell.contentView addSubview:self.textfield2];
            self.textfield2.delegate = self;
            [self.textfield2 makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@90);
                make.centerY.equalTo(cell.centerY);
                //make.right.equalTo(@-100);
                make.width.equalTo(@200);
                make.height.equalTo(@45);
            }];
            self.textfield2.placeholder = @"请输入银行卡号";
             self.self.textfield2.clearButtonMode = YES;
            
            self.leftLabel.text = @"银行卡号:";
        }
    
    
    return cell;
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    if (![self.textfield1.text isEqualToString:@""]&&![self.textfield3.text isEqualToString:@""]
//        ) {
//        [self.NextButton setBackgroundImage:[UIImage imageNamed:@"ip_anjy_ob"] forState:UIControlStateNormal];
//    }
//    else
//    {
//        [self.NextButton setBackgroundImage:[UIImage imageNamed:@"ip_anjy_co_n-1"] forState:UIControlStateNormal];
//    }
}

#pragma mark 回收键盘
- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
