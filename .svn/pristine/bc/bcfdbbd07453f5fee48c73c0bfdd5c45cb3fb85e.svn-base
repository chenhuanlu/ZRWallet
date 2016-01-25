//
//  MineView.m
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/6/30.
//  Copyright (c) 2015年 文彬. All rights reserved.
//
static NSInteger btnTag = 1000;
static NSInteger viewTag = 2000;
static NSInteger titleTag = 3000;
static NSInteger lineViewTag = 4000;
static NSInteger goImgTag = 5000;

#import "MineView.h"
#import "UIColor+NSString.h"
@interface MineView ()

@end

@implementation MineView
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(void)makeMineView
{
    NSArray *titleArr =  [MineView getTitleArr];
    NSArray *picArr = [MineView getPicArr];
    self.btnNum = titleArr.count;
    
    for (int i = 0; i < self.btnNum; i++) {
        
        self.btn = [UIButton new];
        self.btn.tag = btnTag + i;
        [self.btn addTarget : self
                     action : @selector(btnDown:)
           forControlEvents : UIControlEventTouchUpInside];
        [self addSubview : self.btn];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.text = titleArr[i];
        self.titleLabel.textColor = RGBCOLOR(58, 58, 58);
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.tag = titleTag + i;
        [self addSubview:self.titleLabel];
        
        self.btnView = [UIImageView new];
        self.btnView.tag = viewTag + i;
        self.btnView.image = [UIImage imageNamed:picArr[i]];
        [self addSubview:self.btnView];
        
        self.goPageImgView = [UIImageView new];
        self.goPageImgView.tag = goImgTag + i;
        self.goPageImgView.image = [UIImage imageNamed:@"my_goPage.png"];
        [self addSubview:self.goPageImgView];
        
        if (i != self.btnNum - 1) {
            self.lineView = [UIView new];
            self.lineView.tag = lineViewTag + i;
            self.lineView.backgroundColor = [UIColor colorWithString:@"#f0f0f0"];
            [self addSubview:self.lineView];
        }
    }
    
}
+(NSArray *)getPicArr
{
    return @[@"my_manage",
             @"my_money",
             @"my_bankCard",
             @"ip_yhwd_mer"
             ];
}
+(NSArray *)getTitleArr
{
    return @[@"我的理财",
             @"我的优惠券",
             @"我的银行卡",
             @"我的商户"
             ];
}
-(void)btnDown:(UIButton *)btn
{
    NSInteger index = btn.tag - btnTag;
    [self.delegae MineViewListBtnClick:index];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    for (int i = 0 ; i < self.btnNum; i++) {
        UIButton *tempBtn = (UIButton *)[self viewWithTag:btnTag + i];
        tempBtn.size = CGSizeMake(self.frame.size.width, self.bounds.size.height/self.btnNum);
        tempBtn.viewTop = i*tempBtn.size.height;
        
        UIView *tempView = (UIView *)[self viewWithTag:viewTag + i];
        tempView.size = CGSizeMake(24, 22);
        tempView.center = tempBtn.center;
        tempView.viewLeft = tempBtn.viewLeft + 13;
        
        UIImageView *tempImg = (UIImageView *)[self viewWithTag:goImgTag + i];
        tempImg.size = CGSizeMake(22, 22);
        tempImg.viewRight = tempBtn.viewRight - 10;
        tempImg.viewCenterY = tempBtn.viewCenterY;

        UILabel *tempTitleLabel = (UILabel *)[self viewWithTag:titleTag + i];
        tempTitleLabel.size = CGSizeMake(100, 20);
        tempTitleLabel.center = tempView.center;
        tempTitleLabel.viewLeft = tempView.viewRight + 10;
        
        UIView *tempLineViw = (UIView *)[self viewWithTag:lineViewTag + i];
        tempLineViw.size = CGSizeMake(self.bounds.size.width, 1);
        tempLineViw.viewTop = tempBtn.viewBottom;
    }
  }
@end
