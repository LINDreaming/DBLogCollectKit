//
//  DBNetworkHelper.h
//  DBFlowTTS
//
//  Created by linxi on 2019/11/14.
//  Copyright © 2019 biaobei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DBEnmerator.h"

#define DevelopSever_log 0
#define ProductSever_log 1

/// 测试环境
#if DevelopSever_log

#define DB_UploadUrlString  @"https://openapitest.data-baker.com/logapp/log/uploadLog"
// 正式环节
#elif ProductSever_log

#define DB_UploadUrlString  @"https://openapitest.data-baker.com/logapp/log/uploadLog"
#endif


NS_ASSUME_NONNULL_BEGIN

typedef void (^DBCompletioBlock)(NSDictionary *dic, NSURLResponse *response, NSError *error);
typedef void (^DBSuccessBlock)(NSDictionary *data);
typedef void (^DBFailureBlock)(NSError *error);

@interface DBFNetworkHelper : NSObject
/**
 *  get请求
 */
+ (void)getWithUrlString:(NSString *)url parameters:(id)parameters success:(DBSuccessBlock)successBlock failure:(DBFailureBlock)failureBlock;

/**
 * post请求
 */
+ (void)postWithUrlString:(NSString *)url parameters:(id)parameters success:(DBSuccessBlock)successBlock failure:(DBFailureBlock)failureBlock;

/// 上传日志统计的信息
+ (void)uploadLevel:(DBLogLevel)level userMsg:(NSString *)msg;
@end

NS_ASSUME_NONNULL_END
