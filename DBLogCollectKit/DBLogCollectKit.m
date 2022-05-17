//
//  DBLogCollectKit.m
//  DBLogCollectKit
//
//  Created by biaobei on 2022/4/27.
//

#import "DBLogCollectKit.h"
#import "DBLogerConfigure.h"
#import "DBFNetworkHelper.h"
#import "DBPermanentThread.h"
#import "DBFUncaughtExceptionHandler.h"

@interface DBLogCollectKit ()
@property(nonatomic,strong)DBPermanentThread * thread;
@property(nonatomic,strong)DBLogerConfigure *configure;

@end

@implementation DBLogCollectKit

DEFINE_SINGLETON(DBLogCollectKit)

// setting the default format

- (void)configureDefaultWithCrashLogLevel:(DBLogLevel)level  {
    if (!self.thread) {
        self.thread = [[DBPermanentThread alloc]init];
        self.configure = [DBLogerConfigure sharedInstance];
        [self.configure setDefaultConfigure]; // initlize use the default configure
        [self configureCrashLogLevel:level];
    }
}

- (void)configureCrashLogLevel:(DBLogLevel)level {
    DBInstallUncaughtExceptionHandler();
    NSString *exceptionPath = [[DBFUncaughtExceptionHandler shareInstance] exceptionFilePath];
    NSError *error;
    BOOL ret = [[NSFileManager defaultManager] fileExistsAtPath:exceptionPath];
    if (!ret) {
        return;
    }
    NSString *string = [NSString stringWithContentsOfFile:exceptionPath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        DBCollectLog(DBLogLevelWarning,@"%@",error.description);
    }else {
        if (string) {
            DBCollectLog(DBLogLevelError,@"%@",string); // upload the local file
            [[NSFileManager defaultManager] removeItemAtPath:exceptionPath error:&error]; // remove the local file
        }
    }
}
- (DBLogerConfigure *)getCurrentConfigure {
    return self.configure;
}

- (void)setConfigureServiceInfo:(DBLogerConfigure *)model {
    if (!model) {return;}
    DBLogerConfigure *configure = model;
    self.configure = configure;
}

- (void)logWithLevel:(DBLogLevel)level format:(NSString *)format, ... {
    // 1. 首先创建多参数列表
    va_list args;
    // 2. 开始初始化参数, start会从format中 依次提取参数, 类似于类结构体中的偏移量 offset 的 方式
    va_start(args, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:args];
    // 3. end 必须添加
    va_end(args);
    [self.thread executeTask:^{
        NSLog(@"log level:%@ message :%@",@(level),msg);
        [DBFNetworkHelper uploadLevel:level userMsg:msg];
    }];
}

@end
