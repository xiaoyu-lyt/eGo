//
//  BusInfoViewController.m
//  eGo
//
//  Created by 萧宇 on 8/15/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "BusInfoViewController.h"

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)callDriver:(UIGestureRecognizer *)tap {
    NSLog(@"%@", ((UILabel *)(tap.view)).text);
//    UIWebView *callWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
//    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", ((UILabel *)(tap.view)).text]]]];
//    [self.view addSubview:callWebView];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", ((UILabel *)(tap.view)).text]]];
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
