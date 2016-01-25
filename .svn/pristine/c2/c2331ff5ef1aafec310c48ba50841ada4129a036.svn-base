//
//  MyCreditCell.m
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/7/19.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "MyCreditCell.h"
#import "UIColor+NSString.h"

@implementation MyCreditCell

- (void)awakeFromNib {
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backView = [UIImageView new];
        self.backView.backgroundColor = RGBCOLOR(223, 74, 78);
        self.backView.userInteractionEnabled = YES;
        self.backView.layer.masksToBounds = YES;
        self.backView.layer.cornerRadius = 4.0;
        [self addSubview:self.backView];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.backView.size = CGSizeMake(SCREEN_WIDTH - 20, self.bounds.size.height - 10);
    self.backView.viewTop = 10;
    self.backView.viewLeft = 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
