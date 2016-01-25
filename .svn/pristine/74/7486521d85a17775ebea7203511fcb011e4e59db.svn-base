//
//  NextViewController.m
//  ZRwalletForConsumer
//
//  Created by 陈焕鲁 on 15/7/25.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "NextViewController.h"
#import "UIColor+NSString.h"
#import "SecurityTool.h"
#import "SecurityCheckoutViewController.h"
@interface NextViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIButton *GainCodeButton;
    NSTimer *CountDowntimer;
    int InitialValue;//计时器初始值

}
@property (nonatomic,strong) UITableView *listTableView;
@property (nonatomic,strong) UITextField *TextField;
//@property (nonatomic,strong) UILabel *leftLabel;
@property (nonatomic,strong) UIButton *registerButton;
@property (nonatomic,strong) UIButton *sureBtn;
@property (nonatomic,strong) UILabel *leftLabel;
@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    addKeyBoardNotification = YES;//键盘通知打开
    self.navigationItem.title  =@"重置支付密码";
    self.view.backgroundColor = RGBCOLOR(236, 236, 236);
    [self createTableView];
}
-(void)createTableView
{
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
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.frame = CGRectMake(15, 5, SCREEN_WIDTH-30, (SCREEN_WIDTH/8));
    _sureBtn.layer.cornerRadius = 5;
    _sureBtn.clipsToBounds = YES;
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    if (SCREEN_HEIGHT==667||SCREEN_HEIGHT==736) {
        _sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
        
    }
    else
    {
        _sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    [_sureBtn setBackgroundImage:[UIImage imageNamed:@"ip_anjy_ob"] forState:UIControlStateNormal];
    [footView addSubview:_sureBtn];
    [_sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.listTableView.tableFooterView = footView;// 添加断尾

}
-(void)sureClick
{
    
    //提交密码
    if ([self checkPageInput])
    {
        [self changePwd];
    }

    

}
- (BOOL)checkPageInput
{
    UITextField *NewPwd = (UITextField *)[self.view viewWithTag:200];
    UITextField *SurePwd = (UITextField *)[self.view viewWithTag:201];
        if ([StaticTools isEmptyString:self.TextField.text])
        {
            [SVProgressHUD showErrorWithStatus:@"请完善重置支付密码信息"];
            return NO;
        }
   
    if(![NewPwd.text isEqualToString:SurePwd.text])
    {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致，请重新输入。"];
        return NO;
    }
    return YES;
}

#pragma mark 处理键盘遮挡问题
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 202) {
            if(SCREEN_HEIGHT<568) //iphone 4s
            {
        
                [UIView animateWithDuration:0.5 animations:^{
                    self.listTableView.contentOffset = CGPointMake(0, 20);
                } completion:nil];
        
            }
            //******************Tableview上移*****************
    }
    
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
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
    if (section==0) {
        return 10;
        
    }
    return 1;
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

    //******************左侧图标*************************
    NSArray *leftImgArr = @[@"ip_shszmm_con.png",@"ip_shszmm_pa.png",@"ip_shszmm_va.png"];
    UIImageView *leftImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",leftImgArr[indexPath.section]]]];
    [cell.contentView addSubview:leftImg];
    [leftImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(cell.centerY);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];

    //**************** 左边标签**********************
    self.leftLabel = [[UILabel alloc]init];
    self.leftLabel.tag = 100+indexPath.section;
    self.leftLabel.font = [UIFont systemFontOfSize:16];
    [cell.contentView addSubview:self.leftLabel];
    [self.leftLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImg.right);
        make.centerY.equalTo(cell.contentView.centerY);
        make.width.equalTo(@90
                           );
        make.height.equalTo(@40);
    }];
    
    //**************** 右边输入框**********************
    self.TextField = [[UITextField alloc] init];
    self.TextField.returnKeyType = UIReturnKeyDone;
    [cell.contentView addSubview:self.TextField];
    self.TextField.tag = 200+indexPath.section;
    if (self.TextField.tag==200||self.TextField.tag==201) {
        self.TextField.secureTextEntry = YES;
    }
    self.TextField.clearButtonMode = YES;
    self.TextField.delegate = self;
    self.TextField.autocapitalizationType = UITextAutocapitalizationTypeNone;// 自动大写去掉
    [self.TextField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLabel.right);
        make.centerY.equalTo(cell.contentView.centerY);
        make.height.equalTo(@45);
        make.width.equalTo(@110);
    }];
    
    if (indexPath.section==0)
    {
        
        self.TextField.placeholder = @"输入新密码";
        _leftLabel.text = @"新密码:";
    }
    
   else if (indexPath.section==1)
    {
    
        self.TextField.placeholder = @"确认新密码";
        _leftLabel.text = @"确认新密码:";
        
    }
    else
    {
        self.TextField.placeholder = @"请输入验证码";
        _leftLabel.text = @"验证码:";
        
    
        //****************获取验证码**********************
#pragma mark 重新获取
        GainCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [GainCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        GainCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [GainCodeButton setBackgroundImage:[UIImage imageNamed:@"ip_shszmm_ob"] forState:UIControlStateNormal];
        [GainCodeButton addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
        GainCodeButton.size = CGSizeMake(80, 30);
        GainCodeButton.viewRight = SCREEN_WIDTH-2;
       
        if (SCREEN_HEIGHT==667) {
            GainCodeButton.viewCenterY = cell.viewCenterY + 5;

        }
        else if (SCREEN_HEIGHT==736)
        {
          GainCodeButton.viewCenterY = cell.viewCenterY + 10;
        }
        else
        {
             GainCodeButton.viewCenterY = cell.viewCenterY;
        }
        [cell.contentView addSubview:GainCodeButton];
        
    }
    return cell;
}

-(void)btn
{
    
    //重新获取验证码
    [self gainIdentifyingCode];
    // 开始倒计时
    [self timeDown];
    
}
-(void)gainIdentifyingCode
{
    //下一步
    NSDictionary *dict = @{@"idNumber":self.textfield11text,
                           @"bankCardNumber":self.textfield22text};
    [[HttpRequest sharedRequest] sendRequestWithMessage:nil path:@"getPayPasswordSms" param:dict succuss:^(id result) {
    } fail:^{
        
    }];
  
}
#pragma mark 倒计时
-(void)timeDown
{
    
    InitialValue = 60;//60秒倒计时
    CountDowntimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod:) userInfo:nil repeats:YES];
    
    
}
-(void)timeFireMethod:(NSTimer *)timer
{
    InitialValue--;
    [GainCodeButton setTitle:[NSString stringWithFormat:@"%d秒",InitialValue] forState:UIControlStateNormal];
    [GainCodeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    GainCodeButton.enabled = NO;
    if(InitialValue==0)
    {
        [CountDowntimer invalidate];
        GainCodeButton.enabled = YES;
        GainCodeButton.titleLabel.text = nil ;
        [GainCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        [GainCodeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

#pragma mark 回收键盘
- (void)hideKeyboard
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.5 animations:^{
        self.listTableView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        
    }];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark 确定修改支付密码
-(void)changePwd
{
    UITextField *newPayPwdTextField    =   (UITextField *)[self.view viewWithTag:201];
    UITextField *validateCodeTextField =   (UITextField *)[self.view viewWithTag:202];
    NSDictionary *dict = @{@"validateCode":validateCodeTextField.text,
                           @"newPayPwd":[SecurityTool md5:newPayPwdTextField.text ]};
    [[HttpRequest sharedRequest] sendRequestWithMessage:nil path:@"resetPaypwd" param:dict succuss:^(id result) {
        NSLog(@"%@",result);
        [SVProgressHUD showSuccessWithStatus:@"支付密码设置成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } fail:nil];
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
