//
//  ScanViewController.m
//  ZRwalletForConsumer
//
//  Created by 陈焕鲁 on 15/7/3.
//  Copyright (c) 2015年 文彬. All rights reserved.
//
//颜色
#define ColorWithString(str)     [UIColor colorWithString:str]
#define Color_subView            [UIColor redColor]
#define kTag_Alert_Net 101  //网址
#define kTag_Alert_Word 102 //字符串

#define kTag_Button_Back 200 //返回按钮
#define kTag_Button_Light 201 //闪光灯开关
#define kTag_Button_PicSelect 202 //选择相册里的图片

#import "ScanViewController.h"
#import "ZBarSDK.h"
#import "UIColor+NSString.h"
#import "PaymentViewController.h"
#import <AVFoundation/AVFoundation.h>

//#import "Transfer.h"
@interface ScanViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZBarReaderViewDelegate,ZBarReaderDelegate>
{
    //设置扫描区域
    
    UIView *_scanView;
    
    ZBarReaderView *_readerView;
}
@property (nonatomic, strong) UIImageView *onePartImg;
@property (nonatomic, strong) UIImageView *twoPartImg;
@property (nonatomic, strong) UIImageView *threePartImg;
@property (nonatomic, strong) UIImageView *fourPartImg;

//四边绿色角

@property (nonatomic, strong) UIImageView *subOnePartImg;
@property (nonatomic, strong) UIImageView *subTwoPartImg;
@property (nonatomic, strong) UIImageView *subThreePartImg;
@property (nonatomic, strong) UIImageView *subFourPartImg;
@property (nonatomic, strong) UIImageView *subFivePartImg;
@property (nonatomic, strong) UIImageView *subSixPartImg;
@property (nonatomic, strong) UIImageView *subSevenPartImg;
@property (nonatomic, strong) UIImageView *subEightPartImg;
@property (nonatomic, strong) UILabel *albumLabel;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = YES;
    self.view.userInteractionEnabled = YES;
    
    [self ZBarReaderView];
    [self makeView];
   
    
    //若在扫描页面 使程序进入后台  再次点开程序时 扫描页面不动  需要程序进入前台时主动复原动画
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initScan) name:kBecomeActivie object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initScan];
    
    [self checkCamaraAuth];
}

#pragma mark 功能函数

/**
 *  初始化扫描
 */
- (void)initScan
{
    
    if (_readerView)
    {
        [_readerView removeFromSuperview];
    }
    [self.view addSubview:_readerView];
    [self.view sendSubviewToBack:_readerView];
    [_readerView start];
    
    [self.view addSubview:_lightView];
    
    [CATransaction begin]; //可在begin和commit之间设置多个动画 一起调用
    [_lightView.layer addAnimation:[self lightViewPathAnimation] forKey:nil];
    [CATransaction commit];
   
}

/**
 *  初始化扫描控件
 */
- (void)ZBarReaderView
{
    
    //设置扫描区域
    float height = (ScreenHeight-(SCREEN_WIDTH-40))/2;
    scanMaskRect =CGRectMake(20, height-20, SCREEN_WIDTH-40, SCREEN_WIDTH-40);
    
    _readerView = [[ZBarReaderView alloc]init];
    _readerView.allowsPinchZoom = NO;//不使用Pinch手势变焦
    _readerView.frame =CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
    //    _readerView.tracksSymbols = YES;//跟踪边框
    _readerView.readerDelegate = self;
    //    [_readerView addSubview:_scanView];
    //关闭闪光灯
    _readerView.torchMode = 0;//0为关闭 1为打开
    
    //扫描区域计算
    CGRect scanRect =[self getScanCrop:scanMaskRect readerViewBounds:_readerView.bounds];
    _readerView.scanCrop = scanRect;
    
    
    _lightView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 80,SCREEN_WIDTH - 40, 15)];
    _lightView.contentMode = UIViewContentModeScaleAspectFill;
    [_lightView setImage:[UIImage imageNamed:@"ip_sys_line_n"]];
    
}

