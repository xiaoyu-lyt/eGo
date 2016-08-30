//
//  MessageCenterViewController.m
//  eGo
//
//  Created by 萧宇 on 8/29/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "MessageViewController.h"
#import "NoticeViewController.h"

#import "DLSlideTabView.h"

@interface MessageCenterViewController ()<DLSlideTabViewDelegate, DLSlideTabViewDatasource>

@property (nonatomic, strong) NSArray<NSString *> *tabTitles;
@property (nonatomic, strong) UITableView *TableView;

@end

@implementation MessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"消息中心";
    self.tabTitles = @[@"消息", @"通知"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    DLSlideTabView *slideTabView = [[DLSlideTabView alloc] initWithFrame:CGRectMake(0.0, 64.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    slideTabView.delegate = self;
    slideTabView.datasource = self;
    [self.view addSubview:slideTabView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 页面即将显示时隐藏TabBarController
    [UIView animateWithDuration:0.5 animations:^{
        self.tabBarController.tabBar.center = CGPointMake(self.tabBarController.tabBar.center.x, self.tabBarController.tabBar.center.y + 48);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 页面即将退出时显示TabBarController
    [UIView animateWithDuration:0.3 animations:^{
        self.tabBarController.tabBar.center = CGPointMake(self.tabBarController.tabBar.center.x, self.tabBarController.tabBar.center.y - 48);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DLSlideTabViewDatasource

- (NSInteger)numberOfTabsInSlideTabView:(DLSlideTabView *)slideTabView {
    return self.tabTitles.count;
}

- (NSArray<NSString *> *)titleOfTabsInSlideTabView:(DLSlideTabView *)slideTabView {
    return self.tabTitles;
}

- (UIView *)slideTabView:(DLSlideTabView *)slideTabView viewForTabAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            MessageViewController *messageVC = [[MessageViewController alloc] init];
            messageVC.view.frame = CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            [self addChildViewController:messageVC];
            return messageVC.view;
        }
            break;
        case 1:{
            NoticeViewController *noticeVC = [[NoticeViewController alloc] init];
            noticeVC.view.frame = CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            [self addChildViewController:noticeVC];
            return noticeVC.view;
        }
            break;
        default:
            return [[UIView alloc] init];
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
