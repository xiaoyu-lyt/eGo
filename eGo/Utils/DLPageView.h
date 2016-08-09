//
//  DLPageView.h
//  pagecontroltest
//
//  Created by 萧宇 on 8/8/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DLPageViewDelegate;
@protocol DLPageViewDatasource;

@interface DLPageView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) NSTimeInterval animationDuration;
/** delegate */
@property (nonatomic, weak, setter=setDelegate:) id<DLPageViewDelegate> delegate;
/** datasource */
@property (nonatomic, weak, setter=setDatasource:) id<DLPageViewDatasource> datasource;

- (void)reloadData;

@end

@protocol DLPageViewDelegate <NSObject>

@optional
/**
 *  点击当前页面触发事件，可选
 *
 *  @param pageView  pageView类
 *  @param view      选中的页面
 *  @param indexPath 选中的页码
 */
- (void)pageView:(DLPageView *)pageView didSelectPage:(UIView *)view atIndexPath:(NSIndexPath *)indexPath;

@end

@protocol DLPageViewDatasource <NSObject>

/**
 *  返回总页面数
 *
 *  @param pageView 当前pageView
 *
 *  @return 总页面数
 */
- (NSInteger)numberOfPagesInPageView:(DLPageView *)pageView;

/**
 *  设置每个页面的View
 *
 *  @param pageView  当前pageView
 *  @param indexPath 当前页码
 *
 *  @return 一个page的view
 */
- (UIView *)pageView:(DLPageView *)pageView viewForPageAtIndexPath:(NSIndexPath *)indexPath;

@end