- (void)checkCamaraAuth
{
    NSString *mediaType = AVMediaTypeVideo;// Or AVMediaTypeAudio
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    NSLog(@"---cui--authStatus--------%d",authStatus);
    // This status is normally not visible—the AVCaptureDevice class methods for discovering devices do not return devices the user is restricted from accessing.
    if(authStatus ==AVAuthorizationStatusRestricted){
        NSLog(@"Restricted");
    }else if(authStatus == AVAuthorizationStatusDenied){
        // The user has explicitly denied permission for media capture.
        NSLog(@"Denied");     //应该是这个，如果不允许的话
        
        [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } title:@"提示" message:@"请在设备的\"设置-隐私-相机\"中允许本程序访问相机。" cancelButtonName:@"确定" otherButtonTitles:nil];
        
        return;
    }
    else if(authStatus == AVAuthorizationStatusAuthorized){//允许访问
        // The user has explicitly granted permission for media capture, or explicit user permission is not necessary for the media type in question.
        NSLog(@"Authorized");
        
    }else if(authStatus == AVAuthorizationStatusNotDetermined){
        // Explicit user permission is required for media capture, but the user has not yet granted or denied such permission.
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if(granted){//点击允许访问时调用
                //用户明确许可与否，媒体需要捕获，但用户尚未授予或拒绝许可。
                NSLog(@"Granted access to %@", mediaType);
            }
            else {
                NSLog(@"Not granted access to %@", mediaType);
                
                [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
                    
                    
                } title:@"提示" message:@"二维码扫描必须通过手机摄像头，禁止防伪相机将不能正常使用二维码扫描功能" cancelButtonName:@"确定" otherButtonTitles:nil];
            }
            
        }];
    }else {
        NSLog(@"Unknown authorization status");
    }
}


- (CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    
    CGFloat x,y,width,height;
    x = rect.origin.y / readerViewBounds.size.height;
    y = 1 - (rect.origin.x + rect.size.width) / readerViewBounds.size.width;
    width = (rect.origin.y + rect.size.height) / readerViewBounds.size.height;
    height = 1 - rect.origin.x / readerViewBounds.size.width;
    return CGRectMake(x, y, width, height);
}

/**
 *  初始化视图
 */
