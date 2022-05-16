//
//  DBLogCollectKit.h
//  DBLogCollectKit
//
//  Created by biaobei on 2022/4/27.
//

#import <Foundation/Foundation.h>
#import "DBLogerConfigure.h"
#import "DBEnmerator.h"
//#define join_string1(str1 ,str2) [NSString stringWithFormat:@"%@%@",str1, str2]

#define DBCollectLog(level,fmt,...) [[DBLogCollectKit sharedInstance] logWithLevel:level format:@"%s:%d " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]

@interface DBLogCollectKit : NSObject

@property(nonatomic,strong)DBLogerConfigure *configure;
DECLARE_SINGLETON(DBLogCollectKit)
// 设置默认的配置
- (void)configureDefault;

// 需要配置日志的基本信息
- (void)configureServiceInfo:(DBLogerConfigure *)model;

/// 打印日志信息
- (void)logWithLevel:(DBLogLevel)level format:(NSString *)format, ... NS_FORMAT_FUNCTION(2, 3);

@end
