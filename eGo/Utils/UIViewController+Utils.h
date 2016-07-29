//
//  UIViewController+Utils.h
//  eGo
//
//  Created by 萧宇 on 7/13/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Utils)

- (void)setNavigationBarButton;
- (void)alertMessage:(NSString *)message;
- (void)alertConfirmMessage:(NSString *)message withTitle1:(NSString *)title1 style1:(UIAlertActionStyle)style1 handler1:(void (^)(void))handler1 andTitle2:(NSString *)title2 style2:(UIAlertActionStyle)style2 handler2:(void (^)(void))handler2;
- (void)alertSheetMessage:(NSString *)message withTitles:(NSArray<NSString *> *)titles andHandlers:(NSArray<void (^)(void)> *)handlers;

@end
