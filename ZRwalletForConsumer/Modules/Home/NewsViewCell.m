//
//  NewsViewCell.m
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/7/21.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "NewsViewCell.h"
#import "UIColor+NSString.h"
@implementation NewsViewCell

- (void)awakeFromNib {
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel = [UILabel new];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview: self.titleLabel];
        
        self.newsLabel = [UILabel new];
        self.newsLabel.font = [UIFont boldSystemFontOfSize:14];
        self.newsLabel.textColor = [UIColor grayColor];
        [self addSubview: self.newsLabel];
        
        self.readImgView = [UIImageView new];
        [self addSubview: self.readImgView];
        
        self.dateLabel = [UILabel new];
        self.dateLabel.font = [UIFont systemFontOfSize:12];
        self.dateLabel.textColor = RGBCOLOR(166, 166, 166);
        [self addSubview: self.dateLabel];
        
        self.lineView = [UIView new];
        self.lineView.backgroundColor = [UIColor colorWithString:@"#f0f0f0"];
        [self addSubview:self.lineView];

        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.readImgView.size = CGSizeMake(20, 20);
    self.readImgView.viewTop = 10;
    self.readImgView.viewLeft = 10;

    self.titleLabel.size = CGSizeMake(self.bounds.size.width/2, 15);
    self.titleLabel.viewTop = self.readImgView.viewTop + 2;
    self.titleLabel.viewLeft = self.readImgView.viewRight + 5;
    
    self.dateLabel.size = CGSizeMake(self.bounds.size.width/3, 15);
    self.dateLabel.viewBottom = self.bounds.size.height - 10;
    self.dateLabel.viewRight = self.bounds.size.width - 10;
    
    self.lineView.size = CGSizeMake(self.bounds.size.width, 1);
    self.lineView.viewTop = self.bounds.size.height - 1;

}
@end
