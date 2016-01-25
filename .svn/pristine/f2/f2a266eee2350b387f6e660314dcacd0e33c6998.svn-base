//
//  SecurityTool.m
//  ZRwalletForConsumer
//
//  Created by 陈焕鲁 on 15/7/22.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "SecurityTool.h"
#import <CommonCrypto/CommonDigest.h>

@implementation SecurityTool

/**
 *  MD5加密
 *
 *  @param str 原数据
 *
 *  @return 加密后数据
 */
+ (NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
