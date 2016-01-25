//
//  AppDelegate.m
//  ZRwalletForMerchant
//
//  Created by 文彬 on 15/6/29.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "WalletViewController.h"
#import "MineViewController.h"
#import "MoreViewController.h"
#import "MyTabBarController.h"
#import "BPush.h"
#import "ScanViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"

@interface AppDelegate ()
{
     UIBackgroundTaskIdentifier backgroundTask;
}
@property (strong, nonatomic) NSTimer *timer;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self goHome];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // iOS8 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else
    {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }

    //TODO 上线 AppStore 时需要修改 pushMode 需要修改Apikey为自己的Apikey
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    [BPush registerChannel:launchOptions apiKey:@"pC90NCTFsL8HWKSzFGAVRHio" pushMode:BPushModeDevelopment withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:YES];
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo)
    {
        NSLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }
    
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    [self.window makeKeyAndVisible];
    
    //微信分享
//    [ShareSDK registerApp:@"93579942fd24"];
    [ShareSDK registerApp:@"99d972243dd5"];//ShareSDK的AppKey
    [self shareSDKWithInfo];
    
    return YES;
}
-(void)shareSDKWithInfo{
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:@"wxa3065daa8f24fe79"
                           wechatCls:[WXApi class]];
    //微信登陆的时候需要初始化
    [ShareSDK connectWeChatWithAppId:@"wxa3065daa8f24fe79"
                           appSecret:@"ff26a484ea1a5730d80bf4a4737776e5"
                           wechatCls:[WXApi class]];
    //导入微信需要的外部库类型，如果不需要微信分享可以不调用此方法
    [ShareSDK importWeChatClass:[WXApi class]];
    
}
//检查是否已加入handleOpenURL 的处理方法
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    if ([[UserDefaults objectForKey:kIsLogin] isEqualToString:@"1"])
    {
        UIApplication* app = [UIApplication sharedApplication];
        
        backgroundTask= [app beginBackgroundTaskWithExpirationHandler:^{
            NSLog(@"applicationD in Background");
        }];
        
        
        //加入定时器，用来控制后台运行时间
        self.timer= [NSTimer scheduledTimerWithTimeInterval:60*5
                                                     target:self
                                                   selector:@selector(showLockView)
                                                   userInfo:nil
                                                    repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBecomeActivie object:nil];
    
    [self.timer invalidate];
    self.timer= nil;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark 功能函数
- (void)showLockView
{
    [StaticTools showLockViewWithType:LLLockViewTypeCheck];
    
    [self.timer invalidate];
    self.timer= nil;
    if(backgroundTask!= UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
        backgroundTask= UIBackgroundTaskInvalid;
        
    }
}
//#pragma mark-推送
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
//{
//   
//    completionHandler(UIBackgroundFetchResultNewData);
//
//}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"get push token:%@",deviceToken);
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        
        NSLog(@"result:%@",result);
        
        NSString *channel_id = result[@"channel_id"];
        NSDictionary *dic =  @{@"channelId":channel_id,@"channelType":@(4)};
        
        [[HttpRequest sharedRequest]sendRequestWithMessage:@"" path:@"uploadChannel" param:dic succuss:^(id result) {
            
        } fail:^{
        }];

    }];
    
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // App 收到推送的通知
    [BPush handleNotification:userInfo];
    
    NSLog(@"get push info %@",userInfo);
    
    
}
#pragma mark-推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    //ios7后使用该方法处理
    //收到推送的通知 在方法中，判别一下Appication的状态，如果是active的话就弹出自己的Alert即可
    //用户点击了推送消息后动作按钮
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive)
    {
        
    }
    //应用已经运行于前台
    else if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
            
        } title:@"消息" message:userInfo[@"aps"][@"alert"] cancelButtonName:@"取消" otherButtonTitles:@"确定",nil];
        
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"接收本地通知啦！！！");
    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
}


#pragma mark
/**
 *  转到首页
 */
