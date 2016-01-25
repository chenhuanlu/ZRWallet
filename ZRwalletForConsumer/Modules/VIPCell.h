//
//  VIPCell.h
//  ZRwalletForConsumer
//
//  Created by 陈焕鲁 on 15/7/22.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIPCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *merChantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bussinessLabel;
@property (weak, nonatomic) IBOutlet UILabel *merchantNameabel;

@end
