//
//  ArBaseViewController.m
//  AnyRTCBoard
//
//  Created by 余生丶 on 2019/5/15.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import "ArBaseViewController.h"
#import "AppDelegate.h"

@interface ArBaseViewController ()

@end

@implementation ArBaseViewController

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
