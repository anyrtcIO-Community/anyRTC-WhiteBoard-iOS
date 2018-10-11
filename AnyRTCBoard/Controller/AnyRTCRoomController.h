//
//  AnyRTCRoomController.h
//  AnyRTCBoard
//
//  Created by jh on 2018/10/8.
//  Copyright © 2018年 anyRTC. All rights reserved.
//

#import "AnyRTCBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnyRTCRoomController : AnyRTCBaseController

@property (copy, nonatomic) NSString *roomId;
//1创建画板 0加入画板
@property (assign ,nonatomic) BOOL isTeacher;

@end

NS_ASSUME_NONNULL_END
