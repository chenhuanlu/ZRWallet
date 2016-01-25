//
//  CarouselsPageControl.h
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/7/2.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarouselsPageControl : UIView
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageCount;

- (void)setImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage forKey:(NSString *)key;

@end
