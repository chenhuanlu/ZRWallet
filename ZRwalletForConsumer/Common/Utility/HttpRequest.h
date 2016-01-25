//
//  HttpRequest.h
//  ZRwalletForConsumer
//
//  Created by 文彬 on 15/7/15.
//  Copyright (c) 2015年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 中融钱包
 //
 // 文件功能描述：HTTP 请求类 封装AFnetworing
 
 // 注意事项：
 //
 ----------------------------------------------------------------*/

#import <Foundation/Foundation.h>

typedef void(^RequestSucBlock)(id result);
typedef void(^RequestErrBlock)();

@interface HttpRequest : NSObject<UIAlertViewDelegate>
{
    UIAlertView *alert;
}

/**
 *  获取单例类  使用获取的单例类调用发送请求的函数
 *
 *  @return
 */
+ (HttpRequest *) sharedRequest;

/**
 *  发送http请求
 *
 *  @param message  加载框文字 传nil时使用默认值：正在加载  传@"" 时不显示加载框
 *  @param path     请求路径 具体见接口文档
 *  @param param    请求参数
 *  @param sucBlock 成功后回调
 *  @param errBlock 失败时回调
 */
- (void)sendRequestWithMessage:(NSString*)message
                          path:(NSString*)path
                         param:(NSDictionary*)param
                       succuss:(RequestSucBlock)sucBlock
                          fail:(RequestErrBlock)errBlock;

/**
 *  取消请求
 */
- (void)cancelLastRequst;

/**
 *  显示加载框
 *
 *  @param mess 加载框文字
 */
- (void)showHUDwihtMess:(NSString*)mess;

/**
 *  隐藏加载框
 */
- (void)hideHUD;
@end
