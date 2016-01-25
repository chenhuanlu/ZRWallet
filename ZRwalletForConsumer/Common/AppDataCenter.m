//
//  AppDataCenter.m
//  
//
//
//
//

#import "AppDataCenter.h"

@interface AppDataCenter ()

@end
@implementation AppDataCenter


static AppDataCenter *instance = nil;

/*
 synchronized   这个主要是考虑多线程的程序，这个指令可以将{ } 内的代码限制在一个线程执行，如果某个线程没有执行完，其他的线程如果需要执行就得等着。
 */
+ (AppDataCenter *) sharedAppDataCenter
{
    @synchronized(self)
    {
        if (nil == instance) {
            instance = [[AppDataCenter alloc] init];
        }
    }
    
    return instance;
}

- (id)init
{
    if (self = [super init]) {
  

    }
    
    return self;
}

/*
 是从制定的内存区域读取信息创建实例，所以如果需要的单例已经有了，就需要禁止修改当前单例。所以返回 nil
 */
+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self){
        if (instance == nil) {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    
    return nil;
}


@end
