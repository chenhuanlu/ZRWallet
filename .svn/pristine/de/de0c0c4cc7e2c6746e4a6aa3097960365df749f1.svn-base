//
//  MineViewController.h
//  ZRwalletForMerchant
//
//  Created by 文彬 on 15/6/29.
//  Copyright (c) 2015年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 中融钱包
 //
 // 文件功能描述：我的--首页
 
 // 注意事项：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "MineView.h"
typedef NS_ENUM(NSInteger, PAGE)
{
    PAGE_MANAGE               = 0,   //我的理财
    PAGE_PREFERENTIAL         = 1,   //我的优惠劵
    PAGE_CARD                 = 2,   //我的银行卡
    PAGE_MEMBER               = 3    //我的商户
};
@interface MineViewController : UIViewController<MineViewDelegate,UIScrollViewAccessibilityDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,assign) PAGE page;

@end
