//
//  AnyRTCBoardView.h
//  ARWriteBoard
//
//  Created by zjq on 2018/9/28.
//  Copyright © 2018年 zjq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnyRTCBoardCommon.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnyRTCBoardView : UIView

/**
 初始化

 @param roomID 房间号
 @param fileID 文件ID
 @param userID 用户ID
 @param urlArray 图片数组：可为空,如果第一次，就是初始化一个白板
 @return 画板对象
 */
- (id)initWithRoomID:(NSString*)roomID
          withFileId:(NSString*)fileID
          withUserId:(NSString*)userID
        withUrlArray:(nullable NSArray*)urlArray;

// 画笔信息回调
@property (nonatomic, weak) id<AnyRTCBoardViewDelegate>delegate;

// 设置画笔类型:默认:AnyRTCBoardBrushModelNone
- (void)setBrushModel:(AnyRTCBoardBrushModel)brushModel;
- (AnyRTCBoardBrushModel)getBrushModel;

// 画笔颜色（16进制字符串）：默认:#0000FF蓝色
- (void)setBrushColor:(NSString*)brushColor;
- (NSString*)getBrushColor;

// 画笔粗细设置：默认:2
- (void)setBrushWidth:(int)brushWidth;
- (int)getBrushWidth;

// 撤销一笔
- (BOOL)undo;

// 更改背景
- (void)updateCurrentBgImageWithURL:(NSString*)imageURL;

// 当前画板截图
- (UIImage*)getCurrentSnapShotImage;

// 添加一页（向前加一页或向后加一页）
- (void)addBoard:(nullable NSString*)imageURL withFont:(BOOL)isFont;

// 删除当前画板
- (BOOL)deleteCurrentBoard;

// 前一页翻页（是否同步翻页）
- (BOOL)prePageWithSync:(BOOL)sync;

// 后一页翻页（是否同步翻页）
- (BOOL)nextPageWithSync:(BOOL)sync;

// 调到某一页 (是否同步翻页）
- (BOOL)switchPage:(int)page withSync:(BOOL)sync;

// 清空所有内容（包括背景图片）
- (void)destoryBoard;
// 清空涂鸦内容（不包括背景图片）
- (void)clearAllDraws;
// 清空当前涂鸦内容（不包括背景图片）
- (void)clearCurrentDraw;

// 离开白板 (断开连接)
- (void)leave;

@end

NS_ASSUME_NONNULL_END
