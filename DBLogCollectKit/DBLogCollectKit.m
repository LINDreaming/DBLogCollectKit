//
//  DBLogCollectKit.m
//  DBLogCollectKit
//
//  Created by biaobei on 2022/4/27.
//

#import "DBLogCollectKit.h"
#import "DBLogerConfigure.h"
#import "DBNetworkHelper.h"
#import "DBPermanentThread.h"
#import "DBUncaughtExceptionHandler.h"

@interface DBLogCollectKit ()
@property(nonatomic,strong)DBPermanentThread * thread;

@end

@implementation DBLogCollectKit

DEFINE_SINGLETON(DBLogCollectKit)

+ (void)saveCriticalSDKRunData:(NSString *)string {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"DBRunLog.txt"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath contents:[@">>>>>>>程序运行日志<<<<<<<<\n" dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }
    NSFileHandle *handle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    [handle seekToEndOfFile];
    NSString *dateStr = [DBLogCollectKit currentDateString];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![[userDefaults valueForKey:@"RunLogTime"] isEqualToString:dateStr]) {
        [userDefaults setValue:dateStr forKey:@"RunLogTime"];
        [userDefaults synchronize];
        dateStr = [NSString stringWithFormat:@">>>>>>>>>>>>>>> 日期 %@ >>>>>>>>>>>>>>>",dateStr];
        [handle writeData:[dateStr dataUsingEncoding:NSUTF8StringEncoding]];
        [handle seekToEndOfFile];
    }
    string = [NSString stringWithFormat:@"\n%@: %@\n",[DBLogCollectKit currentTimeString],string];
    [handle writeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    [handle closeFile];
}

///MARK: --  当前的时间信息
+ (NSString *)currentTimeString {
    //时间格式化
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}

+ (NSString *)currentDateString {
    //时间格式化
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}


// setting the default format

- (void)configureDefault {
    if (!self.thread) {
        self.thread = [[DBPermanentThread alloc]init];
        DBInstallUncaughtExceptionHandler();
        [self configureServiceInfo:nil];
    }
    NSString *exceptionPath = [[DBUncaughtExceptionHandler shareInstance] exceptionFilePath];
    NSError *error;
    BOOL ret = [[NSFileManager defaultManager] fileExistsAtPath:exceptionPath];
    if (!ret) {
        return;
    }
    NSString *string = [NSString stringWithContentsOfFile:exceptionPath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        DBCollectLog(DBLogLevelDebug,@"%@",error.description);
    }else {
        if (string) {
            DBCollectLog(DBLogLevelDebug,@"%@",string); // upload the local file
            [[NSFileManager defaultManager] removeItemAtPath:exceptionPath error:&error]; // remove the local file
        }
    }
}

- (void)configureServiceInfo:(DBLogerConfigure *)model {
    DBLogerConfigure *configure;
    if (model) {
        configure = model;
    }else {
        configure = [DBLogerConfigure sharedInstance];
    }
    [configure setDefaultConfigure];
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
        [DBNetworkHelper uploadLevel:level userMsg:msg];
    }];
}

@end
