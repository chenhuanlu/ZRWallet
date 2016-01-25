//
//  AppNavView.m
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/7/6.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "AppNavView.h"
#import "UIColor+NSString.h"

@implementation AppNavView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeNav];
    }
    return self;
}

-(void)makeNav
{
    self.navBackView = [UIView new];
    self.navBackView.userInteractionEnabled = YES;
    self.navBackView.backgroundColor = RGBCOLOR(206, 0, 33);
    [self addSubview: self.navBackView];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.text = @"";
    [self addSubview:self.titleLabel];
    
    self.navLeftBtn = [UIButton new];
    [self.navLeftBtn addTarget:self action:@selector(leftBtnDown) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.navLeftBtn];
    
    self.leftImgView = [UIImageView new];
    [self.navLeftBtn addSubview:self.leftImgView];
    
    self.navRightBtn = [UIButton new];
    [self.navRightBtn addTarget:self action:@selector(rightBtnDown) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.navRightBtn];
    
    self.rightImgView = [UIImageView new];
    [self.navRightBtn addSubview:self.rightImgView];
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.navBackView.frame = self.bounds;
    self.titleLabel.size = CGSizeMake(SCREEN_WIDTH, 20);
    self.titleLabel.viewCenterY = self.bounds.size.height/2 + 10;
    
    self.navLeftBtn.size = CGSizeMake(60, 44);
    self.navLeftBtn.viewTop = 20;
    
    self.leftImgView.size = CGSizeMake(17, 22);
    self.leftImgView.viewLeft = 10;
    self.leftImgView.viewCenterY = self.navLeftBtn.size.height/2 + 2;
    
    self.navRightBtn.size = self.navLeftBtn.size;
    self.navRightBtn.viewTop = self.navLeftBtn.viewTop;
    self.navRightBtn.viewRight = self.size.width;
    
    self.rightImgView.size = CGSizeMake(25, 25);
    self.rightImgView.viewRight = self.navRightBtn.size.width - 15;
    self.rightImgView.viewCenterY = self.navRightBtn.size.height/2 + 2;
    
}
-(void)leftBtnDown
{
    [[HttpRequest sharedRequest] cancelLastRequst];
    if ([self.delegate respondsToSelector:@selector(navLeftBtnDown)])
    {
        [self.delegate navLeftBtnDown];
    }
    
}
-(void)rightBtnDown
{
    if ([self.delegate respondsToSelector:@selector(navRightBtnDown)])
    {
        [self.delegate navRightBtnDown];
    }
}
@end
