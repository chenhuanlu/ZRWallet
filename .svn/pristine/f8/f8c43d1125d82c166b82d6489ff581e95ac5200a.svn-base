//
//  MyPreferentalCell.m
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/7/1.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "MyPreferentalCell.h"
#import "UIColor+NSString.h"

@implementation MyPreferentalCell

- (void)awakeFromNib {
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backView = [UIImageView new];
//        self.backView.image = [UIImage imageNamed:@"ip_yhq_bj_us.png"];
        self.backView.userInteractionEnabled = YES;
        self.backView.layer.masksToBounds = YES;
        self.backView.layer.cornerRadius = 4.0;
        [self addSubview:self.backView];
        
        self.titleLabel = [UILabel new];
//        self.titleLabel.text = @"桂林米粉苏州街店";
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        self.titleLabel.textColor = [UIColor colorWithString:@"#434343"];
        [self.backView addSubview: self.titleLabel];
        
        self.addressLabel = [UILabel new];
//        self.addressLabel.text = @"店铺详细地址店铺详细地址店铺详细地址";
        self.addressLabel.textColor = RGBCOLOR(180, 180, 180);
        self.addressLabel.numberOfLines = 2;
        self.addressLabel.font = [UIFont systemFontOfSize:10];
        [self.backView addSubview:self.addressLabel];
        
        self.moneyLabel = [UILabel new];
//        self.moneyLabel.text = @"￥20.00";
        self.moneyLabel.textAlignment = NSTextAlignmentRight;
        self.moneyLabel.font = [UIFont boldSystemFontOfSize:26];
        self.moneyLabel.textColor = RGBCOLOR(206, 0, 33);
        [self.backView addSubview:self.moneyLabel];
        
        self.infoLabel = [UILabel new];
        self.infoLabel.textAlignment = NSTextAlignmentCenter;
        self.infoLabel.font = [UIFont systemFontOfSize:10];
//        self.infoLabel.backgroundColor = RGBCOLOR(206, 0, 33);
        self.infoLabel.textColor = [UIColor whiteColor];
        self.infoLabel.layer.cornerRadius = 4.0;
        self.infoLabel.layer.masksToBounds = YES;
        [self.backView addSubview:self.infoLabel];
        
        self.dateLabel = [UILabel new];
//        self.dateLabel.text = @"使用期限 2012-12-12 至 2012-12-12";
        self.dateLabel.textAlignment = NSTextAlignmentLeft;
        self.dateLabel.font = [UIFont systemFontOfSize:10];
        self.dateLabel.textColor = RGBCOLOR(180, 180, 180);
        [self.backView addSubview:self.dateLabel];
        
        self.phoneBtn = [UIButton new];
        [self.phoneBtn setImage:[UIImage imageNamed:@"ip_yhq_tel"] forState:UIControlStateNormal];
        [self.backView addSubview:self.phoneBtn];
        
               
        self.QRImgViewBtn = [UIButton new];
        self.QRImgViewBtn.backgroundColor = [UIColor clearColor];
        self.QRImgViewBtn.imageView.layer.cornerRadius = 2.0;
        self.QRImgViewBtn.imageView.layer.masksToBounds = YES;
        self.QRImgViewBtn.userInteractionEnabled = YES;
        [self.backView addSubview:self.QRImgViewBtn];
        
        self.phoneNumLabel = [UILabel new];
//        self.phoneNumLabel.text = @"13113131313";
        self.phoneNumLabel.textAlignment = NSTextAlignmentCenter;
        self.phoneNumLabel.font = [UIFont systemFontOfSize:9];
        [self.backView addSubview:self.phoneNumLabel];
        
        self.lineImgView = [UIImageView new];
        self.lineImgView.image = [UIImage imageNamed:@"an_yhq_line.png"];
        [self.backView addSubview:self.lineImgView];

        //选中优惠券时的对勾图片
        self.selectImg = [[UIImageView alloc]init];
        self.selectImg.image = [UIImage imageNamed:@"ip_yhq_bj_choo"];
        [self.backView addSubview:self.selectImg];
      

        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.backView.size = CGSizeMake(SCREEN_WIDTH-10, self.bounds.size.height - 10);
    self.backView.viewTop = 5;
    self.backView.viewLeft = 5;
    
    self.titleLabel.size = CGSizeMake(SCREEN_WIDTH, 14);
    self.titleLabel.viewTop = 10;
    self.titleLabel.viewLeft = 10;
    
    self.addressLabel.size = CGSizeMake(SCREEN_WIDTH/2.4, 30);
    self.addressLabel.viewTop = self.titleLabel.viewBottom + 3;
    self.addressLabel.viewLeft = self.titleLabel.viewLeft;
    
    self.moneyLabel.size = CGSizeMake(120, 40);
    self.moneyLabel.viewTop = 5;
    self.moneyLabel.viewRight = self.viewRight - 80;
    
    self.infoLabel.size = CGSizeMake(self.addressLabel.size.width, 15);
    self.infoLabel.viewTop = self.addressLabel.viewBottom;
    self.infoLabel.viewLeft = self.titleLabel.viewLeft;
    
    self.dateLabel.size = CGSizeMake(SCREEN_WIDTH/1.7, 15);
    self.dateLabel.viewBottom = self.backView.viewBottom - 15;
    self.dateLabel.viewLeft = self.titleLabel.viewLeft;
    
    self.QRImgViewBtn.size = CGSizeMake(30, 30);
    self.QRImgViewBtn.viewBottom = self.infoLabel.viewBottom;
    self.QRImgViewBtn.viewRight = self.size.width - 40;
    
    self.phoneNumLabel.size = CGSizeMake(self.QRImgViewBtn.size.width + 30, 10);
    self.phoneNumLabel.viewCenterX = self.QRImgViewBtn.viewCenterX;
    self.phoneNumLabel.viewTop = self.QRImgViewBtn.viewBottom;
    
    self.lineImgView.size = CGSizeMake(5, self.backView.size.height/2 - 10);
    self.lineImgView.viewRight = self.QRImgViewBtn.viewLeft - 15;
    self.lineImgView.viewBottom = self.dateLabel.viewBottom - 5;
    
    self.phoneBtn.size = CGSizeMake(30,30);
    self.phoneBtn.viewTop = self.moneyLabel.viewBottom;
    self.phoneBtn.viewRight = self.lineImgView.viewLeft - 15;
    
    [self.selectImg makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
