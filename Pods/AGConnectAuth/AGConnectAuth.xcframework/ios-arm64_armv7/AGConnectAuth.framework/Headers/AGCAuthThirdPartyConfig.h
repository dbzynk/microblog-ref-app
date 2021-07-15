//
//  Copyright (c) Huawei Technologies Co., Ltd. 2020. All rights reserved
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGCAuthThirdPartyConfig : NSObject

@property(nonatomic,strong,nullable)NSString *googleClientId;

@property(nonatomic,strong,nullable)NSString *facebookAppId;

+(instancetype)instance;

@end

NS_ASSUME_NONNULL_END
