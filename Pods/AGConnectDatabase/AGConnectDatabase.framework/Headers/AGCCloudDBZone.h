/**
 * Copyright (c) Huawei Technologies Co., Ltd. 2020-2020. All rights reserved.
 * Description: AGCCloudDBZone include executeUpsert, executeDelete, executeQuery,
 *          runTransaction, subscribe operation with a zone instance.
 *
 * Author: luominwei [luominwei@huawei.com]
 * Create: 2020-03-16
 */

#import <Foundation/Foundation.h>

#import "AGCCloudDBQuery.h"

NS_ASSUME_NONNULL_BEGIN

@class AGCCloudDBListenerHandler;
@class AGCCloudDBObject;
@class AGCCloudDBSnapshot;
@class AGCCloudDBTransaction;
@class AGCCloudDBZoneConfig;

/**
 A block on complete callback has two parameters: count and error, count indicates the number of results.
 
 @param count The number of results.
 @param error Error message, use it when need.
 */
typedef void (^AGCCloudDBZoneCompleteCallback) (NSInteger count, NSError *_Nullable error);

/**
 A block on average query callback.
 
 @param average Queryed average value.
 @param error Error message, use it when need.
 */
typedef void (^AGCCloudDBZoneAverageCallback) (double average, NSError *_Nullable error);

/**
 A block on number query callback.
 
 @param number Queryed number value.
 @param error Error message, use it when need.
 */
typedef void (^AGCCloudDBZoneNumberCallback) (NSNumber *_Nullable number, NSError *_Nullable error);

/**
 A block on snapshot callback has two parameters: snapshot, error, use it when need.
 
 @param snapshot Queryed snapshot object.
 @param error Error message, use this when need.
 */
typedef void (^AGCCloudDBSnapshotCallback) (AGCCloudDBSnapshot *_Nullable snapshot, NSError *_Nullable error);

/**
 A block on transaction callback has only one parameter: transaction, use it when need.
 
 @param transaction Transaction will run in the backgroud.
 
 @return YES if success, else NO.
 */
typedef BOOL (^AGCCloudDBTransactionCallback) (AGCCloudDBTransaction *_Nullable transaction);

@interface AGCCloudDBZone : NSObject

#pragma mark - upsert

/**
 Developers use this API to insert/update a list of AGCCloudDBObject objects.
 
 @param objects A list of AGCCloudDBObject objects need to be insert/update into the database.
 @param callback Callback return the result of insert/update.
 */
- (void)executeUpsert:(nonnull NSArray<AGCCloudDBObject *> *)objects
          onCompleted:(nullable AGCCloudDBZoneCompleteCallback)callback;

/**
 Developers use this API to insert/update specific AGCCloudDBObject object.
 
 @param object An AGCCloudDBObject that need to be insert/update into the database.
 @param callback Callback return the result of insert/update.
 */
- (void)executeUpsertOne:(nonnull AGCCloudDBObject *)object
             onCompleted:(nullable AGCCloudDBZoneCompleteCallback)callback;

#pragma mark - delete

/**
 Developers use this API to delete a list of AGCCloudDBObject objects.
 
 @param objectArray A list of AGCCloudDBObject need to be delete from database.
 @param callback Callback return the result of delete.
 */
- (void)executeDelete:(nonnull NSArray<AGCCloudDBObject *> *)objectArray
          onCompleted:(nullable AGCCloudDBZoneCompleteCallback)callback;

/**
 Developers use this API to delete specific specific AGCCloudDBObject object.
 
 @param object An AGCCloudDBObject object need to delete from database.
 @param callback Callback return the result of delete.
 */
- (void)executeDeleteOne:(AGCCloudDBObject *_Nonnull)object
             onCompleted:(nullable AGCCloudDBZoneCompleteCallback)callback;

#pragma mark - query

/**
 Developers use this API to select a table by an AGCCloudDBQuery.
 
 @param query User construct an AGCCloudDBQuery using api, such as where, equalTo, etc.
 @param queryPolicy AGCCloudDBQueryPolicy.
 @param callback Callback return the result of query.
 */
- (void)executeQuery:(nonnull AGCCloudDBQuery *)query
              policy:(AGCCloudDBQueryPolicy)queryPolicy
         onCompleted:(nullable AGCCloudDBSnapshotCallback)callback;

#pragma mark - aggregate

/**
 Developers use this API to get an average result from AGCCloudDBZone by an AGCCloudDBQuery.
 
 @param query User construct an AGCCloudDBQuery using api, such as where, equalTo, etc.
 @param queryPolicy user choose an AGCCloudDBQueryPolicy to query.
 @param fieldName user choose one field to query.
 @param callback Callback return the result of query.
 */
