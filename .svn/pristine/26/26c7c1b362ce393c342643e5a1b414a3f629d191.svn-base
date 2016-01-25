//
//  AppNavView.h
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/7/6.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavViewDelegate <NSObject>

@optional
-(void)navLeftBtnDown;
-(void)navRightBtnDown;

@end

@interface AppNavView : UIView
@property (nonatomic, assign) id <NavViewDelegate> delegate;

@property (nonatomic, strong) UIView *navBackView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *navLeftBtn;
@property (nonatomic, strong) UIButton *navRightBtn;
@property (nonatomic, strong) UIImageView *leftImgView;
@property (nonatomic, strong) UIImageView *rightImgView;

@end
