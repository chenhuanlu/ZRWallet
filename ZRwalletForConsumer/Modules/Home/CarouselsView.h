//
//  CarouselsView.h
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/7/2.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarouselsPageControl.h"
#import "UIImageView+WebCache.h"

@class CarouselsView;
@protocol CarouselsViewDelegate<NSObject>

-(NSArray *)getPageOfImgArr;
-(NSTimeInterval)getTimerOfPageControl;
- (void)didClickPage:(CarouselsView *)csView atIndex:(NSInteger)index;

@end

@interface CarouselsView : UIView<UIScrollViewAccessibilityDelegate>
@property (nonatomic, assign) id<CarouselsViewDelegate> delegate;

-(void)initPage;

@end
