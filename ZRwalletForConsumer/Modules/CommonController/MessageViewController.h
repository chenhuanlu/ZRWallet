//
//  ErrorViewController.h
//  POS4iPhone_PeoplePay
//
//  Created by 文彬 on 14-5-21.
//  Copyright (c) 2014年 文彬. All rights reserved.
//
// Copyright (C)
//
/*----------------------------------------------------------------
 // Copyright (C) 中融钱包
 //
 // 文件功能描述：信息提示页面
 
 // 注意事项：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef enum
{
    kMessageTypeSeccuss, //显示成功图片
    kMessageTypeFail,    //显示失败图片
    kMessageTypeNomal    //只有提示文字，没有图片
}kMessageType;

typedef void(^ButtonClickBlock)();

@interface MessageViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *messLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (strong, nonatomic) ButtonClickBlock clickBlock; //点击确定按钮后的回调操作
@property (strong, nonatomic) NSString *messStr; //提示文字
@property (assign, nonatomic) kMessageType messType; 

- (IBAction)buttonClickHandle:(id)sender;

@end
