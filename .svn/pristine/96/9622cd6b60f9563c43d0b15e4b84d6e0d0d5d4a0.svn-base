//
//  UIColor+NSString.h
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/6/30.
//  Copyright (c) 2015年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 吴合之众
 //
 // 文件功能描述：方便取颜色字符串
 
 // 注意事项：以#开头的字符串（不区分大小写），如：#ffFFff，若需要alpha，则传#abcdef255，不传默认为1
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface UIColor (NSString)

+ (UIColor *)colorWithString:(NSString *)name;
@end

@interface UIView (UMView)

- (CGFloat)viewLeft;
- (void)setViewLeft:(CGFloat)x;
- (CGFloat)viewTop;
- (void)setViewTop:(CGFloat)y;
- (CGFloat)viewRight;
- (void)setViewRight:(CGFloat)right;
- (CGFloat)viewBottom;
- (void)setViewBottom:(CGFloat)bottom;
- (CGFloat)viewCenterX;
- (void)setViewCenterX:(CGFloat)centerX;
- (CGFloat)viewCenterY;
- (void)setViewCenterY:(CGFloat)centerY;
- (CGFloat)width;
- (void)setWidth:(CGFloat)width;
- (CGFloat)height;
- (void)setHeight:(CGFloat)height;
- (CGPoint)origin;
- (void)setOrigin:(CGPoint)origin;
- (CGSize)size;
- (void)setSize:(CGSize)size;
- (void)removeAllSubviews;

- (UIImage *)imageFromView;

@end

@interface UIView (Line)

- (void)addLine;

@end

@interface UIAlertView (ShowAlert)
+(void)showAlertView:(NSString *)meg;
+(void)showAlertView:(NSString *)meg delegate:(id /*<UIAlertViewDelegate>*/)delegate;
+(void)showAlertViewWithCancelButton:(NSString *)meg;

@end
