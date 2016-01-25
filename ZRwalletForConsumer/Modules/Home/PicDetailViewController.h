//
//  PicDetailViewController.h
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/7/13.
//  Copyright (c) 2015年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 中融钱包
 //
 // 文件功能描述：首页 - 项目详情 - 更多详情 - 图片浏览
 
 // 注意事项：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface PicDetailViewController : UIViewController<UIScrollViewAccessibilityDelegate>
@property (nonatomic, strong) UIImageView *picImgView;
@property (nonatomic, strong) UIScrollView *scrView;
@property (nonatomic, strong) NSArray *picArr;
@property (nonatomic, strong) NSString *currentIndex;
//图片放大的rect
//@property (nonatomic, strong) NSArray *scaleArray;
//-(void)updatePicWithIndex:(int)index picData:(UIImage *)imge;
@end
