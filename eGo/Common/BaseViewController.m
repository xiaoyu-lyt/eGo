//
//  BaseViewController.m
//  eGo
//
//  Created by 萧宇 on 7/26/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "BaseViewController.h"
#import "CampusTrafficViewController.h"
#import "CampusBikeViewController.h"
#import "ChatCenterViewController.h"
#import "SettingsViewController.h"

#import "User.h"

@interface BaseViewController ()

@property (nonatomic, strong) UITabBarController *tabBarController;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[User sharedUser] updateUserInfo];
    
    // 初始化TabBar中的各个ViewController
    CampusTrafficViewController *campusTrafficVC = [[CampusTrafficViewController alloc] init];
    campusTrafficVC.title = @"校园交通";
    campusTrafficVC.tabBarItem.image = [UIImage imageNamed:@"Bus"];
    CampusBikeViewController *campusBikeVC = [[CampusBikeViewController alloc] init];
    campusBikeVC.title = @"电动顺风车";
    campusBikeVC.tabBarItem.image = [UIImage imageNamed:@"Bike"];
    ChatCenterViewController *chatCenterVC = [[ChatCenterViewController alloc] init];
    chatCenterVC.title = @"下课聊";
    chatCenterVC.tabBarItem.image = [UIImage imageNamed:@"Chat"];
    SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
    settingsVC.title = @"设置";
    settingsVC.tabBarItem.image = [UIImage imageNamed:@"Settings"];
    
    // 初始化TabBar
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[[[UINavigationController alloc] initWithRootViewController:campusTrafficVC], [[UINavigationController alloc] initWithRootViewController:campusBikeVC], [[UINavigationController alloc] initWithRootViewController:chatCenterVC], [[UINavigationController alloc] initWithRootViewController:settingsVC]];
    [self.view addSubview:self.tabBarController.view];
    
    [self changeNavigationBarColor];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  修改状态栏字体颜色为白色
 *
 *  @return
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/**
 *  修改NavigationBar颜色
 *
 *  @return
 */
- (void)changeNavigationBarColor {
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:54/255.0 green:54/255.0 blue:58/255.0 alpha:1]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0.0, -64.0) forBarMetrics:UIBarMetricsDefault];
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