- (void)goHome
{
    HomeViewController *homeController = [[HomeViewController alloc]init];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:homeController];
    
    WalletViewController *walletController = [[WalletViewController alloc]init];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:walletController];
    
    MineViewController *mineController = [[MineViewController alloc]init];
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:mineController];
    
    MoreViewController *moreController = [[MoreViewController alloc]init];
    UINavigationController *nav4 = [[UINavigationController alloc]initWithRootViewController:moreController];
    
    NSMutableDictionary *imgDic1 = [NSMutableDictionary dictionaryWithCapacity:3];
    NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
    NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
    NSMutableDictionary *imgDic4 = [NSMutableDictionary dictionaryWithCapacity:3];

    if(SCREEN_HEIGHT>568)
    {
        [imgDic1 setObject:[UIImage imageNamed:@"icon_home_n_big"] forKey:@"Default"];
        [imgDic1 setObject:[UIImage imageNamed:@"icon_home_s_big"] forKey:@"Highlighted"];
        [imgDic1 setObject:[UIImage imageNamed:@"icon_home_s_big"] forKey:@"Seleted"];
        
        [imgDic2 setObject:[UIImage imageNamed:@"icon_wallet_n_big"] forKey:@"Default"];
        [imgDic2 setObject:[UIImage imageNamed:@"icon_wallet_s_big"] forKey:@"Highlighted"];
        [imgDic2 setObject:[UIImage imageNamed:@"icon_wallet_s_big"] forKey:@"Seleted"];

        [imgDic3 setObject:[UIImage imageNamed:@"icon_mine_n_big"] forKey:@"Default"];
        [imgDic3 setObject:[UIImage imageNamed:@"icon_mine_s_big"] forKey:@"Highlighted"];
        [imgDic3 setObject:[UIImage imageNamed:@"icon_mine_s_big"] forKey:@"Seleted"];

        [imgDic4 setObject:[UIImage imageNamed:@"icon_more_n_big"] forKey:@"Default"];
        [imgDic4 setObject:[UIImage imageNamed:@"icon_more_s_big"] forKey:@"Highlighted"];
        [imgDic4 setObject:[UIImage imageNamed:@"icon_more_s_big"] forKey:@"Seleted"];
    }
    else
    {   [imgDic1 setObject:[UIImage imageNamed:@"icon_home_n"] forKey:@"Default"];
        [imgDic1 setObject:[UIImage imageNamed:@"icon_home_s"] forKey:@"Highlighted"];
        [imgDic1 setObject:[UIImage imageNamed:@"icon_home_s"] forKey:@"Seleted"];

        [imgDic2 setObject:[UIImage imageNamed:@"icon_wallet_n"] forKey:@"Default"];
        [imgDic2 setObject:[UIImage imageNamed:@"icon_wallet_s"] forKey:@"Highlighted"];
        [imgDic2 setObject:[UIImage imageNamed:@"icon_wallet_s"] forKey:@"Seleted"];

        [imgDic3 setObject:[UIImage imageNamed:@"icon_mine_n"] forKey:@"Default"];
        [imgDic3 setObject:[UIImage imageNamed:@"icon_mine_s"] forKey:@"Highlighted"];
        [imgDic3 setObject:[UIImage imageNamed:@"icon_mine_s"] forKey:@"Seleted"];

        [imgDic4 setObject:[UIImage imageNamed:@"icon_more_n"] forKey:@"Default"];
        [imgDic4 setObject:[UIImage imageNamed:@"icon_more_s"] forKey:@"Highlighted"];
        [imgDic4 setObject:[UIImage imageNamed:@"icon_more_s"] forKey:@"Seleted"];
        
    }
 
    
    NSArray *imgArr = @[imgDic1,imgDic2,imgDic3,imgDic4];
    
    MyTabBarController *tabcon = [[MyTabBarController alloc] init];
    NSArray *controllers = [NSArray arrayWithObjects:nav1, nav2, nav3,nav4,nil];
    tabcon.viewControllers =controllers ;
    [tabcon setImages:imgArr];
    [tabcon setSelectedIndex:0];
    tabcon.middleButtonClick = ^{
        ScanViewController *svc = [[ScanViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:svc];
        APPDataCenter.scanNav = nav;
       
        [self.window.rootViewController presentModalViewController:nav animated:YES];
    };
    
    for (UINavigationController *nav in controllers)
    {
        if ([nav respondsToSelector:@selector(interactivePopGestureRecognizer)])
        {
            //            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            nav.interactivePopGestureRecognizer.enabled = YES;
        }
    }
  
    UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:tabcon];
    rootNav.navigationBarHidden = YES;
    self.window.rootViewController = rootNav;
    
  
}

@end
