//
//  CampusTrafficViewController.m
//  eGo
//
//  Created by 萧宇 on 7/27/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "CampusTrafficViewController.h"
#import "SearchViewController.h"

#import "Util.h"
#import "AFNetworking.h"
#import "AMapManager.h"

@interface CampusTrafficViewController ()<UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, strong) NSArray *busesLocationArray;
@property (nonatomic, strong) NSTimer *addAnimatedAnnotationTimer;

@end

@implementation CampusTrafficViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.searchBar.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigationBarButton];
    
    AMapManager *manager = [AMapManager manager];
    manager.mapView.frame = CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view insertSubview:manager.mapView atIndex:0];
    
    // 注册循环，每隔5秒获取一次小白位置
    self.addAnimatedAnnotationTimer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(getBusesLocation) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.addAnimatedAnnotationTimer forMode:NSRunLoopCommonModes];
    [self getBusesLocation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[AMapManager manager] resetMapView];
    [self.addAnimatedAnnotationTimer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getBusesLocation {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[kApiUrl stringByAppendingPathComponent:@"bus.html"] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.busesLocationArray = responseObject;
        
        [[AMapManager manager] addBusAnnotationsWithLocations:self.busesLocationArray];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

#pragma mark - ButtonClicked

- (IBAction)locateBtnClicked:(id)sender {
    [[AMapManager manager] locate];
}
- (IBAction)zoomLevelUpBtnClicked:(id)sender {
    [[AMapManager manager].mapView setZoomLevel:[AMapManager manager].mapView.zoomLevel + 0.3 animated:YES];
}
- (IBAction)zoomLevelDownBtnClicked:(id)sender {
    [[AMapManager manager].mapView setZoomLevel:[AMapManager manager].mapView.zoomLevel - 0.3 animated:YES];
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self showViewController:[[SearchViewController alloc] init] sender:nil];
    return NO;
}

@end
