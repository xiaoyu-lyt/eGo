//
//  DLSlideTabView.m
//  DLSlideTabView
//
//  Created by 萧宇 on 8/11/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "DLSlideTabView.h"

@interface DLSlideTabView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic, strong) UIView *slideView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@end

@implementation DLSlideTabView

#pragma mark - init method

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSlideTabView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSlideTabView];
    }
    return self;
}

- (void)initSlideTabView {
    // 初始化当前索引
    self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    // 构建UI
    // 顶部标题栏
    self.titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 44.0)];
    self.titleScrollView.delegate = self;
    self.titleScrollView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1.0];
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    self.titleScrollView.pagingEnabled = NO;
    [self addSubview:_titleScrollView];
    
    // 标题下方滑动的横线
    self.slideView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 42.0, 20.0, 2.0)];
    self.slideView.backgroundColor = [UIColor colorWithRed:0.085 green:0.625 blue:1.0 alpha:1.0];
    [self addSubview:_slideView];
    
    // 内容部分
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 44.0, self.frame.size.width, self.frame.size.height - 44.0)];
    self.contentScrollView.delegate = self;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.pagingEnabled = YES;
    [self addSubview:_contentScrollView];
}

#pragma mark - setter method

- (void)setDatasource:(id<DLSlideTabViewDatasource>)datasource {
    _datasource = datasource;
    [self reloadData];
}

#pragma mark - public method

- (void)reloadData {
    [self loadData];
}

#pragma mark - private method

- (void)loadData {
    NSArray *subViews = _titleScrollView.subviews;
    if (subViews.count > 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    NSArray<NSString *> *titles = [self.datasource titleOfTabsInSlideTabView:self];
    NSString *regexString = @"[a-zA-Z0-9]*";    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:nil];
    for (int i = 0, length = 0; i < titles.count; i++) {
        NSInteger letterCount = 0;
        NSArray *matchedArray = [[NSArray alloc] init];
        matchedArray = [regex matchesInString:titles[i] options:0 range:NSMakeRange(0, titles[i].length)];
        for (NSTextCheckingResult *tcr in matchedArray) {
            letterCount += [titles[i] substringWithRange:tcr.range].length;
        }
        UILabel *tab = [[UILabel alloc] initWithFrame:CGRectMake(length, 4.0, (titles[i].length - letterCount) * 18.0 + letterCount * 10.0 + 8.0, 36.0)];
        tab.text = titles[i];
        tab.textAlignment = NSTextAlignmentCenter;
        tab.tag = i;
        [self.titleScrollView addSubview:tab];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandler:)];
        tab.userInteractionEnabled = YES;
        [tab addGestureRecognizer:singleTap];
        
        length += tab.frame.size.width;
        self.titleScrollView.contentSize = CGSizeMake(_titleScrollView.contentSize.width + tab.frame.size.width, _titleScrollView.contentSize.height);
    }
    if (_titleScrollView.contentSize.width < self.frame.size.width) {
        _titleScrollView.scrollEnabled = NO;
        for (UIView *subView in _titleScrollView.subviews) {
            if ([subView isKindOfClass:[UILabel class]]) {
                subView.frame = CGRectMake(self.frame.size.width / [_datasource numberOfTabsInSlideTabView:self] * [_titleScrollView.subviews indexOfObject:subView], subView.frame.origin.y, self.frame.size.width / [_datasource numberOfTabsInSlideTabView:self], subView.frame.size.height);
            }
        }
    }
    [(UILabel *)self.titleScrollView.subviews.firstObject setTextColor:[UIColor colorWithRed:0.085 green:0.625 blue:1.0 alpha:1.0]];
    self.slideView.frame = CGRectMake(0.0, 42.0, _titleScrollView.subviews.firstObject.frame.size.width, 2.0);
    [self displayContentView];
}

- (void)displayContentView {
    NSInteger tabsCount = [_datasource numberOfTabsInSlideTabView:self];
    self.contentScrollView.contentSize = CGSizeMake(self.bounds.size.width * tabsCount, self.bounds.size.height - 44.0);
    for (int i = 0; i < tabsCount; i++) {
        UIView *view = [_datasource slideTabView:self viewForTabAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        view.frame = CGRectOffset(view.frame, view.frame.size.width * i, 0.0);
        [self.contentScrollView addSubview:view];
    }
}

-(void)resetTitleWithColor:(UIColor *)color {
    for (UIView *subView in _titleScrollView.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            [(UILabel *)subView setTextColor:color];
        }
    }
}

- (NSInteger)getValidIndexValue:(NSInteger)value {
    return (value == -1) ? 0 : ((value == [_datasource numberOfTabsInSlideTabView:self]) ? [_datasource numberOfTabsInSlideTabView:self] - 1 : value);
}

#pragma mark - UIGestureRecognizer responser method
- (void)singleTapHandler:(UITapGestureRecognizer *)tap {
    [self resetTitleWithColor:[UIColor blackColor]];
    self.currentIndexPath = [NSIndexPath indexPathForRow:tap.view.tag inSection:0];
    [(UILabel *)tap.view setTextColor:[UIColor colorWithRed:0.085 green:0.625 blue:1.0 alpha:1.0]];
    [UIView animateWithDuration:0.3 animations:^{
        self.slideView.frame = CGRectMake(tap.view.frame.origin.x - _titleScrollView.contentOffset.x, 42.0, tap.view.frame.size.width, 2.0);
    }];
    [self.contentScrollView setContentOffset:CGPointMake(self.frame.size.width * tap.view.tag, 0.0) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _titleScrollView) {
        UILabel *currentLbl = (UILabel *)[_titleScrollView viewWithTag:_currentIndexPath.row];
        self.slideView.frame = CGRectMake(currentLbl.frame.origin.x - scrollView.contentOffset.x, _slideView.frame.origin.y, _slideView.frame.size.width, _slideView.frame.size.height);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _contentScrollView) {
        float x = scrollView.contentOffset.x - self.frame.size.width * _currentIndexPath.row;
        if (x < 0) {
            self.currentIndexPath = [NSIndexPath indexPathForRow:[self getValidIndexValue:_currentIndexPath.row - 1] inSection:0];
        } else if (x > 0) {
            self.currentIndexPath = [NSIndexPath indexPathForRow:[self getValidIndexValue:_currentIndexPath.row + 1] inSection:0];
        }
        [self resetTitleWithColor:[UIColor blackColor]];
        UIView *currentTabView = _titleScrollView.subviews[_currentIndexPath.row];
        if ([currentTabView isKindOfClass:[UILabel class]]) {
            [(UILabel *)currentTabView setTextColor:[UIColor colorWithRed:0.085 green:0.625 blue:1.0 alpha:1.0]];
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.slideView.frame = CGRectMake(currentTabView.frame.origin.x - _titleScrollView.contentOffset.x, 42.0, currentTabView.frame.size.width, 2.0);
            if (currentTabView.frame.origin.x < _titleScrollView.contentOffset.x) {
                self.titleScrollView.contentOffset = CGPointMake(currentTabView.frame.origin.x, _titleScrollView.contentOffset.y);
            } else if (currentTabView.frame.origin.x + currentTabView.frame.size.width > _titleScrollView.contentOffset.x + self.frame.size.width) {
                self.titleScrollView.contentOffset = CGPointMake(currentTabView.frame.origin.x + currentTabView.frame.size.width - self.frame.size.width, _titleScrollView.contentOffset.y);
            }
        }];
    }
}

@end
