//
//  HttpRequest.m
//  ZRwalletForConsumer
//
//  Created by 文彬 on 15/7/15.
//  Copyright (c) 2015年 文彬. All rights reserved.
//

#import "HttpRequest.h"
#import "AFNetworking.h"
#import "NSData+Base64Additions.h"
#import "SecurityTool.h"
#import "MBProgressHUD.h"

static HttpRequest *requst = nil;

@interface HttpRequest ()
{
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) NSOperationQueue *operationqueue;

@end

@implementation HttpRequest

+ (HttpRequest *) sharedRequest
{
    @synchronized(self)
    {
        if (nil == requst) {
            requst = [[HttpRequest alloc] init];
        }
    }
    
    return requst;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self){
        if (requst == nil) {
            requst = [super allocWithZone:zone];
            return requst;
        }
    }
    
    return nil;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _operationqueue = [[NSOperationQueue alloc]init];
    }
    
    return self;
}

/**
 *  发送http请求
 *
 *  @param message  加载框文字 传nil时使用默认值：正在加载  传@"" 时不显示加载框
 *  @param path     请求路径 具体见接口文档
 *  @param param    请求参数
 *  @param sucBlock 成功后回调
 *  @param errBlock 失败时回调
 */
- (void)sendRequestWithMessage:(NSString*)message
                          path:(NSString*)path
                         param:(NSDictionary*)param
                       succuss:(RequestSucBlock)sucBlock
                          fail:(RequestErrBlock)errBlock
{
    if (![StaticTools checkNetAvailable])
        return;
    
    NSString *mess= message;
    if (mess==nil)
    {
        mess = @"正在加载";
        
    }
    if (![mess isEqualToString:@""])
    {
//        [SVProgressHUD showWithStatus:mess maskType:SVProgressHUDMaskTypeClear];
        [self showHUDwihtMess:mess];
    }
  
    NSString *httpBodyString = param==nil?@"":[self DataTOjsonString:param];
//    httpBodyString = [httpBodyString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    httpBodyString = [httpBodyString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    httpBodyString = [httpBodyString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSMutableURLRequest *request ;
   
    
    //!!!登录请求特殊处理
    if ([path isEqualToString:@"getTocken"])
    {
        request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:HOST]];
        NSString *info = [NSString stringWithFormat:@"%@:%@",param[@"phoneNumber"],param[@"password"]];
        request.HTTPMethod = @"GET";
        
        [request addValue:[NSString stringWithFormat:@"Basic %@",[[info dataUsingEncoding:NSUTF8StringEncoding] encodeBase64ForData]] forHTTPHeaderField:@"Authorization"];
    
    }
    else
    {
        //!!! path需做一下url编码  否则生成url为nil
        request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/user/%@",HOST,[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
        request.HTTPMethod = @"POST";
        [request addValue:@"" forHTTPHeaderField:@"Authorization"];
        if ([[UserDefaults objectForKey:kIsLogin] isEqualToString:@"1"])
        {
            [request addValue:[UserDefaults objectForKey:kLoginToken] forHTTPHeaderField:@"x-auth-token"];
        }
        
        if (![StaticTools isEmptyString:httpBodyString])
        {
            request.HTTPBody = [httpBodyString dataUsingEncoding:NSUTF8StringEncoding];
        }
        
    }
     [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
     NSLog(@"requesthead:%@",request.allHTTPHeaderFields);
    NSLog(@"request:%@",httpBodyString);
    NSLog(@"url is --》%@",request.URL);
    
    [request setTimeoutInterval:30];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
  
    
//        [SVProgressHUD dismiss];
        [self hideHUD];
        
        //!!!登录请求特殊处理
        if ([path isEqualToString:@"getTocken"])
        {
            
            NSLog(@"allfields:%@",operation.response.allHeaderFields);
            NSString *token = operation.response.allHeaderFields[@"x-auth-token"];
            if ([StaticTools isEmptyString:token])
            {
                [SVProgressHUD showErrorWithStatus:@"登录失败，用户名或密码错误"];
                if (errBlock)
                {
                    errBlock();
                }
            }
            else //只要返回了token 则认为登录成功
            {
                [UserDefaults setObject:token forKey:kLoginToken];
                [UserDefaults synchronize];
                
                if (sucBlock)
                {
                    sucBlock(@"");
                }
            }
            
            return ;
        }
        
        NSString *respStr = [operation responseString];
        
        NSLog(@"Response: %@", respStr);
        
        NSDictionary *reciveDict  =  [NSJSONSerialization JSONObjectWithData:[respStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        if (reciveDict==nil)
        {
            if (errBlock)
            {
                errBlock(@"服务器返回数据转换失败");
                return ;
            }
        }
        
        if ([reciveDict[@"code"] isEqualToString:@"00"]) //操作成功
        {
            if (sucBlock)
            {
                sucBlock(reciveDict[@"data"]);
            }
        }
        else if([reciveDict[@"code"] isEqualToString:@"A0"]) //TOKEN过期 需做全局处理
        {
            
            //!!! 防止连续发送多个请求时 为AO  跳出多个提示框
            if(alert==nil)
            {
                alert = [[UIAlertView alloc]initWithTitle:nil message:@"用户登录状态发送变化，请重新登录!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }

        }
        else
        {
            [SVProgressHUD showErrorWithStatus:reciveDict[@"msg"]];
            if(errBlock!=nil)
            {
                errBlock();
            }
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
//        [SVProgressHUD dismiss];
         [self hideHUD];
        
        //导航栏返回按钮点击 取消请求
        if ([error.localizedDescription rangeOfString:@"-999"].location!=NSNotFound)
        {
             NSLog(@"eeee:%@",error.localizedDescription);
            return ;
        }
        
       
         NSLog(@"error.userInfo:%@",error.userInfo);

        //!!!登录请求特殊处理 登录返回401时 表示登录失败 用户名或密码错误 或用户名不存在
        if ([path isEqualToString:@"getTocken"])
        {
            if ([[error.userInfo objectForKey:@"NSLocalizedDescription"] rangeOfString:@"401"].location!=NSNotFound)
            {
                [SVProgressHUD showErrorWithStatus:@"登录失败，用户名或密码错误。"];
                return ;
            }
        }
        
       
        
        [SVProgressHUD showErrorWithStatus:[HttpRequest getErrorMsg:[error.userInfo objectForKey:@"NSLocalizedDescription"]]];
        
        if (errBlock!=nil)
        {
            errBlock([HttpRequest getErrorMsg:[error.userInfo objectForKey:@"NSLocalizedDescription"]]);
        }
    }];
    
    [self.operationqueue addOperation:operation];
    
}

/**
 *  取消请求
 */
- (void)cancelLastRequst
{
    [self hideHUD];
    
    //TODO
    if (self.operationqueue.operations.count>0)
    {
        AFHTTPRequestOperation *operation = self.operationqueue.operations.lastObject;
//        if (operation.canCancel)
//        {
            [operation cancel];
//        }
    }
}

/**
 *  字典转json字符串
 *
 *  @param object
 *
 *  @return 
 */
-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}


#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [UserDefaults setObject:@"0" forKey:kIsLogin];
    [UserDefaults synchronize];
    
    if (APPDataCenter.scanNav!=nil)
    {
        [APPDataCenter.scanNav dismissViewControllerAnimated:YES completion:^{
            
            [StaticTools showLoginControllerWithSuccess:nil fail:nil];
        }];
    }
    else
    {
        [StaticTools showLoginControllerWithSuccess:nil fail:nil];
    }
    
    alert = nil;

}
#pragma mark  功能函数
/**
 *  显示加载框
 *
 *  @param mess 加载框文字
 */
- (void)showHUDwihtMess:(NSString*)mess
{
    if (HUD==nil)
    {
        HUD = [[MBProgressHUD alloc]initWithFrame: CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
        [ApplicationDelegate.window addSubview:HUD];
    }
    
    // Set determinate mode
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.delegate = self;
    HUD.labelText = mess;
    [HUD show:YES];
}

/**
 *  隐藏加载框
 */
- (void)hideHUD
{
    if (HUD!=nil)
    {
        [HUD removeFromSuperViewOnHide];
        [HUD hide:YES];
        HUD = nil;
    }
}

/**
 *  更具错误信息 返回错误提示语
 *
 *  @param errMsg
 *
 *  @return
 */
+ (NSString *) getErrorMsg:(NSString *)errMsg
{
    
    if (errMsg)
    {
        if ([errMsg rangeOfString:@"The request timed out"].location != NSNotFound)
        {
            // The request timed outtimed out
            return @"服务器响应超时";
        } else if ([errMsg rangeOfString:@"got 500"].location != NSNotFound)
        {
            //Expected status code in (200-299), got 500
            return [NSString stringWithFormat:@"服务器异常[%@]", errMsg];
        } else if ([errMsg rangeOfString:@"The Internet connection appears to be offline"].location != NSNotFound)
        {
            // The Internet connection appears to be offline
            return @"无法连接服务器，请检查网络设置";
        } else if ([errMsg rangeOfString:@"Could not connect to the server"].location != NSNotFound)
        {
            // Could not connect to the server
            return @"无法连接服务器，请检查网络设置";
        } else if ([errMsg rangeOfString:@"got 404"].location != NSNotFound)
        {
            // Expected status code in (200-299), got 404
            return @"服务器无法响应功能请求(404)";
        }
    }
    
    return @"操作失败，请稍后再试。";
}


@end
