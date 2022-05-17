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
    configure.userId = @"1234";
    [collectKit setConfigureServiceInfo:configure];
    DBCollectLog(DBLogLevelInfo, @"123--%@",@(456));
    
//    NSArray *array = @[];
//    array[1];
}


@end
