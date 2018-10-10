//
//  AnyRTCBoardEngine.h
//  ARWriteBoard
//
//  Created by zjq on 2018/9/28.
//  Copyright © 2018年 zjq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnyRTCBoardEngine : NSObject
/**
 配置开发者信息
 
 @param strDeveloperId 开发者Id；
 @param strAppId     AppId；
 @param strAppKey    AppKey；
 @param strAppToken  AppToken；
 说明：该方法为配置开发者信息，上述参数均可在https://www.anyrtc.io/ manage创建应用后,管理中心获得；建议在AppDelegate.m调用。
 */
+ (void)initEngineWithAnyRTCInfo:(NSString*)strDeveloperId andAppId:(NSString*)strAppId andKey:(NSString*)strAppKey andToke:(NSString*)strAppToken;

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
