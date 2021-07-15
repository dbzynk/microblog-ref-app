/**
 * Copyright (c) Huawei Technologies Co., Ltd. 2020-2020. All rights reserved.
 * Description: AGCCloudDBSnapshot is a class to indicate a snapshot that reflects an objectList filtered by a query in memory.
 *
 * Author: luominwei [luominwei@huawei.com]
 * Create: 2020-03-17
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AGCCloudDBObject;

@interface AGCCloudDBSnapshot : NSObject

/**
 Get a list of AGCCloudDBObject objects filtered by query from user.
 
 @return A list of AGCCloudDBObject.
 */
- (nonnull NSArray<AGCCloudDBObject *> *)snapshotObjects;

/**
 When a snapshot is refreshed, put the objects which are updated or new from into the SnapshotObjects upsertedObjects.
 
 @return A list of AGCCloudDBObject.
 */
- (nonnull NSArray<AGCCloudDBObject *> *)upsertedObjects;

/**
 When a snapshot is refreshed, put the objects which have been removed from SnapshotObjects into the upsertedObjects.
 
 @return A list of AGCCloudDBObject.
 */
- (nonnull NSArray<AGCCloudDBObject *> *)deletedObjects;

/**
 Indicate that the snapshot has some objects synced to cloud or not.
 
 @return YES if has objects not synced to cloud, else NO.
 */
- (BOOL)hasPendingWrites;

/**
 Indicate that the query referred to the snapshot is from cloud or local.
 
 @return YES if query is from cloud, esle NO if from local.
 */
- (BOOL)isFromCloud;

@end

NS_ASSUME_NONNULL_END
