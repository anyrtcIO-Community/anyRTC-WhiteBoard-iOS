//
//  ArMainViewController.m
//  AnyRTCBoard
//
//  Created by 余生丶 on 2019/5/15.
//  Copyright © 2019 anyRTC. All rights reserved.
//

#import "ArMainViewController.h"

@interface ArMainViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *roomIdTextField;

@end

@implementation ArMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tap];
}

- (IBAction)joinBoardRoom:(UIButton *)sender {
    /*
     roomId如果存在则加入画板，不存在则创建画板
     根据自己业务逻辑去处理
     */
    if (self.roomIdTextField.text.length != 6) {
        [SVProgressHUD showWithStatus:@"请输入6位画板ID"];
        [SVProgressHUD dismissWithDelay:0.8];
    } else {
        ArRoomViewController *roomVc = [[self storyboard] instantiateViewControllerWithIdentifier:@"AnyRTC_Room"];
        roomVc.roomId = self.roomIdTextField.text;
        roomVc.isTeacher = (BOOL)sender.tag;
        [self.navigationController pushViewController:roomVc animated:YES];
    }
}

- (void)hideKeyBoard{
    [self.roomIdTextField resignFirstResponder];
}

// MARK: - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


@end
