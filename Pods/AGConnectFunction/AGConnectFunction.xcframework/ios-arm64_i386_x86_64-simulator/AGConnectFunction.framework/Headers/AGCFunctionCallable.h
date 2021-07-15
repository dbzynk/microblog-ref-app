//
//  Copyright (c) Huawei Technologies Co., Ltd. 2020. All rights reserved
//

#import <Foundation/Foundation.h>
#import <HMFoundation/HMFoundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 云函数执行结果
 */
@interface AGCFunctionResult : NSObject

/**
 * 获取Cloud Function执行后的返回对象
 *
 * @return 返回对象
 */
- (nullable NSString *)value;

/**
 * 获取Cloud Function执行后,返回指定类的对象
 *
 * @param valueClass 返回对象的类，支持NSNumber、NSString、NSArray、NSDictionary和自定义类型
 * @return 返回对象
 */
- (nullable id)valueWithClass:(Class)valueClass;

@end

/**
 * Cloud Function 函数
 */
@interface AGCFunctionCallable : NSObject

/**
 * 函数的超时时间，默认70秒
 */
@property(nonatomic) NSTimeInterval timeoutInterval;

/**
 * 适用于调用无参类型的函数
 *
 * @return 执行结果
 */
- (HMFTask<AGCFunctionResult *> *)call;

/**
 * 适用于调用有参类型的函数
 *
 * @param object 参数，参数类型支持NSNumber、NSString、NSArray、NSDictionary和自定义类型
 * @return 执行结果
 */
- (HMFTask<AGCFunctionResult *> *)callWithObject:(nullable id)object;

@end

NS_ASSUME_NONNULL_END
