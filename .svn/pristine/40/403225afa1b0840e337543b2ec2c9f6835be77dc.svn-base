//
//  RegisterOfBaseInfoViewController.m
//  ZRwalletForMerchant
//
//  Created by 文彬 on 15/7/7.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "RegisterOfBaseInfoViewController.h"
#import "YLLabel.h"
#import "SecurityTool.h"
#import "UIColor+NSString.h"
@interface RegisterOfBaseInfoViewController ()
{
    NSArray *keys;
    UIButton *codeBtn;
    NSTimer *CountDowntimer;
    int InitialValue;//计时器初始值
    
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@property (strong, nonatomic) NSMutableDictionary *infoDict;

@property (strong,nonatomic)UIButton *showPasswordBtn;

@end

@implementation RegisterOfBaseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"设置密码";
    
    keys = @[@{@"title":@"验证码",@"key":@"code"},
             @{@"title":@"密码",@"key":@"password"},
             @{@"title":@"确认密码",@"key":@"merchantName"}];
    
    self.infoDict = [[NSMutableDictionary alloc]init];
    
    [self initPageControl];
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
    //***************footView****************************
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(15, 55, SCREEN_WIDTH-30, (SCREEN_WIDTH/8));
    [sendBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"ip_xgmm_su"] forState:UIControlStateNormal];
    sendBtn.layer.cornerRadius = 5;
    sendBtn.clipsToBounds = YES;
    [sendBtn setTitle:@"确定" forState:UIControlStateNormal];
    if (SCREEN_HEIGHT==667||SCREEN_HEIGHT==736) {
        sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
        
    }
    else
    {
        sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footView addSubview:sendBtn];
    self.listTableView.tableFooterView = footView;
    
   //***************headView****************************
    UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    headView.image = [UIImage imageNamed:@"ip_yhqb_bjwa"];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.frame = CGRectMake(10, 10, SCREEN_WIDTH-20, 30);
    titleLabel.text = [NSString stringWithFormat:@"短信已发送到手机：%@,请注意查收。",self.phoneNum];
    [headView addSubview:titleLabel];
    self.listTableView.tableHeaderView = headView;
    //*********************点击回收键盘***************
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.listTableView addGestureRecognizer:tap];
}

#pragma mark 轻击回收键盘
-(void)tap
{
    [self.view endEditing:YES];
}

- (BOOL)checkPageInput
{

    for (NSDictionary *dict in keys)
    {
        if ([StaticTools isEmptyString:self.infoDict[dict[@"key"]]])
        {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请输入%@",dict[@"title"]]];
            return NO;
        }
    }
    return YES;
}

#pragma mark 按钮点击
- (void)buttonClickHandle:(UIButton*)button
{
    [self.view endEditing:YES];
    
    //判断两次密码输入是否一致
    UITextField *secretTextField = (UITextField *)[self.view viewWithTag:100 + 1];
    UITextField *confirmTextField = (UITextField *)[self.view viewWithTag:100 + 2];

    if(![secretTextField.text isEqualToString:confirmTextField.text])
    {
        [UIAlertView showAlertView:@"两次密码输入不一致"];
        
    }else{
    
        if([self checkPageInput])
        {
            [self.view endEditing:YES];
            
            [self baseInfoSend];
        }
    }
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger index = textField.tag - 100;
    NSDictionary *dict = keys[index];
    [self.infoDict setObject:textField.text forKey:dict[@"key"]];
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
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

     //******************左侧图标*************************
    NSArray *leftImgArr = @[@"ip_shszmm_va.png",@"ip_shszmm_pa.png",@"ip_shszmm_con.png"];
    UIImageView *leftImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",leftImgArr[indexPath.row]]]];
    [cell.contentView addSubview:leftImg];
    [leftImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(cell.centerY);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    //******************左侧标题文字*************************
    UILabel *leftLabel = [[UILabel alloc]init];
    leftLabel.font = [UIFont systemFontOfSize:15];
    NSDictionary *dict = keys[indexPath.row];
//     leftLabel.text = dict[@"title"];
    NSArray *leftTextArr = @[@"验   证   码:",@"密　　   码:",@"确 认 密 码:"];
   leftLabel.text = leftTextArr[indexPath.row];

    [cell.contentView addSubview:leftLabel];
    [leftLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImg.right).offset(5);
        make.top.equalTo(@10);
        make.width.equalTo(@80);
        make.height.equalTo(@25);
    }];
    
    //******************输入框*************************
    UITextField *inputTxtField = [[UITextField alloc]init];
     inputTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    inputTxtField.secureTextEntry = YES;
    inputTxtField.tag = 100+indexPath.row;
    inputTxtField.delegate = self;
    [cell.contentView addSubview:inputTxtField];
    [inputTxtField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLabel.right);
        make.centerY.equalTo(cell.centerY);
        make.height.equalTo(@30);
        make.width.equalTo(@120);
    }];
    inputTxtField.text = self.infoDict[keys[indexPath.row]];
    
    
    if (indexPath.row==0)
    {
        //leftLabel.text = @"验证码";
        inputTxtField.placeholder = @"请输入验证码";
        inputTxtField.keyboardType = UIKeyboardTypeNumberPad;
        inputTxtField.secureTextEntry = NO;
        
        //******************获取验证码按钮*************************
        codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //codeBtn.backgroundColor = [UIColor lightGrayColor];
        [codeBtn setBackgroundImage:[UIImage imageNamed:@"ip_shszmm_ob"] forState:UIControlStateNormal];
        codeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        [codeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:codeBtn];
        [codeBtn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@5);
            make.right.equalTo(@-10);
            make.height.equalTo(@30);
            make.width.equalTo(@80);
        }];
        
    }
   
    NSArray *inputTextFieldArr = @[@"请输入验证码",@"请输入密码",@"请确认密码"];
    //inputTxtField.placeholder = [NSString stringWithFormat:@"请输入%@",dict[@"title"]];
    inputTxtField.placeholder = [NSString stringWithFormat:@"%@",inputTextFieldArr[indexPath.row]];
    inputTxtField.text = self.infoDict[dict[@"key"]];
    //******************显示密码按钮*************************
