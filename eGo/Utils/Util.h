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
#import "UIViewController+Utils.h"

// API路由前缀，用于拼接完整的API路由
static NSString* const kApiUrl = @"http://localhost/coding/API/eGoServer/index.php/api/";

@interface Util : NSObject

+ (NSString *)getFilePathWithFileName:(NSString *)fileName andSubDirectory:(NSString *)subDirectory;
+ (BOOL)removeFileByFileName:(NSString *)fileName andSubDirectory:(NSString *)subDirectory;
+ (UIImage *)getPhotoImageWithPhotoName:(NSString *)photoName;
+ (UIImage *)setImage:(UIImage *)image withWidth:(float)width andHeight:(float)height;
+ (UIViewController*)getViewController:(UIView *)view;

@end
