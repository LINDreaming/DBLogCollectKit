//
//  DBLogerModel.h
//  DBCrashLogKit
//
//  Created by biaobei on 2022/4/27.
//

//声明单例
#undef    DECLARE_SINGLETON
#define DECLARE_SINGLETON( __class ) \
- (__class *)sharedInstance; \
+ (__class *)sharedInstance;

//定义单例
#undef    DEFINE_SINGLETON
#define DEFINE_SINGLETON( __class ) \
- (__class *)sharedInstance \
{ \
return [__class sharedInstance]; \
} \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[[self class] alloc] init]; } ); \
return __singleton__; \
}

#define KDBLogerConfigure [DBLogerConfigure sharedInstance]



#import <Foundation/Foundation.h>



NS_ASSUME_NONNULL_BEGIN

@interface DBLogerConfigure : NSObject

/// 用户Id
@property(nonatomic,copy,readonly)NSString *  userId;
// 业务类型
@property(nonatomic,copy,readonly)NSString * businessType;
// shaKey
@property(nonatomic,copy,readonly)NSString * shaKey;

// YES： 打开日志， NO： 关闭日志
@property(nonatomic,assign)BOOL enableLog;

DECLARE_SINGLETON(DBLogerConfigure);


- (NSString *)time;

- (NSDictionary *)getBaseInfoDictionary;

/// 本地默认生成的UserId
- (NSString *)getCollectKitUserId;

- (void)setConfigureWithUserId:(NSString *)userId
                       appName:(NSString *)appName
                    appVersion:(NSString *)appVersion
                  businessType:(NSString *)businessType
                        shaKey:(NSString *)shaKey;



@end

NS_ASSUME_NONNULL_END

