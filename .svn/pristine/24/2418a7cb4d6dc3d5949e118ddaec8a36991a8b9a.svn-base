//
//  KDGoalBarPercentLayer.m
//  AppearanceTest
//
//  Created by Kevin Donnelly on 1/10/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import "KDGoalBarPercentLayer.h"

#define toRadians(x) ((x)*M_PI / 180.0)
#define toDegrees(x) ((x)*180.0 / M_PI)

#define kCicleWidth 5  //大圈宽度
#define kLitleCicleRadio 30 //小圆直径

@implementation KDGoalBarPercentLayer
@synthesize percent, color;

-(void)drawInContext:(CGContextRef)ctx {
    
    CGPoint center = CGPointMake(self.frame.size.width / (2), self.frame.size.height / (2));

    CGFloat delta = toRadians(360 * percent);
    
    int distance = kLitleCicleRadio/2-kCicleWidth/2;
    
    CGFloat innerRadius = self.bounds.size.width/2-distance-kCicleWidth;
    CGFloat outerRadius = self.bounds.size.width/2-distance;
    
//    if (color) {
//        CGContextSetFillColorWithColor(ctx, color.CGColor);
//    } else {
//        CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:99/256.0 green:183/256.0 blue:70/256.0 alpha:.5].CGColor);
//    }
    

    CGContextSetLineWidth(ctx, 1);
    
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    CGContextSetAllowsAntialiasing(ctx, YES);
    

    //背景环形
    CGMutablePathRef bgpath = CGPathCreateMutable();
    CGContextSetFillColorWithColor(ctx,[UIColor colorWithRed:245/256.0 green:191/256.0 blue:203/256.0 alpha:1].CGColor);
    CGPathAddRelativeArc(bgpath, NULL, center.x, center.y, innerRadius, -(M_PI / 2), toRadians(360 * 100));
    CGPathAddRelativeArc(bgpath, NULL, center.x, center.y, outerRadius, toRadians(360 * 100) - (M_PI / 2), -toRadians(360 * 100));
    CGPathAddLineToPoint(bgpath, NULL, center.x, center.y-innerRadius);
    
    CGContextAddPath(ctx, bgpath);
    CGContextFillPath(ctx);
    
    
    //进度环形
    CGMutablePathRef path = CGPathCreateMutable();
     CGContextSetFillColorWithColor(ctx,[UIColor colorWithRed:207/256.0 green:0/256.0 blue:33/256.0 alpha:1].CGColor);
    CGPathAddRelativeArc(path, NULL, center.x, center.y, innerRadius, -(M_PI / 2), delta);
    CGPathAddRelativeArc(path, NULL, center.x, center.y, outerRadius, delta - (M_PI / 2), -delta);
    CGPathAddLineToPoint(path, NULL, center.x, center.y-innerRadius);
    
    CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    
    
    if (self.showCicle)
    {
        //进度小圆形
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:207/256.0 green:0/256.0 blue:33/256.0 alpha:1].CGColor);
        
        CGRect rect = CGRectMake(0, 0, kLitleCicleRadio, kLitleCicleRadio);
        
        CGFloat angle = percent * (2 * M_PI) - (M_PI/2);
        rect.origin.x = center.x + (outerRadius-kCicleWidth/2) * cosf(angle) - (rect.size.width/2);
        rect.origin.y = center.y + (outerRadius-kCicleWidth/2) * sinf(angle) - (rect.size.height/2);
        CGContextAddEllipseInRect(ctx, rect);
        CGContextFillPath(ctx);
        
        CGContextSetRGBFillColor (ctx, 0.0, 1.0, 0.0, 1.0);
//        UIFont *font = [UIFont boldSystemFontOfSize:11.0];
        
       // [[NSString stringWithFormat:@"%d%",percent*100] drawInRect:rect withFont:font];
        
        
        
//        //绘制文本
//        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc]init];
//        paragraph.alignment = NSTextAlignmentCenter; //设置段落样式
//        
//        
//        NSDictionary *dic = @{
//                              NSFontAttributeName : font,                              //设置字体
//                              NSParagraphStyleAttributeName : paragraph,               //设置段落样式
//                              NSForegroundColorAttributeName : [UIColor whiteColor],   //设置文字颜色
//                              NSStrokeWidthAttributeName : @1,                         //调整字句描边宽度
//                              NSStrokeColorAttributeName : [UIColor greenColor]        //设置文字描边颜色
//                              
//                              };
//        
//        
//        [[NSString stringWithFormat:@"%f%%",percent*100] drawInRect:rect withAttributes:dic];
        
        //**********************圆形内进度文字*********************
        NSString *text = [NSString stringWithFormat:@"%.0f%%",percent*100] ;
        UIFont* font = [UIFont systemFontOfSize:11];
        NSDictionary *textAttributes = @{NSFontAttributeName: font};
        
        CGRect srect = [text boundingRectWithSize:CGSizeMake(rect.size.width, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:textAttributes
                                          context:nil];
        
        CGSize size = srect.size;
        float x_pos = (rect.size.width - size.width) / 2;
        float y_pos = (rect.size.height - size.height) /2;
        UIGraphicsPushContext(ctx);
        NSDictionary * attributes = @{NSFontAttributeName : font,
                                      NSForegroundColorAttributeName : [UIColor whiteColor]};
        [text drawAtPoint:CGPointMake(rect.origin.x + x_pos, rect.origin.y + y_pos)  withAttributes:attributes];
        UIGraphicsPopContext();

    }
 
    
    CFRelease(path);
    
}

@end
