//
//  AnyRTCMainController.m
//  AnyRTCBoard
//
//  Created by jh on 2018/10/8.
//  Copyright © 2018年 anyRTC. All rights reserved.
//

#import "AnyRTCMainController.h"

@interface AnyRTCMainController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *roomIdTextField;

@end

@implementation AnyRTCMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.roomIdTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tap];
}

- (IBAction)joinBoardRoom:(id)sender {
    /*
            roomId如果存在则加入画板，不存在则创建画板
        */
    if (self.roomIdTextField.text.length != 6) {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD setErrorImage:[UIImage imageNamed:@""]];
        [SVProgressHUD showErrorWithStatus:@"请输入6位画板ID"];
    } else {
        AnyRTCRoomController *roomVc = [[self storyboard] instantiateViewControllerWithIdentifier:@"AnyRTC_Room"];
        roomVc.roomId = self.roomIdTextField.text;
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

@end
