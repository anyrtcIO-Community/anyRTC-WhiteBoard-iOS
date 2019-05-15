//
//  ArRoomViewController.h
//  AnyRTCBoard
//
//  Created by 余生丶 on 2019/5/15.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import "ArBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArRoomViewController : ArBaseViewController

@property (copy, nonatomic) NSString *roomId;
//1创建画板 0加入画板
@property (assign ,nonatomic) BOOL isTeacher;

@end

NS_ASSUME_NONNULL_END
