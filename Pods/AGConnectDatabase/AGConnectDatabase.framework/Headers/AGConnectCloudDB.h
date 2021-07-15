/**
 * Copyright (c) Huawei Technologies Co., Ltd. 2020-2020. All rights reserved.
 * Description: AGConnectCloudDB is a management class of entire database.
 *
 * Author: luominwei [luominwei@huawei.com]
 * Create: 2020-04-24
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AGCCloudDBZone;
@class AGCCloudDBZoneConfig;
@class AGCCloudDBObjectTypeInfo;

/**
 This enum is defined the event type from natural store.
 So if you want to add a new enumeration,
 make sure that the value of these enumerations are the same as the enum.
 
 - AGCCloudDBEventTypeUserKeyChanged: Event user key changed;
 */
typedef NS_ENUM (NSInteger, AGCCloudDBEventType) {
    AGCCloudDBEventTypeUserKeyChanged = 1
};

/**
 Monitor dataEncryptionKey changed on remote terminal.
 
 @return Yes to update data encryption key when it changed.
 */
typedef BOOL (^AGCCloudDBOnDataEncryptionKeyChangeCallback) (void);

/**
 Receive encrypt events.
 
 @param eventType event type.
 */
typedef void (^AGCCloudDBEventCallback) (AGCCloudDBEventType eventType);

@interface AGConnectCloudDB : NSObject

#pragma mark - initialize

/**
 Init AGConnectCloudDB if it has not been initialized.
 If init default failed, you should to check whether executing illegal operation,
 such as downgrade the system version.
 
 @param error Execution results, if fails, error message will be in it.
 */
+ (void)initEnvironment:(NSError *_Nullable *_Nullable)error;

/**
 The singleton AGConnectCloudDB is returned if it has been initialized.
 Before invoke this method, must invoke 'initEnvironment:'
 
 @return the singleton AGConnectCloudDB.
 */
+ (nonnull instancetype)shareInstance;

/**
 Load ObjectType info into system.
 
 @param objTypeInfo ObjectType information, you can include serveral object type in it.
 @param error Execution results, if fails, error message will be in it.
 */
- (void)createObjectType:(nonnull AGCCloudDBObjectTypeInfo *)objTypeInfo error:(NSError *_Nullable *_Nullable)error;

#pragma mark - zone

/**
 Synchronized Method. Open an AGCCloudDBZone - create it if non existing, return its info if already exists.
 
 @param config context of the relevant information.
 @param allowCreate If set to true - create the DB no matter if it exists before;
 If set to false - do not create the DB if it does not exist on the machine.
 @param error Execution results, if fails, error message will be in it.
 
 @return The AGCCloudDBZone.
 */
- (nullable AGCCloudDBZone *)openCloudDBZone:(nonnull AGCCloudDBZoneConfig *)config
                                 allowCreate:(BOOL)allowCreate
                                       error:(NSError *_Nullable *_Nullable)error;

/**
 Asynchronous Method. Open an AGCCloudDBZone - create it if non existing, callback its info if already exists.
 
 @param config context of the relevant information.
 @param allowCreate If set to true - create the DB no matter if it exists before;
 If set to false - do not create the DB if it does not exist on the machine.
 
 @param callback The AGCCloudDBZone and error information.
 */
- (void)openCloudDBZone2:(nonnull AGCCloudDBZoneConfig *)config
             allowCreate:(BOOL)allowCreate
                callback:(nullable void (^)(AGCCloudDBZone *_Nullable zone, NSError *_Nullable error))callback;

/**
 Close a specific zone of AGCCloudDBZone.
 
 @param zone The zone to be closed.
 @param error Execution results, if fails, error message will be in it.
 */
- (void)closeCloudDBZone:(nonnull AGCCloudDBZone *)zone error:(NSError *_Nullable *_Nullable)error;

/**
 Delete a specific zone of AGCCloudDBZone.
 
 @param zoneName The name of zone to be deleted.
 @param error Execution results, if fails, error message will be in it.
 */
- (void)deleteCloudDBZone:(nonnull NSString *)zoneName error:(NSError *_Nullable *_Nullable)error;

#pragma mark - config

/**
 Get zone configs information.
 
 @return the List<AGCCloudDBZoneConfig> of zone informations.
 */
- (nonnull NSArray<AGCCloudDBZoneConfig *> *)zoneConfigs;

/**
 Enable network for zone with zone name,
 it will trigger sync module to get unsynced objects and sync to cloud server.
 
 @param zoneName The zone's name need to enable network.
 
 @return YES if succeed, else NO.
 */
- (BOOL)enableNetwork:(nonnull NSString *)zoneName;

/**
 Disable network for zone with zone name.
 
 @param zoneName The zone's name need to disable network.
 
 @return YES if succeed, else NO.
 */
- (BOOL)disableNetwork:(nonnull NSString *)zoneName;

#pragma mark - encryption

/**
 Set user key for entire encryption, it has two cases.
 1. If the user set userKey for the first time, will to be creating userkey. Otherwise, will to be verify userKey.
 2. If the user set userKey and userRekey, will to be modifying userKey.
 
 @param userKey user key.
 @param userRekey new user key.
 @param callback callback result for setUserKey.
 */
- (void)setUserKey:(nonnull NSString *)userKey
         userRekey:(nullable NSString *)userRekey
          callback:(nullable void (^)(NSError *_Nullable error))callback;

/**
 Update user dataEncryptionKey. In terms of security, user dataEncryptionKey should be supported to renewable.
 Before invoking it, user key must be verified first.
 
 @param updateCallback callback result for updateDataEncryptionKey.
 */
- (void)updateDataEncryptionKey:(nullable void (^)(NSError *_Nullable error))updateCallback;

/**
 Add dataEncryptionKey changed callback.
 
 @param callback dataEncryptionKey callback implement by caller.
 */
- (void)addDataEncryptionKeyCallback:(nonnull AGCCloudDBOnDataEncryptionKeyChangeCallback)callback;

/**
 Add event changed callback.
 
 @param eventCallback event callback implement by caller.
 */
- (void)addEventCallback:(nonnull AGCCloudDBEventCallback)eventCallback;

@end

NS_ASSUME_NONNULL_END
