//
//  ForgetPwdOfPhoneInputViewController.m
//  ZRwalletForMerchant
//
//  Created by 文彬 on 15/7/11.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "ForgetPwdOfPhoneInputViewController.h"
#import "ForgetPasswordViewController.h"

@interface ForgetPwdOfPhoneInputViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong)  UITextField *phoneTextField;
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation ForgetPwdOfPhoneInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"忘记密码";
    [self createTableView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dealTap)];
    [self.tableView addGestureRecognizer:tap];
}
-(void)dealTap
{
    
    [self.view endEditing:YES];
}
#pragma mark 创建设置列表
-(void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = RGBCOLOR(231, 231, 231);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    //***************footView****************************
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(15, 55, SCREEN_WIDTH-30, 40);
    [sendBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"ip_xgmm_su"] forState:UIControlStateNormal];
    sendBtn.layer.cornerRadius = 5;
    sendBtn.clipsToBounds = YES;
    [sendBtn setTitle:@" 下一步" forState:UIControlStateNormal];
    if (SCREEN_HEIGHT==667||SCREEN_HEIGHT==736) {
        sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
        
    }
    else
    {
        sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }

    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footView addSubview:sendBtn];
    self.tableView.tableFooterView = footView;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.clearButtonMode = UITextFieldViewModeAlways;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.clearButtonMode = UITextFieldViewModeNever;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
#pragma mark 实现UITableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    // 每一行显示的信息
    
    if (indexPath.section==0)
    {
        UIImageView *phoneImage = [[UIImageView alloc] init];
        phoneImage.image = [UIImage imageNamed:@"ip_shdl_usar"];
        [cell.contentView addSubview:phoneImage];
        [phoneImage makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.centerY.equalTo(cell.centerY);
            make.width.equalTo(@13);
            make.height.equalTo(@20);
        }];
        
        self.phoneTextField = [[UITextField alloc] init];
        self.phoneTextField.delegate = self;
        self.phoneTextField.placeholder = @"请输入注册时的手机号";
        self.phoneTextField.font = [UIFont systemFontOfSize:15];
        self.phoneTextField.borderStyle = UITextBorderStyleNone;
        [StaticTools addTopViewInTextFeild:self.phoneTextField withMessage:@"请输入手机号"];
        self.phoneTextField.keyboardType =  UIKeyboardTypePhonePad;
        [cell.contentView addSubview:self.phoneTextField];
        [self.phoneTextField makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(phoneImage.right).offset(10);
            make.centerY.equalTo(cell.centerY);
            make.right.equalTo(@-20);
            make.height.equalTo(@45);
        }];
        
        
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)buttonClickHandle:(UIButton*)btn
{
    if ([StaticTools isEmptyString:self.phoneTextField.text])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    else if(![StaticTools isMobileNumber:self.phoneTextField.text])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入一个正确的手机号"];
        return;
    }
    
    [self validataPhone];
}
#pragma mark HTTP
/**
 *  验证手机号  成功后默认发送一条验证码
 */
- (void)validataPhone
{
    [[HttpRequest sharedRequest] sendRequestWithMessage:nil path:@"forget/validateMerPhone" param:@{@"phoneNumber":self.phoneTextField.text} succuss:^(id result) {
        

        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:result delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
        ForgetPasswordViewController *forgetPwdController = [[ForgetPasswordViewController alloc]init];
        forgetPwdController.phoneNum = self.phoneTextField.text;
        [self.navigationController pushViewController:forgetPwdController animated:YES];
        
    } fail:nil];
    
 
}

@end
