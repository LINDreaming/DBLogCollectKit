//
//  DBLogerModel.m
//  DBCrashLogKit
//
//  Created by biaobei on 2022/4/27.
//

#import "DBLogerConfigure.h"
#import <sys/utsname.h>//要导入头文件
#import <UIKit/UIKit.h>

static NSString *KUserIdKey = @"KUserIdKey";
static inline BOOL IsEmpty(id thing) {
    return (thing == nil) || [thing isEqual:[NSNull null]] ||
    ([thing isKindOfClass:[NSString class]] && [[(NSString *)thing stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) ||
    ([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0) ||
    ([thing respondsToSelector:@selector(count)] && [(NSArray *)thing count] == 0);
}


@interface DBLogerConfigure ()
/// 系统版本号 -必填
@property(nonatomic,copy)NSString * systemVersion;
/// app版本号 -必填
@property(nonatomic,copy)NSString * appVersion;
/// app的名称 - 必填
@property(nonatomic,copy)NSString * appName;
/// 系统语言 -必填
@property(nonatomic,copy)NSString * language;
/// app版本号 - 必填
@property(nonatomic,copy)NSString * appSystemVersion;
/// 用户Id - 必填
@property(nonatomic,copy)NSString *  userId;
// 业务类型 - 必填
@property(nonatomic,copy)NSString * businessType;
// 服务端加密使用- 必填
@property(nonatomic,copy)NSString * shaKey;

@end

@implementation DBLogerConfigure

DEFINE_SINGLETON(DBLogerConfigure);

- (void)setDefaultConfigure {
    self.userId = [self getCollectKitUserId];
    self.appName = @"Baker";
    self.businessType = @"bbyc_ios";
    self.language = @"zh";
    self.systemVersion = [self getCurrentDeviceModel];
    self.shaKey = @"";
    self.appSystemVersion = [self currentSystemVersion];
    self.enableLog = YES;
}

- (void)setConfigureWithUserId:(NSString *)userId
                       appName:(NSString *)appName
                    appVersion:(NSString *)appVersion
                  businessType:(NSString *)businessType
                        shaKey:(NSString *)shaKey
{
    
    [self checkParams:@[
     @{@"userId":userId,
       @"appName":appName,
       @"appVersion":appVersion,
       @"businessType":businessType,
       @"shaKey":shaKey
     }
    ]];
    [self setDefaultConfigure];
    self.userId = userId;
    self.appName = appName;
    self.appVersion = appVersion;
    self.businessType = businessType;
    self.shaKey = shaKey;
}


- (void)checkParams:(NSArray *)params {
    for (NSDictionary *dict in params) {
        NSString *key = dict.allKeys.firstObject;
        NSString *value = dict[key];
        NSString *info = [NSString stringWithFormat:@"%@ can't be nil",key];
        NSAssert(value != nil, info);
    }
}

- (NSString *)getCollectKitUserId {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *uuidString = [userDefault objectForKey:KUserIdKey];
    if(IsEmpty(uuidString)) {
        uuidString = [NSUUID UUID].UUIDString;
        [[NSUserDefaults standardUserDefaults]setObject:uuidString forKey:KUserIdKey];
    }
    return uuidString;
}

- (NSString *)currentSystemVersion {
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    return systemVersion;
}

- (NSString *)time {
    return [self getUnixTime];
}

- (NSString *)getUnixTime{
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970]*1000;
    long long int currentTime = (long long int)time;
    NSString *unixTime = [NSString stringWithFormat:@"%llu", currentTime];
    return unixTime;
}

- (NSDictionary *)getBaseInfoDictionary {
    DBLogerConfigure *loger = [DBLogerConfigure sharedInstance];
    NSDictionary *params = @{
        @"systemVersion":loger.systemVersion,
        @"appVersion":loger.appVersion,
        @"appName":loger.appName,
        @"language":loger.language,
        @"appSystemVersion":loger.appSystemVersion
    };
    return params;
}

// iPhone 手机的系列型号 https://www.theiphonewiki.com/wiki/List_of_iPhones#iPhone_14
- (NSString *)getCurrentDeviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceModel isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceModel isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPhone12,1"])   return @"iPhone 11";
    if ([deviceModel isEqualToString:@"iPhone12,3"])   return @"iPhone 11 Pro";
    if ([deviceModel isEqualToString:@"iPhone12,5"])   return @"iPhone 11 Pro Max";
    if ([deviceModel isEqualToString:@"iPhone12,8"])   return @"iPhone SE2";
    if ([deviceModel isEqualToString:@"iPhone13,1"])   return @"iPhone 12 mini";
    if ([deviceModel isEqualToString:@"iPhone13,2"])   return @"iPhone 12";
    if ([deviceModel isEqualToString:@"iPhone13,3"])   return @"iPhone 12 Pro";
    if ([deviceModel isEqualToString:@"iPhone13,4"])   return @"iPhone 12 Pro Max";
    if ([deviceModel isEqualToString:@"iPhone14,4"])   return @"iPhone 13 mini";
    if ([deviceModel isEqualToString:@"iPhone14,5"])   return @"iPhone 13";
    if ([deviceModel isEqualToString:@"iPhone14,2"])   return @"iPhone 13 Pro";
    if ([deviceModel isEqualToString:@"iPhone14,3"])   return @"iPhone 13 Pro Max";
    if ([deviceModel isEqualToString:@"iPhone14,6"])   return @"iPhone SE3";
    if ([deviceModel isEqualToString:@"iPhone14,7"])   return @"iPhone 14";
    if ([deviceModel isEqualToString:@"iPhone14,8"])   return @"iPhone 14 Plus";
    if ([deviceModel isEqualToString:@"iPhone15,2"])   return @"iPhone 14 Pro";
    if ([deviceModel isEqualToString:@"iPhone15,3"])   return @"iPhone 14 Pro Max";
    
    
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
    if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";
    
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    return deviceModel;
}

@end
