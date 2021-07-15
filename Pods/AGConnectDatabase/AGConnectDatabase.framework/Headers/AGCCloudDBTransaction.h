/**
 * Copyright (c) Huawei Technologies Co., Ltd. 2020-2020. All rights reserved.
 * Description: AGCCloudDBTransaction is a class that describe a transaction supplied to user, there are executeQuery,
 *          executeUpsert, executeDelete operation in transaction; all operation called in a transaction object in a transaction.
 *
 * Author: pengweijun [pengweijun2@huawei.com]
 * Create: 2020-03-17
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AGCCloudDBObject;
@class AGCCloudDBQuery;
@class AGCCloudDBZone;

@interface AGCCloudDBTransaction : NSObject

#pragma mark - execute

/**
 Developers use this the API to select a table by a naturalStoreQuery in a transaction.
 
 @param query User construct a naturalStoreQuery using api, such as where, equalTo, etc.
 @param error Callback return the result of query.
 
 @return A list of AGCCloudDBObject objects.
 */
- (nonnull NSArray<AGCCloudDBObject *> *)executeQuery:(nonnull AGCCloudDBQuery *)query
                                                error:(NSError *_Nullable *_Nullable)error;

/**
 Developers use this API to insert/update specific records in a table in transaction.
 
 @param objects A list of objects need to be insert/update to the database.
 
 @return An AGCCloudDBTransaction object.
 */
- (nullable AGCCloudDBTransaction *)executeUpsert:(nonnull NSArray<AGCCloudDBObject *> *)objects;

/**
 Developers use this the API to delete specific records in a table in a transaction.
 
 @param objects A list of objects need to delete from the database.
 
 @return An AGCCloudDBTransaction object.
 */
- (nullable AGCCloudDBTransaction *)executeDelete:(nonnull NSArray<AGCCloudDBObject *> *)objects;

@end

NS_ASSUME_NONNULL_END
