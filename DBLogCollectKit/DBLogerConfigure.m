//
//  DBLogerModel.m
//  DBCrashLogKit
//
//  Created by biaobei on 2022/4/27.
//

#import "DBLogerConfigure.h"

@implementation DBLogerConfigure

DEFINE_SINGLETON(DBLogerConfigure);

- (void)setDefaultConfigure {
    self.businessType = @"bbyc_ios";
    self.language = @"zh";
    self.systemVersion = @"iOS 14.1";
    self.appVersion = @"1.3.0";
    self.userId = @"1111";
    self.appSystemVersion = self.systemVersion;
    self.appName = @"标贝易采";
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

@end
