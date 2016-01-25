//
//  ChangePasswordViewController.m
//  ZRwalletForConsumer
//
//  Created by 陈焕鲁 on 15/6/30.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "UIColor+NSString.h"
#import <QuartzCore/QuartzCore.h>
#import "SecurityTool.h"
@interface ChangePasswordViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

{
     NSArray *keys;
}
@property(nonatomic,strong)UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *infoDict;
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.navigationItem.title = @"修改密码";
    keys = @[@{@"title":@"原始密码",@"key":@"oldPwd",@"alert":@"请输入原始密码"},
            @{@"title":@"新密码",@"key":@"newPwd",@"alert":@"请输入新密码"},
            @{@"title":@"确定新密码",@"key":@"confirmpassword",@"alert":@"请确定新密码"}];
    
    self.infoDict = [[NSMutableDictionary alloc]init];

 
    self.navigationItem.title = @"修改登录密码";
    
     [self createUI];
    self.view.backgroundColor = RGBCOLOR(231, 231, 231);

}
-(void)createUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    self.view.backgroundColor = RGBCOLOR(255, 255, 255);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor  = [UIColor clearColor];
    //*****************点击收键盘*********************************
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [_tableView addGestureRecognizer:tapGuesture];
}
-(void)hideKeyboard
{
    [self.view endEditing:YES];
}
#pragma mark 实现UITableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    for (UIView * view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    //**************** 去掉点击选中效果**************************
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //******************左侧图标*************************
    NSArray *leftImgArr = @[@"ip_yhxgmm_ori.png",@"ip_shszmm_pa.png",@"ip_shszmm_con.png"];
    UIImageView *leftImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",leftImgArr[indexPath.row]]]];
    [cell.contentView addSubview:leftImg];
    [leftImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(cell.centerY);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
        
    }];
    //****************左侧标题****************************
    UILabel *leftLabel  = [[UILabel alloc] init];
    [cell.contentView addSubview:leftLabel];
    [leftLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImg.right).equalTo(@5);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
        make.centerY.equalTo(cell.centerY);
    }];

    //***************右侧输入框**************************
    UITextField *textField = [[UITextField alloc] init];
    textField.returnKeyType = UIReturnKeyDone;//返回键设置
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;// 自动大写去掉
    textField.keyboardType = UIKeyboardTypeASCIICapable;

    textField.delegate = self;
    textField.tag = 100+indexPath.row;
    [cell.contentView addSubview:textField];
    [textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLabel.right).offset(10);
        make.width.equalTo(@150);
        make.height.equalTo(@30);
        make.centerY.equalTo(cell.centerY);
    }];
   NSDictionary *dict = keys[indexPath.row];
//    leftLabel.text = dict[@"title"];
     NSArray *leftTextArr = @[@"原 始 密 码:",@"新　密　码:",@"确定新密码:"];
    leftLabel.text =  leftTextArr[indexPath.row];
    leftLabel.font = [UIFont systemFontOfSize:15];
    textField.text = self.infoDict[dict[@"key"]];
    textField.placeholder = [NSString stringWithFormat:@"请输入%@",dict[@"title"]];;
//********************************************footview********************************
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    footView.backgroundColor = [UIColor clearColor];
    UIButton *SubmmitButton = [[UIButton alloc] init];
    [SubmmitButton setTitle:@"提交" forState:UIControlStateNormal];
    if (SCREEN_HEIGHT==667||SCREEN_HEIGHT==736) {
        SubmmitButton.titleLabel.font = [UIFont boldSystemFontOfSize:22];
        
    }
    else
    {
        SubmmitButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }

    SubmmitButton.layer.cornerRadius  = 5;
    SubmmitButton.clipsToBounds =  YES;
    [SubmmitButton setBackgroundImage:[UIImage imageNamed:@"commitButton"] forState:UIControlStateNormal];
    [SubmmitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [SubmmitButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:SubmmitButton];
    [SubmmitButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.height.equalTo(@(SCREEN_WIDTH/8));
        make.top.equalTo(@20);
    }];
    _tableView.tableFooterView = footView;
    return cell;
}
#pragma mark 按钮点击
-(void)btnClick:(UIButton *)btn
{
    //提交密码
    [UserDefaults removeObjectForKey:PHONENUM];
    [UserDefaults synchronize];
    if ([self checkPageInput])
    {
        [self changePwd];
    }
 
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.clearButtonMode = UITextFieldViewModeAlways;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger index = textField.tag - 100;
    NSDictionary *dict = keys[index];
    [self.infoDict setObject:textField.text forKey:dict[@"key"]];
    
    textField.clearButtonMode = UITextFieldViewModeNever;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

#pragma mark 回收键盘
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];  //放弃所有响应者
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)checkPageInput
{
    
    for (NSDictionary *dict in keys)
    {
        if ([StaticTools isEmptyString:self.infoDict[dict[@"key"]]])
        {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",dict[@"alert"]]];
            return NO;
        }
    }
    
    if(![self.infoDict[@"newPwd"] isEqualToString:self.infoDict[@"confirmpassword"]])
    {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致，请重新输入。"];
        return NO;
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark HTTP
/**
 *  验证手机号  成功后默认发送一条验证码
 */
- (void)changePwd
{
    NSDictionary *dict = @{@"oldPwd":[SecurityTool md5:self.infoDict[@"oldPwd"]],
                           @"newPwd":[SecurityTool md5:self.infoDict[@"confirmpassword"]]};
    [[HttpRequest sharedRequest] sendRequestWithMessage:nil path:@"changePwd" param:dict succuss:^(id result) {
                //[UserDefaults removeObjectForKey:KUSERNAME];
        
              [SVProgressHUD showSuccessWithStatus:@"密码设置成功,请重新登录"];
        
                [StaticTools showLoginControllerWithSuccess:^{
            
            
        } fail:^{
            
        }];

    } fail:nil];
    
}

@end