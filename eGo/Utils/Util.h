//
//  Util.h
//  eGo
//
//  Created by 萧宇 on 7/13/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+Toast.h"
#import "UIColor+Utils.h"
#import "UIImageView+Utils.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+Utils.h"

// API路由前缀，用于拼接完整的API路由
static NSString* const kApiUrl = @"http://localhost/coding/API/eGoServer/index.php/api/";

// 设置tag时在此基础上计算
static const NSInteger BASIC_TAG_VALUE = 100000;

@interface Util : NSObject

+ (NSString *)getFilePathWithFileName:(NSString *)fileName andSubDirectory:(NSString *)subDirectory;
+ (BOOL)removeFileByFileName:(NSString *)fileName andSubDirectory:(NSString *)subDirectory;
+ (UIImage *)getPhotoImageWithPhotoName:(NSString *)photoName;
+ (UIImage *)setImage:(UIImage *)image withWidth:(float)width andHeight:(float)height;
+ (UIViewController *)getViewController:(UIView *)view;
+ (void)setNavigationBarTransparentWithViewController:(UIViewController *)vc;
+ (void)resetNavigationBarWithViewController:(UIViewController *)vc andTitleColor:(UIColor *)color;

@end
