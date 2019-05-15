//
//  ArCommon.m
//  AnyRTCBoard
//
//  Created by 余生丶 on 2019/5/15.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import "ArCommon.h"
#import "SSKeychain.h"

#define kService [NSBundle mainBundle].bundleIdentifier

@implementation ArCommon

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
+ (NSString *)getErrorCode:(ARBoardCode)code{
    switch (code) {
        case ARBoardCodeParameterError:
            return @"初始化错误";
            
        case ARBoardCodeNoNet:
            return @"网络已断开，请检查网络";
            
        case ARBoardCodeUserIdIsNull:
            return @"用户ID为空";
            
        case ARBoardCodeSessionPastDue:
            return @"session过期";
            
        case ARBoardCodeDeveloperInfoError:
            return @"开发者信息错误";
            
        case ARBoardCodeDeveloperArrearage:
            return @"欠费";
            
        case ARBoardCodeDeveloperNotOpen:
            return @"用户未开通该功能";
            
        case ARBoardCodeDatabaseError:
            return @"数据库异常";
            
        default:
            break;
    }
    return nil;
}

@end
