//
//  ViewController.m
//  DBLogerCollectorDemo
//
//  Created by biaobei on 2022/4/27.
//

#import "ViewController.h"
#import "DBLogCollectKit.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self uploadLogInfo];
}

- (void)uploadLogInfo {
    DBLogCollectKit *collectKit = [DBLogCollectKit sharedInstance];
    [collectKit configureDefaultWithCrashLogLevel:DBLogLevelError];
    DBLogerConfigure *configure = [collectKit getCurrentConfigure];
    NSString *userId = @"123";
    [configure setConfigureWithUserId:userId appName:@"AuduioSDK" appVersion:@"1.1.0" businessType:@"bbyy-sdk-ios" shaKey:KSha256];
    DBCollectLog(DBLogLevelError, @"this is a test Message: 123--%@",@(456));

    
//    NSArray *array = @[];
//    array[1];
}


@end
