//
//  MyManageCell.m
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/7/1.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "MyManageCell.h"
#import "UIColor+NSString.h"
@implementation MyManageCell

- (void)awakeFromNib {
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backView = [UIView new];
        self.backView.backgroundColor = [UIColor whiteColor];
        self.backView.layer.borderColor = [UIColor colorWithString:@"#f0f0f0"].CGColor;
        self.backView.layer.borderWidth = 1.0;
        self.backView.layer.cornerRadius = 3.0;
        self.backView.layer.masksToBounds = YES;
        [self addSubview:self.backView];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.text = @"项目名称";
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.backView addSubview: self.titleLabel];
        
        self.dateLabel = [UILabel new];
        self.dateLabel.text = @"投标时间";
        self.dateLabel.font = [UIFont boldSystemFontOfSize:12];
        self.dateLabel.textColor = [UIColor grayColor];
        [self.backView addSubview: self.dateLabel];

        self.investLabel = [UILabel new];
        self.investLabel.text = @"投标金额";
        self.investLabel.font = [UIFont boldSystemFontOfSize:12];
        self.investLabel.textColor = [UIColor grayColor];
        [self.backView addSubview: self.investLabel];
        
        self.rateLabel = [UILabel new];
        self.rateLabel.text = @"年利率";
        self.rateLabel.font = [UIFont boldSystemFontOfSize:12];
        self.rateLabel.textColor = [UIColor grayColor];
        [self.backView addSubview: self.rateLabel];
        
        self.incomLabel = [UILabel new];
        self.incomLabel.text = @"预计收益";
        self.incomLabel.font = [UIFont boldSystemFontOfSize:12];
        self.incomLabel.textColor = [UIColor grayColor];
        [self.backView addSubview: self.incomLabel];
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.backView.size = CGSizeMake(self.size.width - 20, self.size.height - 10);
    self.backView.viewLeft = 10;
    self.backView.viewTop = 10;
    
//    self.titleLabel.size = CGSizeMake(100, 15);
    self.titleLabel.viewTop = 10;
    self.titleLabel.viewLeft = 20;
    
    self.dateLabel.size = CGSizeMake(SCREEN_WIDTH/2 - 10, 15);
    self.dateLabel.viewLeft = self.titleLabel.viewLeft;
    self.dateLabel.viewTop = self.titleLabel.viewBottom + 10;
    
    self.investLabel.size = self.dateLabel.size;
    self.investLabel.viewLeft = self.dateLabel.viewLeft;
    self.investLabel.viewBottom = self.backView.viewBottom - 20;
    
    self.rateLabel.size = self.dateLabel.size;
    self.rateLabel.viewRight =self.backView.viewRight;
    self.rateLabel.viewTop = self.dateLabel.viewTop;
    
    self.incomLabel.size = self.dateLabel.size;
    self.incomLabel.viewRight = self.backView.viewRight;
    self.incomLabel.viewTop = self.investLabel.viewTop;
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
