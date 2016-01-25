//
//  StaticTools+UIOperation.m
//  LivingService
//
//  Created by wenbin on 13-10-24.
//  Copyright (c) 2013年 wenbin. All rights reserved.
//

#import "StaticTools+UIOperation.h"
#import "LoginViewController.h"

@implementation StaticTools (UIOperation)

/**
 *  显示信息提示页面
 *
 *  @param type  页面类型
 *  @param mess  提示文字
 *  @param block 点击确定后的回调操作
 */
+(void)showMessagePageWithType:(kMessageType)type
                          mess:(NSString*)mess
                       clicked:(ButtonClickBlock)block
{
    
    MessageViewController *messController = [[MessageViewController alloc]init];
    messController.messType = type;
    messController.messStr = mess;
    messController.clickBlock = block;
    UINavigationController *rootNav = (UINavigationController*)ApplicationDelegate.window.rootViewController;
    [rootNav pushViewController:messController animated:YES];
}

/**
 *	@brief	显示日期选择页面
 *
 *	@param 	dateStr 	显示页面是默认的被选择的日期 格式为“2013-12-12” 或“2013-12” 或 @“2013”
 *	@param 	pickerType  picker类型
 *  @param  block  点击确定按钮时的回调 返回选择的日期字符串 格式为“2013-12-12” 或“2013-12” 或 @“2013”
 *	@return
 */
+ (void)showDateSelectWithIndexDate:(NSString*)dateStr
                                type:(kDatePickerType)pickerType
                            clickOk:(DateSelectAction)block
{
    DateSelectViewController *dateSelectController = [[DateSelectViewController alloc]initWithNibName:@"DateSelectViewController" bundle:[NSBundle mainBundle]];
    dateSelectController.pageType = pickerType;
    dateSelectController.indexDate = dateStr;
    dateSelectController.clickOkAction = block;
    
    UINavigationController *rootNav = (UINavigationController*)ApplicationDelegate.window.rootViewController;
    
    //http://www.cocoachina.com/bbs/read.php?tid=245608
    //若不设置此属性 推上去后背景会变黑色  必须是rootviewcontroller
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
    {
        dateSelectController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }
    else
    {
       rootNav.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    
    
    [rootNav presentModalViewController:dateSelectController animated:YES];
}

/**
 *  弹出登录页面
 *
 *  @param sucBlock  登录成功后回调
 *  @param failBlock 登录失败后回调
 */
+ (void)showLoginControllerWithSuccess:(LoginSuccessBlock)sucBlock
                                  fail:(LoginFailBlock)failBlock
{
    LoginViewController *loginController = [[LoginViewController alloc]init];
    loginController.successBlock = sucBlock;
    loginController.failBlock = failBlock;
     UINavigationController *rootNav = (UINavigationController*)ApplicationDelegate.window.rootViewController;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginController];
    [rootNav presentViewController:nav animated:YES completion:nil];

}

/**
 *  弹出支付密码页面
 *
 *  @param money   付款金额  传0时 不显示需支付xx字样  只显示支付密码四个字
 *  @param okClick 点击确定后回调
 */
+(void)showPayPasswordWithMoney:(NSString*)money
                        ClickOk:(OKClickBlock)okClick
{
    APPDataCenter.payPasswordController = [[PayPasswordViewController alloc]init];
    APPDataCenter.payPasswordController.payMoneyStr = money;
    APPDataCenter.payPasswordController.okClickBlock = okClick;
    UIViewController *rootController = (UIViewController*)ApplicationDelegate.window.rootViewController;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
    {
        APPDataCenter.payPasswordController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }
    else
    {
        rootController.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    
    if(APPDataCenter.scanNav!=nil)
    {
        APPDataCenter.payPasswordController.view.frame = APPDataCenter.scanNav.topViewController.view.bounds;
        [APPDataCenter.scanNav.topViewController.view addSubview:APPDataCenter.payPasswordController.view];
    }
    else
    {
        [rootController presentViewController:APPDataCenter.payPasswordController animated:NO completion:^{
            
        }];
    }
 
}

/**
 *  弹出手势密码
 *
 *  @param type
 */
+ (void)showLockViewWithType:(LLLockViewType)type
{
    UINavigationController *rootNav = (UINavigationController*)ApplicationDelegate.window.rootViewController;
    LLLockViewController *lockVc = [[LLLockViewController alloc] init];
    lockVc.nLockViewType = type;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:lockVc];
    lockVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [rootNav presentViewController:nav animated:YES completion:^{
    }];
    
    
    //设置导航栏背景颜色和标题颜色
    [[UINavigationBar appearance] setBarTintColor:RGBCOLOR(207, 0, 33)];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName,[NSValue valueWithUIOffset:UIOffsetMake(0, -1)],NSForegroundColorAttributeName,[UIFont fontWithName:@"Arial-Bold" size:18],NSFontAttributeName,nil]];
}

/**
 *  在输入框上面加一条  完成按钮和提示信息
 *
 *  @param txtField
 *  @param mess     提示信息
 */
+ (void)addTopViewInTextFeild:(UITextField*)txtField withMessage:(NSString*)mess
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    topView.backgroundColor = RGBACOLOR(201, 204, 213, 1);
    
    //顶部黑条
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineView.alpha  = 0.3;
    lineView.backgroundColor = [UIColor darkGrayColor];
    [topView addSubview:lineView];
    
    //中间提示信息
    UILabel *messLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 30)];
    messLabel.font = [UIFont systemFontOfSize:15];
    messLabel.textAlignment = NSTextAlignmentCenter;
    messLabel.text = mess;
    messLabel.textColor = [UIColor darkGrayColor];
    [topView addSubview:messLabel];
    
    //右侧按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(SCREEN_WIDTH-50-20, 10, 50, 30);
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn addTarget:txtField action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:rightBtn];
    
    txtField.inputAccessoryView = topView;
    
}
@end
