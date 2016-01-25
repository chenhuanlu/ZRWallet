//
//  SDKQRView.h
//  ZRwalletForConsumer
//
//  Created by 邵梦 on 15/7/10.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class SDKQRView;
typedef void(^SDKQRCallBack)(NSString *qrString, SDKQRView *qrView, BOOL isAuthorized);

@interface SDKQRView : UIView <AVCaptureMetadataOutputObjectsDelegate>
// 初始化，并且设置识别成功的回调block
- (instancetype)initWithCallBack:(SDKQRCallBack)callBack;
// 识别是连续的，一般在block回调的时候需要停止识别，等需要时再启动。
- (void)start;
- (void)stop;

// 生成qrImage
+ (UIImage *)qrImageWithString:(NSString *)string size:(CGSize)size;

@end
