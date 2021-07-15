/**
 * Copyright (c) Huawei Technologies Co., Ltd. 2020-2020. All rights reserved.
 * Description: AGCCloudDBZoneConfig is AGCCloudDBZone's configuration. Developer can config basic info this object provided,
 *          include sync mode, access mode, zone name, persistence, capacity, encrypted, encrypted key.
 *
 * Author: luominwei [luominwei@huawei.com]
 * Create: 2020-03-16
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 This enum is cloud database zone synchronize property.
 
 - AGCCloudDBZoneSyncModeLocalOnly: Data is only stored on the end side, no synchronization;
 - AGCCloudDBZoneSyncModeCloudCache: Data is stored on the cloud side;
 */
typedef NS_ENUM (NSInteger, AGCCloudDBZoneSyncMode) {
    AGCCloudDBZoneSyncModeLocalOnly  = 0,
    AGCCloudDBZoneSyncModeCloudCache = 1
};

/**
 This enum is cloud database zone access property.
 
 - AGCCloudDBZoneAccessModePublic: Public database;
 */
typedef NS_ENUM (NSInteger, AGCCloudDBZoneAccessMode) {
    AGCCloudDBZoneAccessModePublic = 0
};

@interface AGCCloudDBZoneConfig : NSObject

/// The name of associated zone.
@property (nonnull, nonatomic, readonly, copy) NSString *zoneName;

/// Synchronize property of associated zone.
@property (nonatomic, readonly, assign) AGCCloudDBZoneSyncMode syncMode;

/// Access property of associated zone.
@property (nonatomic, readonly, assign) AGCCloudDBZoneAccessMode accessMode;

/// The property of whether associated zone is persistent locally. True if the zone is persistent locally, else false.
@property (nonatomic, readwrite, assign) BOOL persistence;

/// The capacity of local cache.
@property (nonatomic, readwrite, assign) long capacity;

/// The property of whether the zone is encrypted.
@property (nonatomic, readonly, assign) BOOL encrypted;

/**
 Initialized a new config of AGCCloudDBZone with syncMode and accessMode and zoneName.
 
 @param zoneName zone name.
 @param syncMode synchronize mode.
 @param accessMode access mode.
 
 @return An AGCCloudDBZoneConfig.
 */
- (nonnull instancetype)initWithZoneName:(nonnull NSString *)zoneName
                                syncMode:(AGCCloudDBZoneSyncMode)syncMode
                              accessMode:(AGCCloudDBZoneAccessMode)accessMode;

/**
 Set the encrypted key of associated zone.
 
 @param key The key of AGCCloudDBZone database.
 @param rekey The rekey of CloudDBZone database, as new key.
 */
- (void)setEncryptKey:(nullable NSString *)key rekey:(nullable NSString *)rekey;

@end

NS_ASSUME_NONNULL_END
