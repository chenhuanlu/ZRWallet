//
//  MineView.h
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/6/30.
//  Copyright (c) 2015年 文彬. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 中融钱包
 //
 // 文件功能描述：我的 列表模块
 
 // 注意事项：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>


@protocol MineViewDelegate <NSObject>

//-(NSArray *)getMineViewBtnViewTitleArr;
//-(NSArray *)getMineViewBtnViewPicArr;
//-(NSInteger)getMineViewBtnViewBtnNum;
-(void)MineViewListBtnClick:(NSInteger)index;


@end

@interface MineView : UIView
@property (nonatomic, assign) id <MineViewDelegate> delegae;

@property (nonatomic, assign) NSInteger btnNum;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIImageView *btnView;
@property (nonatomic, strong) UIImageView *goPageImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;


-(void)makeMineView;
@end
