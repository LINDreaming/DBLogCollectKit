//
//  DBLogCollectKit.h
//  DBLogCollectKit
//
//  Created by biaobei on 2022/4/27.
//

#import <Foundation/Foundation.h>
#import "DBLogerConfigure.h"
#import "DBEnmerator.h"

#define DBCollectLog(level,fmt,...) [[DBLogCollectKit sharedInstance] logWithLevel:level format:@"%s:%d " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]

#define DBCollectLog(level,fmt,...) [[DBLogCollectKit sharedInstance] logWithLevel:level format:@"%s:%d " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]

#define LogerVerbose(fmt,...) [[DBLogCollectKit sharedInstance] logVerbose:@"%s:%d " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]

#define LogerDebug(fmt,...) [[DBLogCollectKit sharedInstance] logDebug:@"%s:%d " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]

#define LogerInfo(fmt,...) [[DBLogCollectKit sharedInstance] logInfo:@"%s:%d " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]

#define LogerWarning(fmt,...) [[DBLogCollectKit sharedInstance] logWarning:@"%s:%d " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]

#define LogerError(fmt,...) [[DBLogCollectKit sharedInstance] logError:@"%s:%d " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]


#define KDBLogCollectKit [DBLogCollectKit sharedInstance]

@interface DBLogCollectKit : NSObject

DECLARE_SINGLETON(DBLogCollectKit)
- (void)setEnableLog:(BOOL)enable;
/// get current log configure
- (DBLogerConfigure *)getCurrentConfigure;


// 设置默认的配置
- (void)configureDefaultWithCrashLogLevel:(DBLogLevel)level;

/// 打印日志信息
- (void)logWithLevel:(DBLogLevel)level format:(NSString *)format, ... NS_FORMAT_FUNCTION(2, 3);

- (void)logVerbose:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

- (void)logDebug:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

- (void)logInfo:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

- (void)logWarning:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

- (void)logError:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

/// 打印日志信息
- (void)logWithLevel:(DBLogLevel)level msg:(NSString *)msg;

@end
