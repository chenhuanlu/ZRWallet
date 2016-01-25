//
//  SetPayPasswordViewController.m
//  ZRwalletForConsumer
//
//  Created by 文彬 on 15/7/25.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "SetPayPasswordViewController.h"
#import "SecurityTool.h"
#import "UIColor+NSString.h"
#import "AppNavView.h"

@interface SetPayPasswordViewController ()
{
    NSArray *keys;
}
@property (nonatomic, strong) AppNavView *navView;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end

@implementation SetPayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"设置支付密码";
    [self makeNavView];

    keys = @[@{@"title":@"支付密码:",@"key":@"payPassword",@"placeHold":@"请输入支付密码"},
             @{@"title":@"确认支付密码:",@"key":@"confirmPayPassword",@"placeHold":@"请确认支付密码"}];
    
    [self initPageControl];
    
}
-(void)makeNavView
{
    self.navView = [AppNavView new];
    self.navView.delegate = self;
    [self.view addSubview:self.navView];
    
    self.navView.titleLabel.text = @"设置支付密码";
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
    titleLabel.text = @"支付密码用户提现、购买理财等";
    [headView addSubview:titleLabel];
    
    self.listTableView.tableHeaderView = headView;
    self.listTableView.backgroundColor = [UIColor clearColor];
    
    
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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dealTap)];
    [self.listTableView addGestureRecognizer:tap];
}
-(void)dealTap
{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
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

    if (![self.infoDict[@"payPassword"] isEqualToString:self.infoDict[@"confirmPayPassword"]])
    {
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致"];
        return NO;
    }
    
    return YES;
    
}

#pragma mark UITextFieldDelegate
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
            [self bandingCard];
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
    
    
    //******************左侧图标*************************
    NSArray *leftImgArr = @[@"ip_shszmm_con.png",@"ip_shszmm_pa.png"];
    UIImageView *leftImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",leftImgArr[indexPath.row]]]];
    [cell.contentView addSubview:leftImg];
    [leftImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(cell.centerY);
        make.top.equalTo(@10);
        make.bottom.equalTo(@-10);
    }];

    //******************左侧标题文字*************************
    UILabel *leftLabel = [[UILabel alloc]init];
    leftLabel.font = [UIFont systemFontOfSize:16];
    [cell.contentView addSubview:leftLabel];
    [leftLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImg.right);
        make.top.equalTo(@10);
        make.width.equalTo(@120);
        make.height.equalTo(@25);
    }];
    
    
    NSDictionary *dict = keys[indexPath.row];
    leftLabel.text = dict[@"title"];
    
    if (indexPath.section==0)
    {
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


#pragma mark HTTP
/**
 *  绑定银行卡
 */
- (void)bandingCard
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.infoDict];
    [dict setObject:[SecurityTool md5:dict[@"payPassword"]] forKey:@"payPassword"];
    [dict removeObjectForKey:@"confirmPayPassword"];
    [[HttpRequest sharedRequest] sendRequestWithMessage:nil path:@"bindBankCard" param:dict succuss:^(id result) {
        
        [UserDefaults setObject:result[@"accountName"] forKey:USER_NICKNAME];
        [UserDefaults setObject:result[@"bankCard"] forKey:USER_BANKCARD];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
    } fail:nil];
}

#pragma mark - navBtnClick
-(void)navLeftBtnDown
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
