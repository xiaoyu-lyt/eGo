//
//  ShowRouteViewController.m
//  eGo
//
//  Created by 萧宇 on 8/20/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "ShowRouteViewController.h"

#import "AMapManager.h"

@interface ShowRouteViewController ()

@end

@implementation ShowRouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    AMapManager *manager = [AMapManager manager];
    manager.mapView.frame = CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view insertSubview:manager.mapView atIndex:0];
    [manager searchRouteWithOrigin:_origin andDestination:_destination];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[AMapManager manager] resetMapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
