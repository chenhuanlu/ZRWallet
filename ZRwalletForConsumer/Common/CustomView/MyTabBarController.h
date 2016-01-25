//
//  MyTabBarController.h
//  ALCommon
//
//  Created by 文彬 on 15-1-24.
//
//
/*----------------------------------------------------------------
 // Copyright (C) 中融钱包
 //
 // 文件功能描述：自定义tabbarcontroller
 
 // 注意事项：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>
typedef void(^MiddleButtonClickBlock)();

@interface MyTabBarController : UITabBarController

@property (strong, nonatomic) MiddleButtonClickBlock middleButtonClick; //中间按钮点击后回调

//设置图片等属性
- (void)setImages:(NSArray*)imgs;

//设置当前选择项
- (void)selectTabAtIndex:(NSInteger)index;

@end
