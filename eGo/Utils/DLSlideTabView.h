//
//  DLSlideTabView.h
//  DLSlideTabView
//
//  Created by 萧宇 on 8/11/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DLSlideTabViewDelegate;
@protocol DLSlideTabViewDatasource;

@interface DLSlideTabView : UIView

/** delegate */
@property (nonatomic, weak, setter=setDelegate:) id<DLSlideTabViewDelegate> delegate;
/** datasource */
@property (nonatomic, weak, setter=setDatasource:) id<DLSlideTabViewDatasource> datasource;

- (void)reloadData;

@end

@protocol DLSlideTabViewDelegate <NSObject>

@end

@protocol DLSlideTabViewDatasource <NSObject>

- (NSInteger)numberOfTabsInSlideTabView:(DLSlideTabView *)slideTabView;
- (NSArray<NSString *> *)titleOfTabsInSlideTabView:(DLSlideTabView *)slideTabView;
- (UIView *)slideTabView:(DLSlideTabView *)slideTabView viewForTabAtIndexPath:(NSIndexPath *)indexPath;

@end
