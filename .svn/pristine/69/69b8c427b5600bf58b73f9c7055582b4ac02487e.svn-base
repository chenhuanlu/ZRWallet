//
//  UserRechargeViewController.m
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/8/1.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "UserRechargeViewController.h"
#import "UIColor+NSString.h"
#import "AFHTTPRequestOperation.h"
#import "AppNavView.h"

@interface UserRechargeViewController ()<UITextFieldDelegate,UIScrollViewAccessibilityDelegate,NavViewDelegate>
@property (nonatomic, strong) AppNavView *navView;
@property (nonatomic, strong) UIScrollView *scrView;
@property (nonatomic, strong) UITextField *valueField;
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) UILabel *investmentTitleLabel;
@property (nonatomic, strong) UIButton *rechargeBtn;


@end

@implementation UserRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isHiddenNav == YES) {
        
        self.navigationController.navigationBarHidden = YES;
        [self makeNavView];
        
    }else
    {
        self.navigationItem.title  = @"充值";

    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeView];

}
-(void)makeNavView
{
    self.navView = [AppNavView new];
    self.navView.delegate = self;
    [self.view addSubview:self.navView];
    self.navView.titleLabel.text = @"充值";
    
    self.navView.leftImgView.image = [UIImage imageNamed:@"whiteBack"];
    
}
-(void)makeView
{
    self.scrView = [UIScrollView new];
    self.scrView.showsVerticalScrollIndicator = NO;
    self.scrView.backgroundColor = [UIColor colorWithString:@"#f0f0f0"];
    self.scrView.userInteractionEnabled = YES;
    self.scrView.delegate = self;
    [self.view addSubview:self.scrView];
    
    self.middleView = [UIView new];
    self.middleView.backgroundColor = [UIColor whiteColor];
    [self.middleView addLine];
    [self.scrView addSubview:self.middleView];
    
    self.investmentTitleLabel = [UILabel new];
    self.investmentTitleLabel.font = [UIFont systemFontOfSize:15];
    self.investmentTitleLabel.textColor = RGBCOLOR(125, 125, 125);
    self.investmentTitleLabel.text = @"充值金额";
    [self.middleView addSubview:self.investmentTitleLabel];
    
    self.valueField = [UITextField new];
    self.valueField.placeholder = @"请输入充值金额";
    self.valueField.textAlignment = NSTextAlignmentRight;
    self.valueField.delegate = self;
    [self.valueField setValue:[UIFont systemFontOfSize:15]forKeyPath:@"_placeholderLabel.font"];
    self.valueField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.valueField.backgroundColor = [UIColor clearColor];
    self.valueField.keyboardType = UIKeyboardTypeNumberPad;
    self.valueField.returnKeyType = UIReturnKeyDefault;
    [StaticTools addTopViewInTextFeild:self.valueField withMessage:@"投资金额"];
    [self.middleView addSubview:self.valueField];
    
    self.rechargeBtn = [UIButton new];
    [self.rechargeBtn setBackgroundImage : [UIImage imageNamed:@"commitButton"]
                                forState : UIControlStateNormal];

    self.rechargeBtn.layer.masksToBounds = YES;
    self.rechargeBtn.layer.cornerRadius = 4.0;
    [self.rechargeBtn addTarget : self
                       action : @selector(rechargeBtnDown:)
             forControlEvents : UIControlEventTouchUpInside
     ];
    self.rechargeBtn.userInteractionEnabled = YES;
    self.rechargeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.rechargeBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [self.scrView addSubview:self.rechargeBtn];


}
-(void)rechargeBtnDown:(UIButton *)btn
{
    // 跳转到充值页面
    if ([StaticTools isEmptyString:self.valueField.text])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入充值金额"];
        return;
    }
    
    if ([self.valueField.text integerValue] > 0) {
        NSDictionary *dic = @{ @"rechargeAmount" : self.valueField.text};
        
        [[HttpRequest sharedRequest]sendRequestWithMessage:nil path:@"recharge/createRechargeOrder" param:dic succuss:^(id result) {
            
            [self rechargeWithParam:@{@"orderId":result[@"orderId"],
                                      @"amount": self.valueField.text}];
            
        } fail:nil];

        return;
    }
    if([self.valueField.text integerValue] == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"充值金额不能小于0元"];

        return;
    }
    
}
-(void)viewDidLayoutSubviews
{
    if (self.isHiddenNav == YES) {
        
        self.navView.size = CGSizeMake(SCREEN_WIDTH, Dev_NavigationBar_Height);

        self.scrView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - Dev_NavigationBar_Height);
        self.scrView.viewTop = Dev_NavigationBar_Height;

    }else
    {
        self.scrView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - Dev_NavigationBar_Height);

    }
    
    self.middleView.size = CGSizeMake(SCREEN_WIDTH, kCellHeight);
    self.middleView.viewTop = 40;
    
    self.investmentTitleLabel.size = CGSizeMake(SCREEN_WIDTH/1.9, self.middleView.size.height);
    self.investmentTitleLabel.viewLeft = 20;
    
    self.valueField.size = CGSizeMake(SCREEN_WIDTH/2, self.middleView.size.height);
    self.valueField.viewRight = self.middleView.viewRight - 20;
    
    self.rechargeBtn.size = CGSizeMake(SCREEN_WIDTH - 20, SCREEN_WIDTH/8);
    self.rechargeBtn.viewLeft = 10;
    self.rechargeBtn.viewTop = self.middleView.viewBottom + 70;
    
    self.scrView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + 10);


}
#pragma mark textfieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
/**
 *  充值
 */
- (void)rechargeWithParam:(NSDictionary*)param
{
    if (![StaticTools checkNetAvailable])
        return;
    
    [SVProgressHUD showWithStatus:@"正在充值" maskType:SVProgressHUDMaskTypeClear];
    
    
    NSString *httpBodyString = param==nil?@"":[self DataTOjsonString:param];
    httpBodyString = [httpBodyString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    httpBodyString = [httpBodyString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    httpBodyString = [httpBodyString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://220.194.59.154:10801/onlinePaygate"]];
    request.HTTPMethod = @"POST";
    
    if (![StaticTools isEmptyString:httpBodyString])
    {
        request.HTTPBody = [httpBodyString dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"requesthead:%@",request.allHTTPHeaderFields);
    NSLog(@"request:%@",httpBodyString);
    NSLog(@"url is --》%@",request.URL);
    
    [request setTimeoutInterval:30];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        [SVProgressHUD dismiss];
        
        
        NSString *respStr = [operation responseString];
        
        NSLog(@"Response: %@", respStr);
        
        NSDictionary *reciveDict  =  [NSJSONSerialization JSONObjectWithData:[respStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        if (reciveDict==nil)
        {
            
        }
        
        if ([reciveDict[@"code"] isEqualToString:@"00"]) //操作成功
        {
            [SVProgressHUD showSuccessWithStatus:@"充值成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:reciveDict[@"msg"]];
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
        NSLog(@"error.userInfo:%@",error.userInfo);
        
        
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
    
}
/**
 *  字典转json字符串
 *
 *  @param object
 *
 *  @return
 */
-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
#pragma mark - navBtnClick
-(void)navLeftBtnDown
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
