//
//  AnyRTCCommon.h
//  AnyRTCBoard
//
//  Created by jh on 2018/10/11.
//  Copyright © 2018年 anyRTC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnyRTCCommon : NSObject

+ (NSString *)getUUID;

//错误信息
+ (NSString *)getErrorCode:(AnyRTCBoardCode)code;

//随机字符串
+ (NSString*)randomString:(int)len;

@end

NS_ASSUME_NONNULL_END