- (void)executeQueryAverage:(nonnull AGCCloudDBQuery *)query
                     policy:(AGCCloudDBQueryPolicy)queryPolicy
                      field:(nonnull NSString *)fieldName
                onCompleted:(nullable AGCCloudDBZoneAverageCallback)callback;

/**
 Developers use this API to get a sum result from AGCCloudDBZone by an AGCCloudDBQuery.
 
 @param query User construct an AGCCloudDBQuery using api, such as where, equalTo, etc.
 @param queryPolicy user choose an AGCCloudDBQueryPolicy to query.
 @param fieldName user choose one field to query.
 @param callback Callback return the result of query.
 */
- (void)executeQuerySum:(nonnull AGCCloudDBQuery *)query
                 policy:(AGCCloudDBQueryPolicy)queryPolicy
                  field:(nonnull NSString *)fieldName
            onCompleted:(nullable AGCCloudDBZoneNumberCallback)callback;

/**
 Developers use this API to get a maximum result from AGCCloudDBZone by an AGCCloudDBQuery.
 
 @param query User construct an AGCCloudDBQuery using api, such as where, equalTo, etc.
 @param queryPolicy user choose an AGCCloudDBQueryPolicy to query.
 @param fieldName user choose one field to query.
 @param callback Callback return the result of query.
 */
- (void)executeQueryMaximum:(nonnull AGCCloudDBQuery *)query
                     policy:(AGCCloudDBQueryPolicy)queryPolicy
                      field:(nonnull NSString *)fieldName
                onCompleted:(nullable AGCCloudDBZoneNumberCallback)callback;

/**
 Developers use this API to get a minimum result from AGCCloudDBZone by an AGCCloudDBQuery.
 
 @param query User construct an AGCCloudDBQuery using api, such as where, equalTo, etc.
 @param queryPolicy user choose an AGCCloudDBQueryPolicy to query.
 @param fieldName user choose one field to query.
 @param callback Callback return the result of query.
 */
- (void)executeQueryMinimum:(nonnull AGCCloudDBQuery *)query
                     policy:(AGCCloudDBQueryPolicy)queryPolicy
                      field:(nonnull NSString *)fieldName
                onCompleted:(nullable AGCCloudDBZoneNumberCallback)callback;

/**
 Developers use this API to get a count result from AGCCloudDBZone by an AGCCloudDBQuery.
 
 @param query User construct an AGCCloudDBQuery using api, such as where, equalTo, etc.
 @param queryPolicy user choose an AGCCloudDBQueryPolicy to query.
 @param fieldName user choose one field to query.
 @param callback Callback return the result of query.
 */
- (void)executeQueryCount:(nonnull AGCCloudDBQuery *)query
                   policy:(AGCCloudDBQueryPolicy)queryPolicy
                    field:(nonnull NSString *)fieldName
              onCompleted:(nullable AGCCloudDBZoneCompleteCallback)callback;

#pragma mark - query unsynced

/**
 Developers use this API to select a table by an AGCCloudDBQuery unsynced.
 
 @param query User construct an AGCCloudDBQuery using api, such as where, equalTo, etc.
 @param callback Callback return the result of query.
 */
- (void)executeQueryUnsynced:(nonnull AGCCloudDBQuery *)query
                 onCompleted:(nullable AGCCloudDBSnapshotCallback)callback;

#pragma mark - transaction

/**
 Developers use this API to execute a transaction in cloud side.
 
 @param transaction The AGCCloudDBTransactionCallback developers want to execute in cloud side.
 @param callback Callback return the result of transaction.
 */
- (void)runTransaction:(nullable AGCCloudDBTransactionCallback)transaction
           onCompleted:(nullable void (^)(NSError *_Nullable error))callback;

#pragma mark - subscribe

/**
 Register listener on the query. callable will be called while query finished and changed.
 
 @param query user construct an AGCCloudDBQuery using api, such as where, equalTo, etc.
 @param queryPolicy user choose an AGCCloudDBQueryPolicy to query.
 @param listener Listener on the query.
 
 @return an object of AGCCloudDBSnapshotCallback which helps to remove the listener from the query.
 */
- (nullable AGCCloudDBListenerHandler *)subscribeSnapshotWithQuery:(nonnull AGCCloudDBQuery *)query
                                                            policy:(AGCCloudDBQueryPolicy)queryPolicy
                                                          listener:(nonnull AGCCloudDBSnapshotCallback)listener;

@end

NS_ASSUME_NONNULL_END
