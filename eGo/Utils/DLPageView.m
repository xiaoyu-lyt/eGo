//
//  DLPageView.m
//  pagecontroltest
//
//  Created by 萧宇 on 8/8/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "DLPageView.h"

// 默认的自动切换时间间隔
static const NSTimeInterval kAnimationDuration = 3;
// pageControl的高度
static const CGFloat kHeightForPageControl = 24.0;

@interface DLPageView()<UIScrollViewDelegate>

// 总页数
@property (nonatomic, assign) NSInteger totalPages;
// 当前页码
@property (nonatomic, strong) NSIndexPath *indexPathOfCurrentPage;
// 当前视图
@property (nonatomic, strong) NSMutableArray *currentViews;
// 定时器
@property (nonatomic, strong) NSTimer *animationTimer;

@end

@implementation DLPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.animationDuration = kAnimationDuration;
        [self initPageView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.animationDuration = kAnimationDuration;
        [self initPageView];
    }
    return self;
}

- (void)dealloc {
    self.animationDuration = 0;
}

/**
 *  初始化UI
 */
- (void)initPageView {
    self.indexPathOfCurrentPage = [NSIndexPath indexPathForRow:0 inSection:1];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0.0);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    [self addSubview:self.scrollView];
    
    CGRect rect = self.bounds;
    rect.origin.y = rect.size.height - kHeightForPageControl;
    rect.size.height = kHeightForPageControl;
    self.pageControl = [[UIPageControl alloc] initWithFrame:rect];
    self.pageControl.userInteractionEnabled = NO;
    [self addSubview:self.pageControl];
}

/**
 *  设置自动切换的时间间隔，设置前先将当前定时器置空
 *
 *  @param animationDuration 时间间隔
 */
- (void)setAnimationDuration:(NSTimeInterval)animationDuration {
    if (self.animationTimer) {
        [self.animationTimer invalidate];
        self.animationTimer = nil;
    }
    if (animationDuration > 0.0) {
        _animationDuration = animationDuration;
        [self animationTimerStart:self.animationTimer];
    }
}

/**
 *  添加定时器
 *
 *  @param timer 定时器
 */
- (void)animationTimerStart:(NSTimer *)timer {
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:_animationDuration target:self selector:@selector(animationTimerRun:) userInfo:nil repeats:YES];
}

/**
 *  移除定时器
 *
 *  @param timer 定时器
 */
- (void)animationTimerStop:(NSTimer *)timer {
    [self.animationTimer invalidate];
    self.animationTimer = nil;
}

/**
 *  启动定时器
 *
 *  @param timer 定时器
 */
- (void)animationTimerRun:(NSTimer *)timer {
    if (self.totalPages > 1) {
        CGPoint offset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
        [self.scrollView setContentOffset:offset animated:YES];
    }
}

/**
 *  设置数据源
 *
 *  @param datasource 数据源
 */
- (void)setDatasource:(id<DLPageViewDatasource>)datasource {
    _datasource = datasource;
    [self reloadData];
}

/**
 *  重新加载数据
 */
- (void)reloadData {
    self.totalPages = [self.datasource numberOfPagesInPageView:self];
    if (self.totalPages == 0) {
        return;
    } else if (self.totalPages == 1) {
        self.pageControl.hidden = YES;
    } else {
        self.pageControl.hidden = NO;
    }
    self.pageControl.numberOfPages = self.totalPages;
    [self loadData];
}

/**
 *  加载数据
 */
- (void)loadData {
    self.pageControl.currentPage = self.indexPathOfCurrentPage.row;
    
    NSArray *subViews = [self.scrollView subviews];
    if (subViews.count != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [self displayItemWithIndexPath:self.indexPathOfCurrentPage];
    
    for (NSInteger i = 0; i < 3; i++) {
        UIView *view = [self.currentViews objectAtIndex:i];
        view.userInteractionEnabled = YES;
        // 为每个页面注册点击手势操作
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
        [view addGestureRecognizer:singleTap];
        view.frame = CGRectOffset(view.frame, view.frame.size.width * i, 0.0);
        [self.scrollView addSubview:view];
    }
    
    if (self.totalPages == 1) {
        self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        [self.scrollView setContentOffset:CGPointMake(0.0, 0.0)];
    } else {
        self.scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0.0)];
    }
}

/**
 *  显示页面
 *
 *  @param indexPath 要显示的页面页码
 */
- (void)displayItemWithIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *prevIndexPath = [NSIndexPath indexPathForRow:[self getValidPageValue:self.indexPathOfCurrentPage.row - 1] inSection:self.indexPathOfCurrentPage.section];
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:[self getValidPageValue:self.indexPathOfCurrentPage.row + 1] inSection:self.indexPathOfCurrentPage.section];
    
    if (!self.currentViews) {
        self.currentViews = [[NSMutableArray alloc] init];
    }
    [self.currentViews removeAllObjects];
    [self.currentViews addObject:[self.datasource pageView:self viewForPageAtIndexPath:prevIndexPath]];
    [self.currentViews addObject:[self.datasource pageView:self viewForPageAtIndexPath:indexPath]];
    [self.currentViews addObject:[self.datasource pageView:self viewForPageAtIndexPath:nextIndexPath]];
    
}

/**
 *  点击手势操作
 *
 *  @param tap Tap手势
 */
- (void)singleTapHandle:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(pageView:didSelectPage:atIndexPath:)]) {
        [self.delegate pageView:self didSelectPage:tap.view atIndexPath:self.indexPathOfCurrentPage];
    }
}

/**
 *  获取有效的页码
 *
 *  @param value 转换前的页码
 *
 *  @return 有效的页码
 */
- (NSInteger)getValidPageValue:(NSInteger)value {
    if (value == -1) {
        value = self.totalPages - 1;
    } else if (value == self.totalPages) {
        value = 0;
    }
    return value;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 获取用户滑动的水平距离
    int x = scrollView.contentOffset.x;
    // 左滑翻到下一页
    if(x >= (2 * self.frame.size.width)) {
        self.indexPathOfCurrentPage = [NSIndexPath indexPathForRow:[self getValidPageValue:self.indexPathOfCurrentPage.row + 1] inSection:self.indexPathOfCurrentPage.section];
        [self loadData];
    }
    // 右滑翻到上一页
    if(x <= 0) {
        self.indexPathOfCurrentPage = [NSIndexPath indexPathForRow:[self getValidPageValue:self.indexPathOfCurrentPage.row - 1] inSection:self.indexPathOfCurrentPage.section];
        [self loadData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 用户开始滑动时移除定时器
    [self animationTimerStop:self.animationTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // 用户停止滑动时重新开始定时器
    [self animationTimerStart:self.animationTimer];
}

@end
