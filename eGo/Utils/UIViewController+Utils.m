//
//  UIViewController+Utils.m
//  eGo
//
//  Created by 萧宇 on 7/13/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "UIViewController+Utils.h"
#import "MessageCenterViewController.h"

@implementation UIViewController (Utils)

// 弹出提示框
- (void)alertMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:confirmAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

// 设置NavigationBarButton
- (void)setNavigationBarButton {
    UIBarButtonItem *message = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Account"] style:UIBarButtonItemStyleDone target:self action:@selector(enterMessageCenter)];
    self.navigationItem.rightBarButtonItem = message;
}

// 点击右上角BarButton触发事件
- (void)enterMessageCenter {
    MessageCenterViewController *messageCenterVC = [[MessageCenterViewController alloc] init];
    [self showViewController:messageCenterVC sender:nil];
}

@end
