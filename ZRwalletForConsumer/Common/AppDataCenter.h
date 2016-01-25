//
//  AppDataCenter.h
//
//
/*----------------------------------------------------------------
 // Copyright (C) 中融钱包
 //
 // 文件功能描述：全局数据存放区
 
 // 注意事项：
 //
 ----------------------------------------------------------------*/

#import <Foundation/Foundation.h>

@interface AppDataCenter : NSObject


+ (AppDataCenter *) sharedAppDataCenter;

@property (weak, nonatomic) UINavigationController *scanNav;
@property (strong, nonatomic) PayPasswordViewController *payPasswordController;
@property (strong, nonatomic) NSString *temPhone ; //注册时手机号 临时存一下

@end
