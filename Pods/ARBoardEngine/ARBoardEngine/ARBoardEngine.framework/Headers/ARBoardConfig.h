//
//  ARBoardConfig.h
//  ARBoardEngine
//
//  Created by zjq on 2018/4/18.
//  Copyright © 2018 zjq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARBoardConfig : NSObject
/**
 配置开发者信息
 
 @param appId     appId；
 @param token  token；
 说明：该方法为配置开发者信息,在管理中心获得或联系商务获取；建议在AppDelegate.m调用。
 */
+ (void)initEngine:(NSString*)appId token:(NSString*)token;

/**
 配置私有云

 @param address 私有云地址
 @param port 私有云端口
 */
+ (void)configServerForPriCloud:(NSString *)address port:(int)port;

/**
 开启/关闭控制台打印（默认打印）
 
 @param isEnable YES:打印；NO:不打印
 */
+ (void)enableConsoleLog:(BOOL)isEnable;

/**
 获取 白板 SDK 版本号
 
 @return 版本号
 */
+ (NSString*)getSdkVersion;

@end

NS_ASSUME_NONNULL_END
