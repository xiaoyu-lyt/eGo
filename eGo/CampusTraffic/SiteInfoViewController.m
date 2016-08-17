//
//  SiteInfoViewController.m
//  eGo
//
//  Created by 萧宇 on 8/17/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "SiteInfoViewController.h"

#import "AMapManager.h"

@interface SiteInfoViewController ()

@end

@implementation SiteInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    AMapManager *manager = [AMapManager manager];
    manager.mapView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view insertSubview:manager.mapView atIndex:0];
    
    if (self.keywords.length == 0) {
        [self showSites:@[self.site]];
    } else {
        [[AMapManager manager] searchWithPOIKeywords:self.keywords];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[AMapManager manager] resetMapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showSites:(NSArray *)sites {
    [[AMapManager manager] addSiteAnnotationsWithLocations:sites];
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
