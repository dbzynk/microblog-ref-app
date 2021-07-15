//
//  Copyright (c) Huawei Technologies Co., Ltd. 2020. All rights reserved
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 云函数服务错误码枚举
 */
typedef NS_ENUM(NSInteger, AGCFunctionErrorCode) {
    /**
     * 未知错误
     */
    AGCFunctionErrorCodeUnknown = -1
};

/**
 * 云函数服务错误码
 */
@interface AGCFunctionError : NSError

@end

NS_ASSUME_NONNULL_END
