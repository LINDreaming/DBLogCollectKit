//
//  ViewController.m
//  DBLogerCollectorDemo
//
//  Created by biaobei on 2022/4/27.
//

#import "ViewController.h"
#import "DBNetworkHelper.h"
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
    [collectKit configureDefault];
//    [collectKit logMessageWithLevel:DBLogLevelDebug message:@"this is a test case"];
    
    DBCollectLog(DBLogLevelDebug, @"123--%@",@(456));
    

}


@end
