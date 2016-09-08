//
//  BusInfoViewController.m
//  eGo
//
//  Created by 萧宇 on 8/15/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "BusInfoViewController.h"

#import "Util.h"
#import "AMapManager.h"
#import "AFNetworking.h"

static const double kRadius = 6371004;

@interface BusInfoViewController ()

@property (strong, nonatomic) IBOutlet UILabel *routeLbl;
@property (strong, nonatomic) IBOutlet UILabel *distanceLbl;
@property (strong, nonatomic) IBOutlet UILabel *velocityLbl;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;
@property (strong, nonatomic) IBOutlet UILabel *stationLbl;
@property (strong, nonatomic) IBOutlet UILabel *telLbl;

@end

@implementation BusInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [NSString stringWithFormat:@"%ld号小白", (long)_busId];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callDriver:)];
    self.telLbl.userInteractionEnabled = YES;
    [self.telLbl addGestureRecognizer:tap];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[kApiUrl stringByAppendingString:[NSString stringWithFormat:@"bus/%ld.html", (long)_busId]] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.distanceLbl.text = [NSString stringWithFormat:@"%.2f", [self getDistanceWithLatitude:[responseObject[@"latitude"] doubleValue] andLongitude:[responseObject[@"longitude"] doubleValue]]];
        self.velocityLbl.text = @"10.05";
        self.telLbl.text = responseObject[@"drivertel"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 根据经纬度计算距离
- (double)getDistanceWithLatitude:(double)latitude andLongitude:(double)longitude {
    double c = sin(latitude) * sin([AMapManager manager].userLocation.location.coordinate.latitude) * cos(longitude-[AMapManager manager].userLocation.location.coordinate.longitude) + cos(latitude) * cos([AMapManager manager].userLocation.location.coordinate.latitude);
    return kRadius * acos(c) * M_PI / 180;
}

- (void)callDriver:(UIGestureRecognizer *)tap {
//    UIWebView *callWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
//    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", ((UILabel *)(tap.view)).text]]]];
//    [self.view addSubview:callWebView];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", ((UILabel *)(tap.view)).text]]];
}

@end