-(void)makeView
{
    //四边绿色角
    
    self.onePartImg = [UIImageView new];
    self.onePartImg.backgroundColor = [UIColor blackColor];
    self.onePartImg.alpha = 0.5;
    [self.view addSubview:self.onePartImg];
    
    self.twoPartImg = [UIImageView new];
    self.twoPartImg.backgroundColor = [UIColor blackColor];
    self.twoPartImg.alpha = 0.5;
    [self.view addSubview:self.twoPartImg];
    
    
    self.threePartImg = [UIImageView new];
    self.threePartImg.backgroundColor = [UIColor blackColor];
    self.threePartImg.alpha = 0.5;
    [self.view addSubview:self.threePartImg];
    
    self.fourPartImg = [UIImageView new];
    self.fourPartImg.backgroundColor = [UIColor blackColor];
    self.fourPartImg.alpha = 0.5;
    [self.view addSubview:self.fourPartImg];
    
    self.subOnePartImg = [UIImageView new];
    self.subOnePartImg.backgroundColor = Color_subView;
    [self.view addSubview:self.subOnePartImg];
    
    self.subTwoPartImg = [UIImageView new];
    self.subTwoPartImg.backgroundColor = Color_subView;
    [self.view addSubview:self.subTwoPartImg];
    
    self.subThreePartImg = [UIImageView new];
    self.subThreePartImg.backgroundColor = Color_subView;
    [self.view addSubview:self.subThreePartImg];
    
    self.subFourPartImg = [UIImageView new];
    self.subFourPartImg.backgroundColor = Color_subView;
    [self.view addSubview:self.subFourPartImg];
    
    self.subFivePartImg = [UIImageView new];
    self.subFivePartImg.backgroundColor = Color_subView;
    [self.view addSubview:self.subFivePartImg];
    
    self.subSixPartImg = [UIImageView new];
    self.subSixPartImg.backgroundColor = Color_subView;
    [self.view addSubview:self.subSixPartImg];
    
    self.subSevenPartImg = [UIImageView new];
    self.subSevenPartImg.backgroundColor = Color_subView;
    [self.view addSubview:self.subSevenPartImg];
    
    self.subEightPartImg = [UIImageView new];
    self.subEightPartImg.backgroundColor = Color_subView;
    [self.view addSubview:self.subEightPartImg];
    
//    [self.onePartImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left);
//        make.bottom.equalTo(self.view.mas_bottom);
//        make.height.equalTo(self.view.mas_height);
//        make.width.equalTo(@20);
//    }];
//    
//    [self.twoPartImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.view.mas_right);
//        make.bottom.equalTo(self.view.mas_bottom);
//        make.height.equalTo(self.view.mas_height);
//        make.width.equalTo(@20);
//    }];
    self.onePartImg.size = CGSizeMake(20, SCREEN_HEIGHT);
    self.onePartImg.viewTop = 0;
    
    self.twoPartImg.size = self.onePartImg.size;
    self.twoPartImg.viewTop = self.onePartImg.viewTop;
    self.twoPartImg.viewRight = SCREEN_WIDTH;
    
    self.threePartImg.size = CGSizeMake(SCREEN_WIDTH - 40, (SCREEN_HEIGHT  - SCREEN_WIDTH + 40)/2);
    self.threePartImg.viewLeft = self.onePartImg.viewRight;
    self.threePartImg.viewTop = self.onePartImg.viewTop;
    

    self.fourPartImg.viewBottom = self.threePartImg.viewBottom + SCREEN_WIDTH - 40;
    self.fourPartImg.viewLeft = self.threePartImg.viewLeft;
    self.fourPartImg.size = self.threePartImg.size;
    
//    self.albumLabel = [UILabel new];
//    self.albumLabel.text = @"前往相册 >";
//    self.albumLabel.userInteractionEnabled = YES;
//    self.albumLabel.textAlignment = NSTextAlignmentRight;
//    self.albumLabel.textColor = [UIColor whiteColor];
//    self.albumLabel.font = [UIFont boldSystemFontOfSize:16];
//    [self.view addSubview:self.albumLabel];
//    
//    UITapGestureRecognizer *albumTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(albumTap)];
//    [self.albumLabel addGestureRecognizer:albumTap];
    
//    self.albumLabel.size = CGSizeMake(100, 30);
//    self.albumLabel.viewBottom = self.view.viewBottom - 20;
//    self.albumLabel.viewRight = SCREEN_WIDTH - 20;
    
    //角1
    [self.subOnePartImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.onePartImg.mas_right);
        make.top.equalTo(self.threePartImg.mas_bottom);
        make.width.equalTo(@7);
        make.height.equalTo(@20);
    }];
    
    [self.subTwoPartImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subOnePartImg.mas_right);
        make.top.equalTo(self.subOnePartImg.mas_top);
        make.width.equalTo(@13);
        make.height.equalTo(@7);
        
    }];
    //角2
    [self.subThreePartImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.twoPartImg.mas_left);
        make.top.equalTo(self.threePartImg.mas_bottom);
        make.size.equalTo(self.subOnePartImg);
        
    }];
    
    [self.subFourPartImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.subThreePartImg.mas_left);
        make.top.equalTo(self.subOnePartImg.mas_top);
        make.size.equalTo(self.subTwoPartImg);
        
    }];
    //角3
    [self.subFivePartImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.onePartImg.mas_right);
        make.bottom.equalTo(self.fourPartImg.mas_top);
        make.size.equalTo(self.subOnePartImg);
    }];
    
    [self.subSixPartImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subFivePartImg.mas_right);
        make.bottom.equalTo(self.subFivePartImg.mas_bottom);
        make.size.equalTo(self.subTwoPartImg);
        
    }];
    
    //角4
    [self.subSevenPartImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.twoPartImg.mas_left);
        make.bottom.equalTo(self.fourPartImg.mas_top);
        make.size.equalTo(self.subOnePartImg);
    }];
    
    [self.subEightPartImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.subSevenPartImg.mas_left);
        make.bottom.equalTo(self.subSevenPartImg.mas_bottom);
        make.size.equalTo(self.subTwoPartImg);
    }];
    
    
    UILabel *warnLabel = [[UILabel alloc] init];
    warnLabel.backgroundColor = [UIColor clearColor];
    warnLabel.text = @"添加商户或付款";
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.textColor = [UIColor whiteColor];
    warnLabel.adjustsFontSizeToFitWidth = YES;
    warnLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.view addSubview:warnLabel];
    [warnLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@150);
        make.height.equalTo(@40);
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(self.subSevenPartImg.mas_bottom);
    }];
    
    
    //**************返回按钮*************
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.tag = kTag_Button_Back;
    [backBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"ip_sys_re_n"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@20);
        make.top.equalTo(@30);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    
    //**************相册选择按钮按钮*************
    UIButton *middleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    middleBtn.tag = kTag_Button_PicSelect;
    [middleBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [middleBtn setTitle:@"相册" forState:UIControlStateNormal];
    [middleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    middleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [middleBtn setBackgroundImage:[UIImage imageNamed:@"ip_sys_re_n"] forState:UIControlStateNormal];
    [self.view addSubview:middleBtn];
    [middleBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(@30);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    //*************闪关灯开关按钮*************
    UIButton *lightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lightBtn.tag = kTag_Button_Light;
    [lightBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [lightBtn setBackgroundImage:[UIImage imageNamed:@"ip_sys_fl_n"] forState:UIControlStateNormal];
    [lightBtn setBackgroundImage:[UIImage imageNamed:@"ip_sys_fl_s"] forState:UIControlStateSelected];
    [self.view addSubview:lightBtn];
    [lightBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@-20);
        make.top.equalTo(@30);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    

}

/**
 *  扫描条 移动动画
 *
 *  @return
 */
- (CAAnimation*)lightViewPathAnimation;
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path,NULL,self.view.frame.size.width/2,self.threePartImg.viewBottom);
    CGPathAddLineToPoint(path, NULL, self.view.frame.size.width/2,  self.fourPartImg.frame.origin.y);
    CGPathAddLineToPoint(path, NULL, self.view.frame.size.width/2, self.threePartImg.viewBottom);
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    [animation setPath:path];
    [animation setDuration:2];
    [animation setRepeatCount:HUGE_VALF];
    [animation setAutoreverses:NO];
    
    CFRelease(path);
    
    [animation setKeyTimes:
     [NSArray arrayWithObjects:
      [NSNumber numberWithFloat:0],
      [NSNumber numberWithFloat:0.5],
      [NSNumber numberWithFloat:1], nil]];
    
    return animation;
    
}

#pragma mark 按钮点击

/**
 *  按钮点击
 *
 *  @param btn
 */
-(void)buttonClickHandle:(UIButton *)btn
{
    if (btn.tag==kTag_Button_Back)
    {
        //[self.navigationController popToRootViewControllerAnimated:YES];
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
            APPDataCenter.scanNav = nil;
        }];
    }
    else if(btn.tag==kTag_Button_Light)
    {
        btn.selected = !btn.selected;
        if (btn.selected)
        {
            _readerView.torchMode = 1;
        }
        else
        {
            _readerView.torchMode = 0;
        }
    }
    else if(btn.tag == kTag_Button_PicSelect)
    {
        
        ZBarReaderController *imagePickerController = [[ZBarReaderController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.readerDelegate = self;
        imagePickerController.showsHelpOnFail = NO;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    self.scanStr = symbol.data;
    NSLog(@"ssss:%@",symbol.data);
    
    // EXAMPLE: do something useful with the barcode data
    //    resultText.text = symbol.data;
    // EXAMPLE: do something useful with the barcode image
    //    resultImage.image =
    //    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissViewControllerAnimated:YES completion:nil];
    
    [self handleResult];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark ZBarReaderDelegate

- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
                             withRetry: (BOOL) retry
{
    [SVProgressHUD showErrorWithStatus:@"二维码图片识别失败"];
    [reader dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 扫描结果
-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
     NSString *symbolStr = [NSString stringWithUTF8String:zbar_symbol_get_data(symbol)];
    
    [_readerView stop];//停止扫描
    
    self.scanStr = symbolStr;
    
    [self handleResult];
    
}

/**
 *  处理扫描结果
 */
- (void)handleResult
{
    NSRegularExpression *urlRegexExp = [[NSRegularExpression alloc] initWithPattern:@"^http(s){0,1}://([\\w-]+\\.)+[\\w-]+(/[\\w-./?%&=]*)?$" options:0 error:nil];
    
    if (urlRegexExp)
    {
        NSTextCheckingResult *checkingResult = [urlRegexExp firstMatchInString:self.scanStr options:0 range:NSMakeRange(0, [self.scanStr length])];
        if (checkingResult)
        {
            [self scanURL:self.scanStr];
        }
        else {
            
            [self scanText:self.scanStr];
        }
    }
    else {
        //[self scanResultError:symbolStr];
    }
}
#pragma mark - ScanViewDelegate 扫描结果
/**
 *  扫描到的字符串和图片
 *
 *  @param result 扫描结果
 *  @param image
 */
- (void)getScanResult:(NSString *)result scanImage:(UIImage *)image
{
    self.scanStr = [NSString stringWithFormat:@"%@",result];
}

/**
 *  扫描结果为网址
 *
 *  @param url
 */

- (void)scanURL:(NSString *)url

{
    self.scanStr = [NSString stringWithFormat:@"%@",url];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.scanStr]];
    
}
/**
 *  扫描结果为不规则字符串
 *
 *  @param text
 */
- (void)scanText:(NSString *)text
{
    if ([text hasPrefix:@"ZRWALLETMERCHANTHEAD#"])//商户二维码  ZRWALLETMERCHANTHEAD#1510152367 (手机号)
    {
     
        
        //        NSLog(@"扫描解密前： %@",content);
        //        NSString *resStr = [DesEncrypt decryptWithText:content];
        //        NSLog(@"扫描解密后:%@",resStr);
        
        if ([[UserDefaults objectForKey:kIsLogin] isEqualToString:@"0"])
        {
            
            [self dismissViewControllerAnimated:YES completion:^{
                
                [StaticTools showLoginControllerWithSuccess:^{
                    
                } fail:nil];
            }];
            return;
        }

        NSArray *arr = [text componentsSeparatedByString:@"#"];
        if (arr.count>=2)
        {
            NSLog(@"PHONE %@",arr[1]);
            
            NSDictionary *dict = @{@"merchantPhone":arr[1]};
            
            [[HttpRequest sharedRequest] sendRequestWithMessage:nil path:@"merchant/addMember" param:dict succuss:^(id result) {
                
                [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                [self dismissViewControllerAnimated:YES completion:nil];
              
            } fail:^{
                
                [self initScan];
            }];
        }
     
    }
    else   if ([text hasPrefix:@"ZRWALLETMERCHANTRECIVEMONEY#"])//收款二维码  ZRWALLETMERCHANTHEAD#141412412411414 （订单号）
    {
        
        
        //        NSLog(@"扫描解密前： %@",content);
        //        NSString *resStr = [DesEncrypt decryptWithText:content];
        //        NSLog(@"扫描解密后:%@",resStr);
        if ([[UserDefaults objectForKey:kIsLogin] isEqualToString:@"0"])
        {
            
            [self dismissViewControllerAnimated:YES completion:^{
                
                [StaticTools showLoginControllerWithSuccess:^{
                    
                } fail:nil];
            }];
            return;
        }

        
        NSArray *arr = [text componentsSeparatedByString:@"#"];
        if (arr.count>=2)
        {
            NSLog(@"订单号 %@",arr[1]);
            
            PaymentViewController *paymentController = [[PaymentViewController alloc]init];
            paymentController.orderId = arr[1];
            [self.navigationController pushViewController:paymentController animated:YES];
            
        }
        
    }
    
    else
    {
        self.scanStr = [NSString stringWithFormat:@"%@",text];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫描内容" message:text delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"复制内容", nil];
        alert.tag = kTag_Alert_Word;
        alert.delegate = self;
        [alert show];
    }
    
    
}
//
///**
// *  发生错误
// *
// *  @param result <#result description#>
// */
- (void)scanResultError:(NSString *)result
{
    NSLog(@"scanResultError:%@",result);
    [SVProgressHUD showErrorWithStatus:@"二维码信息解密错误"];
}
#pragma mark - Alert 扫描结果处理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"___result:%@",self.scanStr);
    if (kTag_Alert_Net == alertView.tag)
    {
        if (0 == buttonIndex)
        {
            [self initScan];
        }
        else
        {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.scanStr]];
            //                [self initScan];
        }
    }
    else if (alertView.tag == kTag_Alert_Word)
    {
        if (0 == buttonIndex)
        {
        }
        else
        {//复制内容
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:self.scanStr];
        }
        [self initScan];
    }
}

//#pragma makr -http请求
//- (void)sendMessToSeviceWithPhone:(NSString*)phone proId:(NSString*)proId
//{
//    NSDictionary *dict = @{@"upparenttele":phone,  //二维码上的手机号
//                           @"usertele":[UserDefaults objectForKey:KUSERNAME], //扫描者的手机号
//                           @"proid":proId, //产品id
//                           @"type":@"1"};
//    
//    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:dict requestAction:@"productscan" success:^(id obj) {
//        
//        NSDictionary *dict = (NSDictionary*)obj;
//        if ([dict[@"status"] intValue]==0)
//        {
//            [SVProgressHUD showSuccessWithStatus:@"产品已加入到您的产品列表"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"ADDPRODUCTSUCESS" object:nil];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//        else
//        {
//            [SVProgressHUD showErrorWithStatus:dict[@"mess"]];
//            [self initScan];
//        }
//        
//    } failure:^(NSString *errMsg) {
//        
//        [SVProgressHUD showErrorWithStatus:@"服务器异常，请稍后再试"];
//        [self initScan];
//    }];
//    
//    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
//                                          prompt:@"加载中..."
//                                   completeBlock:nil];
//}
//
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end