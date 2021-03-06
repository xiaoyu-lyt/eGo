//
//  AvailableBikeViewController.m
//  eGo
//
//  Created by 萧宇 on 8/18/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "AvailableBikeViewController.h"
#import "TabOneViewController.h"
#import "TabTwoViewController.h"
#import "AddBikeInfoViewController.h"

#import "DLSlideTabView.h"

@interface AvailableBikeViewController ()<DLSlideTabViewDelegate, DLSlideTabViewDatasource>

@property (nonatomic, strong) NSArray<NSString *> *tabTitles;
@property (nonatomic, strong) UITableView *TableView;

@end

@implementation AvailableBikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"车辆列表";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabTitles = @[@"我是乘客", @"我是车主"];
    
    DLSlideTabView *slideTabView = [[DLSlideTabView alloc] initWithFrame:CGRectMake(0.0, 64.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    slideTabView.delegate = self;
    slideTabView.datasource = self;
    [self.view addSubview:slideTabView];
    
    UIBarButtonItem *addBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBikeInfo:)];
    self.navigationItem.rightBarButtonItem = addBarBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBikeInfo:(UIBarButtonItem *)btn {
    AddBikeInfoViewController *addBikeInfoVC = [[AddBikeInfoViewController alloc] init];
    addBikeInfoVC.origin = _origin;
    addBikeInfoVC.destination = _destination;
    [self showViewController:addBikeInfoVC sender:nil];
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
            TabOneViewController *tabOneVC = [[TabOneViewController alloc] init];
            tabOneVC.view.frame = CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            [self addChildViewController:tabOneVC];
            return tabOneVC.view;
        }
            break;
        case 1:{
            TabTwoViewController *tabTwoVC = [[TabTwoViewController alloc] init];
            tabTwoVC.view.frame = CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            [self addChildViewController:tabTwoVC];
            return tabTwoVC.view;
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
