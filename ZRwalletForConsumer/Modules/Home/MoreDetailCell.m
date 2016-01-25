//
//  MoreDetailCell.m
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/7/13.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "MoreDetailCell.h"
#import "UIColor+NSString.h"

@implementation MoreDetailCell

- (void)awakeFromNib {
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel = [UILabel new];
        self.titleLabel.font = [UIFont systemFontOfSize : 16];
        [self addSubview: self.titleLabel];
        
        self.lineView = [UIView new];
        self.lineView.backgroundColor = [UIColor colorWithString:@"#f0f0f0"];
        [self addSubview:self.lineView];
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
   
    self.titleLabel.size = CGSizeMake(SCREEN_WIDTH/2, 15);
    self.titleLabel.viewTop = 10;
    self.titleLabel.viewLeft = 15;
    
    self.lineView.size = CGSizeMake(self.bounds.size.width, 1);
    self.lineView.viewTop = self.bounds.size.height - 1;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
