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

@interface Util : NSObject

+ (NSString *)getFilePathWithFileName:(NSString *)fileName andSubDirectory:(NSString *)subDirectory;
+ (BOOL)removeFileByFileName:(NSString *)fileName andSubDirectory:(NSString *)subDirectory;
+ (UIImage *)getPhotoImageWithPhotoName:(NSString *)photoName;

@end
