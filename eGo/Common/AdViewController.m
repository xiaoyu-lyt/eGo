//
//  AdViewController.m
//  eGo
//
//  Created by 萧宇 on 7/29/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "AdViewController.h"
#import "BaseViewController.h"
#import "LoginViewController.h"

#import "User.h"
#import "Util.h"
#import "AFNetworking.h"

@interface AdViewController ()

@property (nonatomic, strong) UIButton *interAppBtn;

@property (nonatomic) int countTime;
@property (nonatomic, strong) NSTimer *interAppTimer;
@property (nonatomic, strong) NSString *imageName;

@end

@implementation AdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[kApiUrl stringByAppendingPathComponent:@"SystemImages/getBackgroundImage.html"] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self loadImage:responseObject[@"image"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self loadImage:nil];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadImage:(NSString *)imageName {
    UIImageView *adImgView = [[UIImageView alloc] init];
    [adImgView sd_setImageWithURL:[NSURL URLWithString:[kImageUrl stringByAppendingString:[NSString stringWithFormat:@"System/%@", imageName]]] placeholderImage:[UIImage imageNamed:@"Background"] options:SDWebImageRefreshCached];
    adImgView.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:adImgView];
    
    self.interAppBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 96.0, [UIScreen mainScreen].bounds.size.height - 64.0, 64.0, 36.0)];
    self.interAppBtn.backgroundColor = [UIColor grayColor];
    self.interAppBtn.layer.masksToBounds = YES;
    self.interAppBtn.layer.cornerRadius = 2.56;
    [self.interAppBtn setTitle:@"3s 跳过" forState:UIControlStateNormal];
    [self.interAppBtn addTarget:self action:@selector(skipBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.interAppBtn];
    
    self.countTime = 3;
    self.interAppTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(interCountDown:) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.interAppTimer forMode:NSRunLoopCommonModes];
}

- (void)interCountDown:(NSTimer *)countDownTimer {
    if (self.countTime == 0) {
        [self skipBtnClicked:nil];
        return;
    }
    
    [self.interAppBtn setTitle:[NSString stringWithFormat:@"%ds 跳过", --self.countTime] forState:UIControlStateNormal];
}

- (void)skipBtnClicked:(UIButton *)btn {
    [self.interAppTimer invalidate];
    ([[User sharedUser] isLoggedIn]) ? [self presentViewController:[[BaseViewController alloc] init] animated:YES completion:^{
        [[User sharedUser] updateUserInfo];
    }] : [self presentViewController:[[LoginViewController alloc] init] animated:YES completion:nil];
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
