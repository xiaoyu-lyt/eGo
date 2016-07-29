//
//  UIImageView+Utils.m
//  eGo
//
//  Created by 萧宇 on 7/27/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "UIImageView+Utils.h"

#import "Util.h"

@implementation UIImageView (Utils)

/**
 *  点击图片查看大图
 */
- (void)tapToShow {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage:)];
    
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

/**
 *  响应点击图片事件
 *
 *  @param tap 单击手势操作
 */
- (void)showImage:(UITapGestureRecognizer*)tap {
    // 获取当前图片并设置tag方便后续操作使用
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame];
    imageView.image = self.image;
    imageView.tag = 1;
    
    // 添加黑色背景
    UIView *backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    [backgroundView addSubview:imageView];
    // 添加手势操作
    // 单击退出回到原来的界面
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [backgroundView addGestureRecognizer:singleTap];
    // 双击放大图片
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [backgroundView addGestureRecognizer:doubleTap];
    // 双击事件不生效时单击事件才能生效
    [singleTap requireGestureRecognizerToFail:doubleTap];
    // 长按弹出菜单，可进行下载图片操作
    UILongPressGestureRecognizer *downloadPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [backgroundView addGestureRecognizer:downloadPress];
    // 双指捏合缩放图片
    UIPinchGestureRecognizer *resetZoomPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(resetZoomPinch:)];
    [backgroundView addGestureRecognizer:resetZoomPinch];
    // 拖拽移动图片
    UIPanGestureRecognizer *dragPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragPan:)];
    [backgroundView addGestureRecognizer:dragPan];
    
    // 获取应用的window并将背景图层backgroundView设为当前显示的View
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.rootViewController.view addSubview:backgroundView];
    
    // 显示图片动画，默认等比显示图片宽度等于屏幕宽度时的大小
    [UIView animateWithDuration:0.3 animations:^{
        backgroundView.alpha = 1;
        imageView.frame = CGRectMake(0.0, ([UIScreen mainScreen].bounds.size.height - [UIScreen mainScreen].bounds.size.width * self.frame.size.height / self.frame.size.width) / 2,  [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * self.frame.size.height / self.frame.size.width);
    }];
}

/**
 *  响应单击退出查看大图事件
 *
 *  @param tap 单击手势操作
 */
- (void)singleTap:(UITapGestureRecognizer*)tap {
    UIImageView *imageView = (UIImageView *)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.5 animations:^{
        tap.view.alpha = 0;
        imageView.frame = self.frame;
    } completion:^(BOOL finished) {
        [tap.view removeFromSuperview];
    }];
}

/**
 *  响应双击放大图片事件
 *
 *  @param tap 双击手势操作
 */
