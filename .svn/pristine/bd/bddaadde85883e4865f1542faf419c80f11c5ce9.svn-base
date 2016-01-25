//
//  InvestmentRecordCell.m
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/7/19.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "InvestmentRecordCell.h"
#import "UIColor+NSString.h"

@implementation InvestmentRecordCell

- (void)awakeFromNib {
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.usePhone = [UILabel new];
        self.usePhone.font = [UIFont systemFontOfSize : 16];
        self.usePhone.textAlignment = NSTextAlignmentCenter;
        [self addSubview: self.usePhone];
        
        self.volume = [UILabel new];
        self.volume.font = [UIFont systemFontOfSize : 16];
        self.volume.textAlignment = NSTextAlignmentCenter;
        [self addSubview: self.volume];
        
        self.insertTime = [UILabel new];
        self.insertTime.font = [UIFont systemFontOfSize : 16];
        self.insertTime.textAlignment = NSTextAlignmentCenter;
        [self addSubview: self.insertTime];
        
        self.lineView = [UIView new];
        self.lineView.backgroundColor = [UIColor colorWithString:@"#f0f0f0"];
        [self addSubview:self.lineView];
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.usePhone.size = CGSizeMake(SCREEN_WIDTH/3, 12);
    self.usePhone.viewCenterY = self.bounds.size.height/2;
    self.usePhone.viewLeft = 0;
    
    self.volume.size = CGSizeMake(self.usePhone.size.width, 12);
    self.volume.viewCenterY = self.bounds.size.height/2;;
    self.volume.viewLeft = SCREEN_WIDTH/3;
    
    self.insertTime.size = CGSizeMake(self.usePhone.size.width, 12);
    self.insertTime.viewCenterY = self.bounds.size.height/2;;
    self.insertTime.viewLeft = SCREEN_WIDTH/3*2;
    
    self.lineView.size = CGSizeMake(self.bounds.size.width, 1);
    self.lineView.viewTop = self.bounds.size.height - 1;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
