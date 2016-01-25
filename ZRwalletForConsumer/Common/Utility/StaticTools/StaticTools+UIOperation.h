//
//  StaticTools+UIOperation.h
//  LivingService
//
//  Created by wenbin on 13-10-24.
//  Copyright (c) 2013年 wenbin. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (
 // 版权所有。
 //
 // 文件功能描述：具体业务相关的工具函数
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import "StaticTools.h"
#import "MessageViewController.h"
#import "DateSelectViewController.h"
#import "LoginViewController.h"
#import "PayPasswordViewController.h"
#import "LLLockViewController.h"

@interface StaticTools (UIOperation)

//显示信息提示页面
+(void)showMessagePageWithType:(kMessageType)type
                          mess:(NSString*)mess
                       clicked:(ButtonClickBlock)block;


//显示日期选择页面  可包含年、月、日  也可只包含年、月
+ (void)showDateSelectWithIndexDate:(NSString*)dateStr
                               type:(kDatePickerType)pickerType
                            clickOk:(DateSelectAction)block;

/**
 *  弹出登录页面
 *
 *  @param sucBlock  登录成功后回调
 *  @param failBlock 登录失败后回调
 */
+ (void)showLoginControllerWithSuccess:(LoginSuccessBlock)sucBlock
                                  fail:(LoginFailBlock)failBlock;

/**
 *  弹出支付密码页面
 *
 *  @param money   付款金额
 *  @param okClick 点击确定后回调
 */
+(void)showPayPasswordWithMoney:(NSString*)money
                        ClickOk:(OKClickBlock)okClick;


/**
 *  弹出手势密码
 *
 *  @param type
 */
+ (void)showLockViewWithType:(LLLockViewType)type;

/**
 *  在输入框上面加一条  完成按钮和提示信息
 *
 *  @param txtField
 *  @param mess     提示信息
 */
+ (void)addTopViewInTextFeild:(UITextField*)txtField withMessage:(NSString*)mess;
@end
