//
//  BaseViewController.h
//  
//
//  Created by 文彬 on 14-5-11.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 中融钱包
 //
 // 文件功能描述：页面基类  定制导航栏返回按钮 原则上所有页面都得继承自此类
 
 // 注意事项：
 //
 ----------------------------------------------------------------*/

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
{
    float keyBoardLastHeight;
    BOOL addKeyBoardNotification; //是否添加键盘通知
}
//返回按钮点击
- (void)back;

//增加键盘显示、隐藏的通知
- (void)addKeyboardNotification;

//键盘显示时调用
- (void)keyBoardShowWithHeight:(float)height;

//键盘隐藏时调用
- (void)keyBoardHidden;

- (void)initNavgationcontrollerLeftButton;
@end
