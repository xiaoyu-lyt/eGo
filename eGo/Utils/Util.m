//
//  Util.m
//  eGo
//
//  Created by 萧宇 on 7/13/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "Util.h"

@implementation Util

/**
 *  根据文件名获取完整的文件路径
 *
 *  @param fileName     文件名
 *  @param subDirectory 子目录
 *
 *  @return 文件路径
 */
+ (NSString *)getFilePathWithFileName:(NSString *)fileName andSubDirectory:(NSString *)subDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths firstObject] stringByAppendingPathComponent:subDirectory];
    // 判断子目录是否存在，若不存在则创建新一个
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = TRUE;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDirectory]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [path stringByAppendingPathComponent:fileName];
}

/**
 *  根据文件名删除文件
 *
 *  @param fileName     文件名
 *  @param subDirectory 子目录名
 *
 *  @return 是否成功删除
 */
+ (BOOL)removeFileByFileName:(NSString *)fileName andSubDirectory:(NSString *)subDirectory {
    NSString *filePath = [self getFilePathWithFileName:fileName andSubDirectory:subDirectory];
    NSFileManager* fileManager=[NSFileManager defaultManager];
    BOOL isFileExist=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!isFileExist) {
        return YES;
    } else {
        BOOL deleteResult= [fileManager removeItemAtPath:filePath error:nil];
        if (deleteResult) {
            return YES;
        }else {
            return NO;
        }
    }
}

/**
 *  根据照片文件名获取照片
 *
 *  @param photoName 照片文件名
 *
 *  @return UIImage格式的图片
 */
+ (UIImage *)getPhotoImageWithPhotoName:(NSString *)photoName {
    if (photoName != nil && photoName.length > 0) {
        NSData *imageData = [NSData dataWithContentsOfFile:[self getFilePathWithFileName:photoName andSubDirectory:@"Images"]];
        return ([UIImage imageWithData:imageData] == nil) ? [UIImage imageNamed:@"DefaultImage"] : [UIImage imageWithData:imageData];
    } else {
        return [UIImage imageNamed:@"DefaultImage"];
    }
}

/**
 *  设置图片大小
 *
 *  @param image  要设置的图片
 *  @param width  宽度
 *  @param height 高度
 *
 *  @return 设置后的图片
 */
+ (UIImage *)setImage:(UIImage *)image withWidth:(float)width andHeight:(float)height {
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [image drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

/**
 *  获取当前图片所属Controller
 *
 *  @return 当前图片所属Controller
 */
+ (UIViewController*)getViewController:(UIView *)view {
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

+ (void)setNavigationBarTransparentWithViewController:(UIViewController *)vc {
    vc.navigationController.navigationBar.translucent = YES;
    [vc.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    vc.navigationController.navigationBar.shadowImage = [UIImage new];
    vc.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    vc.navigationController.view.backgroundColor = [UIColor clearColor];
}

+ (void)resetNavigationBarWithViewController:(UIViewController *)vc andTitleColor:(UIColor *)color {
    [vc.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [vc.navigationController.navigationBar setShadowImage:nil];
    NSDictionary *attributes = @{NSForegroundColorAttributeName : color};
    [vc.navigationController.navigationBar setTitleTextAttributes:attributes];
}

+ (BOOL)isEmailAddress:(NSString *)email {
    NSString *re = @"^([A-Za-z0-9\\.\\-_]{1,})@((?:[A-Za-z0-9]+(?:[\\-|\\.][A-Za-z0-9]+)*)+\\.[A-Za-z]{2,6})$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", re];
    
    return [emailTest evaluateWithObject:email];
}

@end
