//
//  AnyRTCCommon.m
//  AnyRTCBoard
//
//  Created by jh on 2018/10/11.
//  Copyright © 2018年 anyRTC. All rights reserved.
//

#import "AnyRTCCommon.h"

#import "SSKeychain.h"

#define kService [NSBundle mainBundle].bundleIdentifier

@implementation AnyRTCCommon

//获取uuid（卸载、升级,标识唯一）
+ (NSString *)getUUID{
    
    CFUUIDRef puuid  =  CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result  =  (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));    CFRelease(puuid);
    CFRelease(uuidString);
    //SSKeyChains
    if(![SSKeychain passwordForService:kService account:@"User"]){
        [SSKeychain setPassword:result forService:kService account:@"User"];
        
    }
    NSString *devicenumber = [SSKeychain passwordForService:kService account:@"User"];
    
    return devicenumber.length > 0 ? devicenumber : @"" ;
}

//随机字符串
+ (NSString*)randomString:(int)len {
    char* charSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    char* temp = malloc(len + 1);
    for (int i = 0; i < len; i++) {
        int randomPoz = (int) floor(arc4random() % strlen(charSet));
        temp[i] = charSet[randomPoz];
    }
    temp[len] = '\0';
    NSMutableString* randomString = [[NSMutableString alloc] initWithUTF8String:temp];
    free(temp);
    return randomString;
}

//错误信息
+ (NSString *)getErrorCode:(AnyRTCBoardCode)code{
    switch (code) {
        case AnyRTCBoardCodeParameterError:
            return @"初始化错误";
            
        case AnyRTCBoardCodeNoNet:
            return @"网络已断开，请检查网络";
            
        case AnyRTCBoardCodeUserIdIsNull:
            return @"用户ID为空";
            
        case AnyRTCBoardCodeSessionPastDue:
            return @"session过期";
            
        case AnyRTCBoardCodeDeveloperInfoError:
            return @"开发者信息错误";
            
        case AnyRTCBoardCodeDeveloperArrearage:
            return @"欠费";
            
        case AnyRTCBoardCodeDeveloperNotOpen:
            return @"用户未开通该功能";
            
        case AnyRTCBoardCodeDatabaseError:
            return @"数据库异常";
            
        default:
            break;
    }
    return nil;
}

@end
