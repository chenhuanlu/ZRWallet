//
//  UIColor+NSString.m
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/6/30.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "UIColor+NSString.h"

int convertToInt(char c)
{
    if (c >= '0' && c <= '9') {
        return c - '0';
    } else if (c >= 'a' && c <= 'f') {
        return c - 'a' + 10;
    } else if (c >= 'A' && c <= 'F') {
        return c - 'A' + 10;
    } else {
        return printf("字符非法!");
    }
}

@implementation UIColor (NSString)
+ (UIColor *)colorWithString:(NSString *)name
{
    if (![[name substringToIndex:0] isEqualToString:@"#"] && name.length < 7) {
        return nil;
    }
    const char *str = [[name substringWithRange:NSMakeRange(1, 6)] UTF8String];
    NSString *alphaString = [name substringFromIndex:7];
    CGFloat red = (convertToInt(str[0])*16 + convertToInt(str[1])) / 255.0f;
    CGFloat green = (convertToInt(str[2])*16 + convertToInt(str[3])) / 255.0f;
    CGFloat blue = (convertToInt(str[4])*16 + convertToInt(str[5])) / 255.0f;
    CGFloat alpha = [alphaString isEqualToString:@""] ? 1 : alphaString.floatValue/255;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
@end

@implementation UIView (UMView)

- (CGFloat)viewLeft {
    return self.frame.origin.x;
}

- (void)setViewLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = ceilf(x);
    self.frame = frame;
}

- (CGFloat)viewTop {
    return self.frame.origin.y;
}

- (void)setViewTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = ceilf(y);
    self.frame = frame;
}

- (CGFloat)viewRight {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setViewRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = ceilf(right - frame.size.width);
    self.frame = frame;
}

- (CGFloat)viewBottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setViewBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = ceilf(bottom - frame.size.height);
    self.frame = frame;
}

- (CGFloat)viewCenterX {
    return self.center.x;
}

- (void)setViewCenterX:(CGFloat)centerX {
    self.center = CGPointMake(ceilf(centerX), self.center.y);
}

- (CGFloat)viewCenterY {
    return self.center.y;
}

- (void)setViewCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, ceilf(centerY));
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = ceilf(width);
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = ceilf(height);
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)removeAllSubviews {
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

- (UIImage *)imageFromView
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(self.bounds.size);
    //NSLog(@"%@", NSStringFromCGSize(self.bounds.size));
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    //[view.layer drawInContext:currnetContext];
    [self.layer renderInContext:currnetContext];
    // 从当前context中创建一个改变大小后的图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return image;
}

@end
@implementation UIView (Line)

- (void)addLine{
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 0;
    self.layer.shadowColor = [UIColor colorWithRed:205/255.0 green:203/255.0 blue:204/255.0 alpha:1].CGColor;
}
@end

@implementation UIAlertView (ShowAlert)
+(void)showAlertView:(NSString *)meg
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:meg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
+(void)showAlertView:(NSString *)meg delegate:(id /*<UIAlertViewDelegate>*/)delegate
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:meg delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alert show];
}
+(void)showAlertViewWithCancelButton:(NSString *)meg{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:meg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    [alert show];
}
@end