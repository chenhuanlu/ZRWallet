//
//  ScanViewController.h
//  ZRwalletForConsumer
//
//  Created by 陈焕鲁 on 15/7/3.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

#import "MASUtilities.h"
#import "View+MASAdditions.h"
#import "View+MASShorthandAdditions.h"
#import "NSArray+MASAdditions.h"
#import "NSArray+MASShorthandAdditions.h"
#import "MASConstraint.h"

@interface ScanViewController : UIViewController
{
    UIImageView *_lightView;    //激光条
//    ZBarReaderView *_readview;  //扫描视图
    CGRect scanMaskRect;        //默认扫描边框的区域
}
@property (nonatomic, strong) NSString *scanStr;//扫描结果
@end
