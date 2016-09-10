//
//  UIViewController+Utils.m
//  eGo
//
//  Created by 萧宇 on 7/13/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "UIViewController+Utils.h"
#import "PersonalViewController.h"
#import "MessageCenterViewController.h"

#import "User.h"
#import "Util.h"

@implementation UIViewController (Utils)

// 设置NavigationBarButton
- (void)setNavigationBarButton {
//    UIImage *userPhotoImage = [Util getPhotoImageWithPhotoName:[NSString stringWithFormat:@"%@.jpg", [[User sharedUser].user objectForKey:@"photoName"]]];
//    userPhotoImage = [Util setImage:userPhotoImage withWidth:32 andHeight:32];
    UIImageView *userPhotoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 32.0, 32.0)];
    [userPhotoImageView sd_setImageWithURL:[NSURL URLWithString:[kImageUrl stringByAppendingString:[NSString stringWithFormat:@"User/%@.png", [User sharedUser].avatar]]] placeholderImage:[UIImage imageNamed:@"loading.gif"]];
    userPhotoImageView.layer.cornerRadius = 16.0;
    [userPhotoImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterPersonalSetting)]];
    UIBarButtonItem *userPhoto = [[UIBarButtonItem alloc] initWithCustomView:userPhotoImageView];
    self.navigationItem.leftBarButtonItem = userPhoto;
    UIBarButtonItem *message = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Notice"] style:UIBarButtonItemStyleDone target:self action:@selector(enterMessageCenter)];
    self.navigationItem.rightBarButtonItem = message;
}
// 点击左上角BarButton触发事件
- (void)enterPersonalSetting {
    PersonalViewController *personalVC = [[PersonalViewController alloc] init];
    [self showViewController:personalVC sender:nil];
}
// 点击右上角BarButton触发事件
- (void)enterMessageCenter {
    MessageCenterViewController *messageCenterVC = [[MessageCenterViewController alloc] init];
    [self showViewController:messageCenterVC sender:nil];
}

// 弹出提示框
- (void)alertMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:confirmAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}
// 弹出确认提示框
- (void)alertConfirmMessage:(NSString *)message withTitle1:(NSString *)title1 style1:(UIAlertActionStyle)style1 handler1:(void (^)(void))handler1 andTitle2:(NSString *)title2 style2:(UIAlertActionStyle)style2 handler2:(void (^)(void))handler2 {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:title1 style:style1 handler:^(UIAlertAction * _Nonnull action) {
        handler1();
    }];
    [alert addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:title2 style:style2 handler:^(UIAlertAction * _Nonnull action) {
        handler2();
    }];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}
// 弹出菜单选择框
- (void)alertSheetMessage:(NSString *)message withTitles:(NSArray<NSString *> *)titles andHandlers:(NSArray<void (^)(void)> *)handlers {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < titles.count; i++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:titles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            handlers[i]();
        }];
        [alert addAction:action];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
