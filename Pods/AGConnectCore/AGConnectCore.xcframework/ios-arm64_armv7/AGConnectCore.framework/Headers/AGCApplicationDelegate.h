//
//  Copyright (c) Huawei Technologies Co., Ltd. 2020. All rights reserved
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AGCApplicationDelegateObserver <NSObject>

@optional
- (void)didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions;
- (BOOL)continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler;
- (BOOL)openURL:(NSURL *)url options:(nullable NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;

@end

@interface AGCApplicationDelegate : NSObject

+ (instancetype)sharedInstance;

- (void)addObserver:(id<AGCApplicationDelegateObserver>)observer;
- (void)removeObserver:(id<AGCApplicationDelegateObserver>)observer;

- (void)didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions;
- (BOOL)continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler;
- (BOOL)openURL:(NSURL *)url options:(nullable NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;

@end

NS_ASSUME_NONNULL_END
