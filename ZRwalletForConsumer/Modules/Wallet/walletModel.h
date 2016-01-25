//
//  walletModel.h
//  ZRwalletForConsumer
//
//  Created by 陈焕鲁 on 15/7/22.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface walletModel : NSObject
@property (copy,nonatomic) NSString *cashBalance;
@property (copy,nonatomic) NSString *frozenAmount;
@property (copy,nonatomic) NSString *unEarningAmount;
@property (copy,nonatomic) NSString *userEarningAmount;
@property (copy,nonatomic) NSString *billAmount;
@property (copy,nonatomic) NSString *creditAvailableAmount;
@end
