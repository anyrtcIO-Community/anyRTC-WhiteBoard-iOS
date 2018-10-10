//
//  AnyRTCBaseController.m
//  AnyRTCBoard
//
//  Created by jh on 2018/10/8.
//  Copyright © 2018年 anyRTC. All rights reserved.
//

#import "AnyRTCBaseController.h"
#import "AppDelegate.h"

@interface AnyRTCBaseController ()

@end

@implementation AnyRTCBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)toOrientation:(UIInterfaceOrientation)orientation {
    [UIView beginAnimations:nil context:nil];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationUnknown] forKey:@"orientation"];
    // 旋转屏幕
    NSNumber *value = [NSNumber numberWithInt:orientation];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    [UIView setAnimationDelegate:self];
    //开始旋转
    [UIView commitAnimations];
    [self.view layoutIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
