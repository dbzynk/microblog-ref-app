//
//  Copyright (c) Huawei Technologies Co., Ltd. 2020. All rights reserved
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AGCFunctionCallable;

/**
 * 云函数服务入口类
 */
@interface AGCFunction : NSObject

/**
 * 获取AGCFunction实例
 * @return AGCFunction实例
 */
+ (instancetype)getInstance;

/**
 * 设置Cloud Function 函数
 *
 * @param httpTriggerUri 云函数的HttpTriggerURI，例如：hello-$lastest
 * @return AGCFunctionCallable实例
 */
- (AGCFunctionCallable *)wrap:(NSString *)httpTriggerUri;

@end

NS_ASSUME_NONNULL_END
