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
    [self setNavigationBarButton];
    
    self.searchBar.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AMapManager *manager = [AMapManager manager];
    manager.mapView.frame = CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view insertSubview:manager.mapView atIndex:0];
    
    // 注册循环，每隔5秒获取一次小白位置
    self.addAnimatedAnnotationTimer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(getBusesLocation) userInfo:nil repeats:YES];
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
    static float latitude = 26.059522, longitude = 119.194197;
    latitude += 0.0001;
    longitude += 0.0001;
    self.busesLocationArray = @[@{@"latitude" : [NSString stringWithFormat:@"%f", latitude], @"longitude" : [NSString stringWithFormat:@"%f", longitude]}];
    [[AMapManager manager] addBusAnnotationsWithLocations:self.busesLocationArray];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
