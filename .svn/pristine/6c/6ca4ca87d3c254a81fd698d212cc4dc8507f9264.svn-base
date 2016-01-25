//
//  Constants.h
//
/*----------------------------------------------------------------
 // Copyright (C) 中融钱包
 //
 // 文件功能描述：全局的宏定义
 
 // 注意事项：
 //
 ----------------------------------------------------------------*/

#import "AppDelegate.h"

#define OUT_LOG	//正式版本删除

#ifdef OUT_LOG
#define NSLog(format, ...) NSLog(format, ##__VA_ARGS__)
#else
#define NSLog(format, ...)
#endif
#pragma mark 设备环境

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define UserDefaults [NSUserDefaults standardUserDefaults]
#define APPDataCenter [AppDataCenter sharedAppDataCenter]

//#define HOST                                @"http://218.240.150.138:9991"
#define HOST                                @"http://220.194.59.154:10808"
//#define HOST                                @"http://192.168.2.120:8080"


//---------------------------------手机相关-------------------------------------------
#define SCREEN_HEIGHT [UIScreen mainScreen ].bounds.size.height //屏幕高度
#define SCREEN_WIDTH  [UIScreen mainScreen ].bounds.size.width //屏幕宽度

//颜色设置
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//rgb颜色转换（16进制->10进制）
#define HEXRGBCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define kCellHeight (([UIScreen mainScreen ].bounds.size.height==480)?45.0:(([UIScreen mainScreen ].bounds.size.height==568)?45.0:([UIScreen mainScreen ].bounds.size.height==667?55.0:65.0)))

#define kOnePageSize    10

// NSUserDefault
#define PASSWORD							 @"password"
#define PHONENUM							 @"phoneNum"
#define kREMEBERPWD                          @"remberpwd"  //1:记住密码  0：不记住
//导航栏Size
#define Dev_NavigationBar_Height        64.0
#define Dev_TabBar_Height               49.0


#define kHostAddress                    @"HOSTADDRESS"

#define kTranceCode                     @"TANCECODE" //交易码
#define kParamName                      @"KPARAMNAGE" //交易发送的数据节点

//消息通知
#define kRestartAnimation   @"RestartAnimation" //重新启动扫描动画
#define kBecomeActivie @"becomeactive" //程序进入前台时 发出通知消息


//登录相关
#define kUSERID                         @"userId"         //用户id
#define KUSERNAME                       @"userName"       //用户名
#define kPASSWORD                       @"password"       //用户密码
#define kLoginToken                     @"logintoken"
#define kIsLogin                        @"islogin" //是否登录 @"1" 已登录   @"0" 未登录
#define kLockPwd                            [NSString stringWithFormat:@"%@lock",[UserDefaults objectForKey:PHONENUM]] //手势密码
#define kMerchantInfo                       [NSString stringWithFormat:@"%@meichantinfo",[UserDefaults objectForKey:PHONENUM]]

// Baidu PUSH
#define kBPUSH_APPID                    @"BPUSH_appid"
#define kBPUSH_USERID                   @"BPUSH_userid"
#define kBPUSH_CHANNELID                @"BPUSH_channelid"
#define kBPUSH_REQUESTID                @"BPUSH_requestid"

//个人中心
#define USER_NICKNAME                   @"accountName"     //用户名
#define USER_PHOTO                      @"userPhoto"       //用户头像
#define USER_BANKCARD                   @"bankCard"        //用户银行卡

//首页
#define HOME_CAROUSELS                  @"HOME_CAROUSELS"   //轮播图数组