#pragma mark 显示密码按钮
    if (indexPath.row==1)
    {
        _showPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.showPasswordBtn setImage:[UIImage imageNamed:@"ip_shyhdl_sh.png"] forState:UIControlStateNormal];
        [self.showPasswordBtn setImage:[UIImage imageNamed:@"ip_shyhdl_hi.png"] forState:UIControlStateSelected];
        self.showPasswordBtn.selected = NO;
        [self.showPasswordBtn addTarget:self action:@selector(showBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:self.showPasswordBtn];
        [self.showPasswordBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
            make.top.equalTo(@5);
            make.height.equalTo(@20);
            make.width.equalTo(@50);
        }];
        
        UILabel *showLabel = [[UILabel alloc] init];
        showLabel.text = @"显示密码";
        showLabel.font = [UIFont systemFontOfSize:10];
        showLabel.textColor = [UIColor grayColor];
        [cell.contentView addSubview:showLabel];
        [showLabel makeConstraints:^(MASConstraintMaker *make) {
            //make.centerX.equalTo(self.showPasswordBtn.centerX);
            make.top.equalTo(self.showPasswordBtn.bottom);
            make.right.equalTo(@-5);
            make.width.equalTo(@50);
            make.height.equalTo(@20);
        }];
    }
    
        
   
    
    return cell;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.showPasswordBtn.selected = self.showPasswordBtn.selected ? NO : YES;
//    
//}

-(void)showBtnClick:(UIButton *)showBtn
{

    showBtn.selected = showBtn.selected ? NO : YES;
    if (showBtn.selected == YES) {
       
        UITextField *temp1textfield = (UITextField *)[self.view viewWithTag:101];
         UITextField *temp2textfield = (UITextField *)[self.view viewWithTag:102];
        temp1textfield.secureTextEntry= NO;
        temp2textfield.secureTextEntry= NO;
    }
    else {
        UITextField *temp1textfield = (UITextField *)[self.view viewWithTag:101];
        UITextField *temp2textfield = (UITextField *)[self.view viewWithTag:102];
        temp1textfield.secureTextEntry= YES;
        temp2textfield.secureTextEntry= YES;
    }
    
}
-(void)btnClick:(UIButton *)btn
{
    [[HttpRequest sharedRequest] cancelLastRequst];
    //重新获取验证码
    [self gainIdentifyingCode];
    [self timeDown];
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
    [codeBtn setTitle:[NSString stringWithFormat:@"%d秒",InitialValue] forState:UIControlStateNormal];
    [codeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    codeBtn.enabled = NO;
    if(InitialValue==0)
    {
        [CountDowntimer invalidate];
        codeBtn.enabled = YES;
        codeBtn.titleLabel.text = nil ;
        [codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        [codeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}


#pragma mark HTTP
/**
 *  获取验证码
 */

- (void)gainIdentifyingCode
{
    [[HttpRequest sharedRequest] sendRequestWithMessage:nil path:@"reg/validateUserPhone" param:@{@"phoneNumber":self.phoneNum}  succuss:^(id result) {
        
    } fail:nil];
    
    
}

#pragma mark SCrollViewDelege
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark HTTP
/**
 *  提交信息
 */
- (void)baseInfoSend
{
    NSDictionary *dic = @{ @"password"      :   [SecurityTool md5:self.infoDict[@"password"]],
                           @"phoneNumber"   :   self.phoneNum,
                           @"validateCode"  :   self.infoDict[@"code"],
                           @"payPassword"   :   [SecurityTool md5:@"111111"],
                           @"inviteCode"    :   self.invitationCode
                                           };
    
    [[HttpRequest sharedRequest]sendRequestWithMessage:nil path:@"reg/registerUser" param:dic succuss:^(id result) {
        
        APPDataCenter.temPhone = self.phoneNum;
        [SVProgressHUD showSuccessWithStatus:@"注册成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } fail:nil];
    
}
@end
