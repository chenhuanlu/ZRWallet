//
//  ForgetPasswordViewController.m
//  ZRwalletForMerchant
//
//  Created by 文彬 on 15/7/7.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "SecurityTool.h"
@interface ForgetPasswordViewController ()
{
    NSArray *keys;
    NSTimer *CountDowntimer;
    int InitialValue;//计时器初始值
    UIButton *codeBtn;
}
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@property (strong, nonatomic) NSMutableDictionary *infoDict;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"忘记密码";
    
    keys = @[@{@"title":@"验证码",@"key":@"code"},
             @{@"title":@"新密码",@"key":@"password"},
             @{@"title":@"确定密码",@"key":@"confirmpassword"}];
    
    self.infoDict = [[NSMutableDictionary alloc]init];
    
    [self initPageControl];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(15, 55, SCREEN_WIDTH-30, 40);
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"ip_xgmm_su"] forState:UIControlStateNormal];
    [sendBtn setTitle:@"确定" forState:UIControlStateNormal];
    sendBtn.layer.cornerRadius = 5;
    sendBtn.clipsToBounds = YES;
    [sendBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
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
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.frame = CGRectMake(10, 10, SCREEN_WIDTH-20, 30);
    titleLabel.text = [NSString stringWithFormat:@"短信已发送到手机：%@,请注意查收。",self.phoneNum];
    [headView addSubview:titleLabel];
    self.listTableView.tableHeaderView = headView;
    //*************************点击空白回收键盘******************
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tap)];
    [self.listTableView addGestureRecognizer:tap];
    
}
-(void)Tap
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
    
    if(![self.infoDict[@"password"] isEqualToString:self.infoDict[@"confirmpassword"]])
    {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致，请重新输入。"];
        return NO;
    }
    return YES;
}

#pragma mark 按钮点击
- (void)buttonClickHandle:(UIButton*)button
{
    [self.view endEditing:YES];
    if ([self checkPageInput])
    {
        [self validataPhone];
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
    return kCellHeight;
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
    [cell.contentView addSubview:leftLabel];

        NSArray *leftTextArr = @[@"验证码:",@"新密码:",@"确认密码:"];
        leftLabel.text = leftTextArr[indexPath.row];
        [leftLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftImg.right).offset(5);
            make.top.equalTo(@10);
            make.width.equalTo(@70);
            make.height.equalTo(@25);
        }];

     //******************输入框*************************
    UITextField *inputTxtField = [[UITextField alloc]init];
     inputTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    inputTxtField.returnKeyType  = UIReturnKeyDone;
    [cell.contentView addSubview:inputTxtField];
    inputTxtField.secureTextEntry = YES;
    inputTxtField.delegate = self;
    inputTxtField.tag = 100+indexPath.row;
    if (inputTxtField.tag==100) {
        [StaticTools addTopViewInTextFeild:inputTxtField withMessage:@"验证码"];
    }
    [inputTxtField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLabel.right);
        make.top.equalTo(@7);
        make.right.equalTo(@(indexPath.row==0?-100:-10));
        make.height.equalTo(@30);
    }];
    
    
    if (indexPath.row==0)
    {
        inputTxtField.keyboardType = UIKeyboardTypePhonePad;
         inputTxtField.secureTextEntry = NO;
        
         //******************获取验证码按钮*************************
        codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        codeBtn.backgroundColor = [UIColor lightGrayColor];
        codeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [codeBtn addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:codeBtn];
        [codeBtn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@5);
            make.right.equalTo(@-10);
            make.height.equalTo(@30);
            make.width.equalTo(@80);
        }];
    }
  
    NSDictionary *dict = keys[indexPath.row];
    //leftLabel.text = dict[@"title"];
    inputTxtField.text = self.infoDict[dict[@"key"]];
    inputTxtField.placeholder = [NSString stringWithFormat:@"请输入%@",dict[@"title"]];;
    
    
    return cell;
}
-(void)btn
{
    [[HttpRequest sharedRequest] sendRequestWithMessage:nil path:@"forget/validateMerPhone" param:@{@"phoneNumber":self.phoneNum} succuss:^(id result) {
    } fail:nil];
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

#pragma mark SCrollViewDelege
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark HTTP
/**
 *  验证手机号  成功后默认发送一条验证码
 */
- (void)validataPhone
{
    NSDictionary *dict = @{@"phoneNumber":self.phoneNum,
                           @"validateCode":self.infoDict[@"code"],
                           @"newPwd":[SecurityTool md5:self.infoDict[@"confirmpassword"]]};
    
    [[HttpRequest sharedRequest] sendRequestWithMessage:nil path:@"forget/forgetPwd" param:dict succuss:^(id result) {
        
        [SVProgressHUD showSuccessWithStatus:@"密码设置成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } fail:nil];

}

@end
