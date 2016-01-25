//
//  BillModel.h
//  ZRwalletForConsumer
//
//  Created by 陈焕鲁 on 15/7/23.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillModel : NSObject
@property (copy,nonatomic) NSString *changeAmount;
@property (copy,nonatomic) NSString *detail;
@property (copy,nonatomic) NSString *investOrderId;
@property (copy,nonatomic) NSString *operationDate;
@property (copy,nonatomic) NSString *operationType;
@property (copy,nonatomic) NSString *qrPaymentOrderId;
@property (copy,nonatomic) NSString *rechargeOrderId;
@property (copy,nonatomic) NSString *withdrawOrderId;
@end
