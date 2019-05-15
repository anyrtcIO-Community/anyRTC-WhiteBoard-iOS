//
//  ARBoardCommon.h
//  ARBoardEngine
//
//  Created by zjq on 2018/4/18.
//  Copyright © 2018 zjq. All rights reserved.
//

#ifndef ARBoardCommon_h
#define ARBoardCommon_h
#import <Foundation/Foundation.h>

//错误码
typedef NS_ENUM(NSInteger,ARBoardCode) {
    
    ARBoardCodeParameterError = 3000,      //初始化错误
    ARBoardCodeNoNet = 3001,               //初始化无网络
    ARBoardCodeUserIdIsNull = 3002,        //用户ID为空
    ARBoardCodeSessionPastDue = 201,       //session过期
    ARBoardCodeDeveloperInfoError = 202,   //开发者信息错误
    ARBoardCodeDeveloperArrearage = 206,   //欠费
    ARBoardCodeDeveloperNotOpen = 207,     //用户未开通该功能
    ARBoardCodeDatabaseError = 301         //数据库异常
};

//白板工具类型
typedef NS_ENUM(NSInteger, ARBoardBrushModel) {
    ARBoardBrushModelNone = 0,         //无效果(触摸无响应)
    ARBoardBrushModelGraffiti,         //涂鸦
    ARBoardBrushModelArrow,            //单箭头
    ARBoardBrushModelLine,             //直线
    ARBoardBrushModelRect,             //矩形
    ARBoardBrushModelTransform,        //缩放(双指)/移动(单指)
    ARBoardBrushModelTransformSync,    //缩放(双指)/移动(单指)-滑动同步
};

@protocol ARBoardViewDelegate <NSObject>
@optional
//初始化成功
- (void)initBoardScuess;
//白板出错
- (void)onBoardError:(ARBoardCode)nCode;
//白板与服务器断开连接
- (void)onBoardServerDisconnect;
//白板页码改变
- (void)onBoardPageChange:(NSString*)imageUrl withCurrentPage:(int)currentPage withTotalPage:(int)totalPage;
//消息回调
- (void)onBoardMessage:(NSString*)message;
//白板数据改变的时间（秒级）
- (void)onBoardDrawsChangeTimestamp:(uint32_t)timestamp;
//画板被销毁（收到该回调，退出白板）
- (void)onBoardDestory;

@end

#endif /* ARBoardCommon_h */
