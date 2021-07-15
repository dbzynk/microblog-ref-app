/**
 * Copyright (c) Huawei Technologies Co., Ltd. 2020-2020. All rights reserved.
 * Description: AGCCloudDBObjectTypeInfo describe the information of ObjectType.
 *
 * Author: luominwei [luominwei@huawei.com]
 * Create: 2020-03-26
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGCCloudDBObjectTypeInfo : NSObject

/// ObjectType list.
@property (nonnull, nonatomic, readonly, strong) NSArray<Class> *objectTypes;

/// The version of ObjectType.
@property (nonatomic, readonly, assign) long objectTypeVersion;

/// The version of the ObjectType format.
@property (nonatomic, readonly, assign) int formatVersion;

/**
 Initialization.
 
 @param objectTypes A List of object type.
 @param objectTypeVersion Ther version of ObjectType.
 @param formatVersion The version of ObjectType format.
 
 @return An AGCCloudDBObjectTypeInfo object.
 */
- (nonnull instancetype)initWithObjectTypes:(nonnull NSArray<Class> *)objectTypes
                          objectTypeVersion:(long)objectTypeVersion
                              formatVersion:(int)formatVersion;

@end

NS_ASSUME_NONNULL_END
