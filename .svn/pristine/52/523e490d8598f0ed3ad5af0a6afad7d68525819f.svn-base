//
//  UIAlertView+Additions.h
//  HelloInstallment
//
//  Created by 文彬 on 15/1/23.
//  Copyright (c) 2015年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 吴合之众
 //
 // 文件功能描述：增加UIAlertview分类  将回调放到block里 不再需要用代理和tag值方式区分处理
 
 // 注意事项：otherButtonTitles参数必须以nil结尾
 //
 ----------------------------------------------------------------*/

#import <UIKit/UIKit.h>

typedef void(^UIAlertViewCallBackBlock)(NSInteger buttonIndex);

@interface UIAlertView (Additions) <UIAlertViewDelegate>

@property (nonatomic, copy) UIAlertViewCallBackBlock alertViewCallBackBlock;

//弹出AlertView
+ (void)alertWithCallBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock
                         title:(NSString *)title
                       message:(NSString *)message
              cancelButtonName:(NSString *)cancelButtonName
             otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end