- (void)doubleTap:(UITapGestureRecognizer *)tap {
    UIImageView *imageView = (UIImageView *)[tap.view viewWithTag:1];
    // 判断当前图片是否为已放大状态
    if (imageView.frame.size.width == [UIScreen mainScreen].bounds.size.width) {
        [UIView animateWithDuration:0.3 animations:^{
            imageView.frame = CGRectMake(-0.28 * [UIScreen mainScreen].bounds.size.width, -0.28 * [UIScreen mainScreen].bounds.size.width * self.frame.size.height / self.frame.size.width,  [UIScreen mainScreen].bounds.size.width * 2.56, [UIScreen mainScreen].bounds.size.width * 2.56 * self.frame.size.height / self.frame.size.width);
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            imageView.frame = CGRectMake(0.0, ([UIScreen mainScreen].bounds.size.height - [UIScreen mainScreen].bounds.size.width * self.frame.size.height / self.frame.size.width) / 2,  [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * self.frame.size.height / self.frame.size.width);
        }];
    }
}

/**
 *  响应长按弹出菜单事件
 *
 *  @param press 长按手势操作
 */
- (void)longPress:(UILongPressGestureRecognizer *)press {
    NSArray *titles = @[@"保存到本地相册"];
    NSArray *handlers = @[^{
        UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }];
    [[self getViewController] alertSheetMessage:@"" withTitles:titles andHandlers:handlers];
}

/**
 *  响应捏合缩放图片事件
 *
 *  @param pinch 捏合手势操作
 */
- (void)resetZoomPinch:(UIPinchGestureRecognizer *)pinch {
    UIImageView *imageView = (UIImageView *)[pinch.view viewWithTag:1];
    static float imageWidth, imageHeight;
    switch (pinch.state) {
        // 获取开始缩放时的大小
        case UIGestureRecognizerStateBegan:
            imageWidth = imageView.frame.size.width;
            imageHeight = imageView.frame.size.height;
        // 改变图片大小
        case UIGestureRecognizerStateChanged:
            if (imageWidth * pinch.scale > [UIScreen mainScreen].bounds.size.width * 2.56 && imageHeight * pinch.scale > [UIScreen mainScreen].bounds.size.height) {
                return;
            }
            imageView.frame = CGRectMake(imageView.frame.origin.x - (imageWidth * pinch.scale - imageView.frame.size.width) / 2, imageView.frame.origin.y - (imageHeight * pinch.scale - imageView.frame.size.height) / 2, imageWidth * pinch.scale, imageHeight * pinch.scale);
            break;
        // 松开手指判断当前图片大小并进行相应操作
        case UIGestureRecognizerStateEnded:
            if (imageView.frame.size.width < [UIScreen mainScreen].bounds.size.width) {
                [UIView animateWithDuration:0.3 animations:^{
                    imageView.frame = CGRectMake(0.0, ([UIScreen mainScreen].bounds.size.height - [UIScreen mainScreen].bounds.size.width * self.frame.size.height / self.frame.size.width) / 2,  [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * self.frame.size.height / self.frame.size.width);
                }];
            } else if (imageView.frame.size.height > [UIScreen mainScreen].bounds.size.height) {
                if ([UIScreen mainScreen].bounds.size.height * self.frame.size.width / self.frame.size.height > [UIScreen mainScreen].bounds.size.width) {
                    [UIView animateWithDuration:0.3 animations:^{
                        imageView.frame = CGRectMake(imageView.frame.origin.x - ([UIScreen mainScreen].bounds.size.height * self.frame.size.width / self.frame.size.height - imageView.frame.size.width) / 2, imageView.frame.origin.y - ([UIScreen mainScreen].bounds.size.height - imageView.frame.size.height) / 2, [UIScreen mainScreen].bounds.size.height * self.frame.size.width / self.frame.size.height, [UIScreen mainScreen].bounds.size.height);
                    }];
                }
            }
        default:
            break;
    }
}

/**
 *  响应拖拽移动图片事件
 *
 *  @param pan 拖拽手势操作
 */
- (void)dragPan:(UIPanGestureRecognizer *)pan {
    UIImageView *imageView = (UIImageView *)[pan.view viewWithTag:1];
    static float imageX, imageY;
    switch (pan.state) {
        // 获取开始拖拽时的位置
        case UIGestureRecognizerStateBegan:
            imageX = imageView.frame.origin.x;
            imageY = imageView.frame.origin.y;
            break;
        // 移动图片
        case UIGestureRecognizerStateChanged:
            imageView.frame = CGRectMake(imageX + [pan translationInView:pan.view].x, imageY + [pan translationInView:pan.view].y, imageView.frame.size.width, imageView.frame.size.height);
            break;
        // 松开手指时判断当前图片位置并进行相应操作
        case UIGestureRecognizerStateEnded:
            NSLog(@"%f, %f, %f, %f", imageX, imageY, [pan translationInView:pan.view].x, [pan translationInView:pan.view].y);
            if (imageX + [pan translationInView:pan.view].x > 0) {
                [UIView animateWithDuration:0.3 animations:^{
                    imageView.frame = CGRectMake(0.0, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height);
                }];
            } else if (imageX + [pan translationInView:pan.view].x + imageView.frame.size.width < [UIScreen mainScreen].bounds.size.width) {
                [UIView animateWithDuration:0.3 animations:^{
                    imageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - imageView.frame.size.width, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height);
                }];
            }
            if (imageY + [pan translationInView:pan.view].y > 0) {
                [UIView animateWithDuration:0.3 animations:^{
                    imageView.frame = CGRectMake(imageView.frame.origin.x, (imageView.frame.size.height < [UIScreen mainScreen].bounds.size.height) ? ([UIScreen mainScreen].bounds.size.height - imageView.frame.size.height) / 2 : 0.0, imageView.frame.size.width, imageView.frame.size.height);
                }];
            } else if (imageY + [pan translationInView:pan.view].y + imageView.frame.size.height < [UIScreen mainScreen].bounds.size.height) {
                [UIView animateWithDuration:0.3 animations:^{
                    imageView.frame = CGRectMake(imageView.frame.origin.x, (imageView.frame.size.height < [UIScreen mainScreen].bounds.size.height) ? ([UIScreen mainScreen].bounds.size.height - imageView.frame.size.height) / 2 : [UIScreen mainScreen].bounds.size.height - imageView.frame.size.height, imageView.frame.size.width, imageView.frame.size.height);
                }];
            }
            break;
        default:
            break;
    }
    
}

/**
 *  获取当前图片所属Controller，用于弹出菜单
 *
 *  @return 当前图片所属Controller
 */
-(UIViewController*)getViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

/**
 *  实现将图片保存到本地相册操作
 *
 *  @param image       要保存的图片
 *  @param error       错误信息
 *  @param contextInfo 内容信息
 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error == nil) {
        [[UIApplication sharedApplication].keyWindow.rootViewController.view makeToast:@"保存成功"];
    }else{
        [[UIApplication sharedApplication].keyWindow.rootViewController.view makeToast:@"保存失败"];
    }
}

@end
