/**
 * Copyright (c) Huawei Technologies Co., Ltd. 2020-2020. All rights reserved.
 * Description: AGCCloudDBObject is a class, extended by all classes, to describe an object.
 *
 * Author: luominwei [luominwei@huawei.com]
 * Create: 2020-03-17
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - AGCCloudDBNumber

/**
 Basic data type: bool.
 */
@protocol AGCBool

@end

/**
 Basic data type: Byte.
 */
@protocol AGCByte

@end

/**
 Basic data type: Short.
 */
@protocol AGCShort

@end

/**
 Basic data type: Int.
 */
@protocol AGCInt

@end

/**
 Basic data type: Long.
 */
@protocol AGCLong

@end

/**
 Basic data type: Float.
 */
@protocol AGCFloat

@end

/**
 Basic data type: Double.
 */
@protocol AGCDouble

@end

@interface NSNumber () <AGCBool, AGCByte, AGCShort, AGCInt, AGCLong, AGCFloat, AGCDouble>

@end

#pragma mark -

@interface AGCCloudDBObject : NSObject

/**
 Get a list of properties representing the primary key.
 
 @return A list of property names.
 */
+ (nonnull NSArray<NSString *> *)primaryKeyProperties;

/**
 Get a list of properties that can not be null.
 
 @return A list of property names.
 */
+ (nonnull NSArray<NSString *> *)notNullProperties;

/**
 Get a dictionary contain index relationship.
 
 @return A dictionary contain index relationship.
 */
+ (nonnull NSDictionary<NSString *, NSArray *> *)indexProperties;

/**
 Get a dictionary contain all properties have a default value.
 
 @return A dictionary contain properties' default.
 */
+ (nonnull NSDictionary *)defaultValueProperties;

/**
 Get a list of properties that be encrypted.
 
 @return A list of encrypted names.
 */
+ (nonnull NSArray<NSString *> *)encryptedProperties;

@end

#pragma mark -

@interface AGCCloudDBText : NSObject

/// The text content in the object.
@property (nonnull, nonatomic, readwrite, copy) NSString *text;

/**
 Initialization.
 
 @param text Text string.
 
 @return An AGCCloudDBText object.
 */
+ (nonnull instancetype)createText:(nonnull NSString *)text;

/**
 Returns a Boolean value that indicates whether a given text object is equal to the receiver.
 
 @param aText The text with which to compare the receiver.
 
 @return YES if aText is equivalent to the receiver, otherwise NO.
 */
- (BOOL)isEqualToText:(nonnull AGCCloudDBText *)aText;

@end

NS_ASSUME_NONNULL_END
