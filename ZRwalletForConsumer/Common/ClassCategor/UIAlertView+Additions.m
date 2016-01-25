//
//  UIAlertView+Additions.m
//  HelloInstallment
//
//  Created by 文彬 on 15/1/23.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "UIAlertView+Additions.h"
#import <objc/runtime.h>

static void* UIAlertViewKey = @"UIAlertViewKey";

@implementation UIAlertView (Additions)

#pragma mark-公有函数
/**
 *  弹出alertview
 *
 *  @param alertViewCallBackBlock 点击后回调处理
 *  @param title                  title
 *  @param message                message
 *  @param cancelButtonName
 *  @param otherButtonTitles      可输入多个 必须以nil结尾
 */
+ (void)alertWithCallBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock
                         title:(NSString *)title
                       message:(NSString *)message
              cancelButtonName:(NSString *)cancelButtonName
             otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonName otherButtonTitles: otherButtonTitles, nil];
    NSString *other = nil;
    va_list args;
    if (otherButtonTitles)
    {
        va_start(args, otherButtonTitles);
        while ((other = va_arg(args, NSString*)))
        {
            [alert addButtonWithTitle:other];
        }
        va_end(args);
    }
    alert.delegate = alert;
    [alert show];
    alert.alertViewCallBackBlock = alertViewCallBackBlock;
}

#pragma mark-私有函数

- (void)setAlertViewCallBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock
{
    //通过runtime  给类别增加属性  参考：http://www.tuicool.com/articles/fM73ee
    [self willChangeValueForKey:@"callbackBlock"];
    objc_setAssociatedObject(self, &UIAlertViewKey, alertViewCallBackBlock, OBJC_ASSOCIATION_COPY);
    [self didChangeValueForKey:@"callbackBlock"];
}

- (UIAlertViewCallBackBlock)alertViewCallBackBlock
{
    return objc_getAssociatedObject(self, &UIAlertViewKey);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.alertViewCallBackBlock)
    {
        self.alertViewCallBackBlock(buttonIndex);
    }
}

@end
