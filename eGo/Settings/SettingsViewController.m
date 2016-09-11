//
//  SettingsViewController.m
//  eGo
//
//  Created by 萧宇 on 7/27/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "SettingsViewController.h"
#import "LoginViewController.h"
#import "PersonalViewController.h"
#import "FriendsViewController.h"
#import "MessageCenterViewController.h"
#import "MyBikeViewController.h"
#import "HistoryViewController.h"
#import "FeedbackViewController.h"
#import "AboutUsViewController.h"

#import "User.h"
#import "Util.h"
#import "AFNetworking.h"

@interface SettingsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIImageView *userPhotoImg;
@property (strong, nonatomic) IBOutlet UIImageView *genderImg;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *signatureLbl;
@property (strong, nonatomic) IBOutlet UITableView *settingsTblView;

@property (nonatomic, strong) NSArray<NSArray *> *operations;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBarButton];
    
    self.operations = @[@[@"个人信息", @"好友列表", @"消息中心", @"车辆管理", @"出行记录"], @[@"清空缓存", @"意见反馈", @"关于eGo"], @[@"注销"]];
    [self.userPhotoImg tapToShow];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.userPhotoImg.layer.masksToBounds = YES;
    self.userPhotoImg.layer.cornerRadius = self.userPhotoImg.frame.size.width / 2;
    [self.userPhotoImg sd_setImageWithURL:[NSURL URLWithString:[kImageUrl stringByAppendingString:[NSString stringWithFormat:@"User/%@.png", [User sharedUser].avatar]]] placeholderImage:[UIImage imageNamed:@"loading.gif"]];
    self.genderImg.image = ([[User sharedUser].gender integerValue] == 0) ? [UIImage imageNamed:@"Male"] : [UIImage imageNamed:@"Female"];
    self.nameLbl.text = ([User sharedUser].name.length == 0) ? @"某同学" : [User sharedUser].name;
    self.signatureLbl.text = ([User sharedUser].signature.length > 15) ? [NSString stringWithFormat:@"%@...", [[User sharedUser].signature substringToIndex:15]] : [User sharedUser].signature;
    
    self.settingsTblView.delegate = self;
    self.settingsTblView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cleanCache {
    [self alertConfirmMessage:@"是否清除本地缓存" withTitle1:@"取消" style1:UIAlertActionStyleCancel handler1:^{
        NSLog(@"Cancel");
    } andTitle2:@"清除" style2:UIAlertActionStyleDefault handler2:^{
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        [self.settingsTblView reloadData];
    }];
}

- (void)logout {
    [self alertConfirmMessage:@"确认注销当前账号" withTitle1:@"取消" style1:UIAlertActionStyleCancel handler1:^{
    } andTitle2:@"注销" style2:UIAlertActionStyleDestructive handler2:^{
        [self presentViewController:[[LoginViewController alloc] init] animated:YES completion:^{
            [[User sharedUser].user removeObjectForKey:@"token"];
        }];
    }];
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.operations.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.operations[section].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 12.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"settingsTblViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = self.operations[indexPath.section][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.imageView.image = [UIImage imageNamed:@"User"];
                    break;
                case 1:
                    cell.imageView.image = [UIImage imageNamed:@"Contacts"];
                    break;
                case 2:
                    cell.imageView.image = [UIImage imageNamed:@"Message"];
                    break;
                case 3:
                    cell.imageView.image = [UIImage imageNamed:@"BikeManage"];
                    break;
                case 4:
                    cell.imageView.image = [UIImage imageNamed:@"History"];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.imageView.image = [UIImage imageNamed:@"Delete"];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM", (float)[[SDImageCache sharedImageCache] getSize] / 1000000];
                    break;
                case 1:
                    cell.imageView.image = [UIImage imageNamed:@"Feedback"];
                    break;
                case 2:
                    cell.imageView.image = [UIImage imageNamed:@"About"];
                    break;
                default:
                    break;
            }
            break;
        case 2:
            cell.textLabel.textColor = [UIColor redColor];
            cell.imageView.image = [UIImage imageNamed:@"Exit"];
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [self showViewController:[[PersonalViewController alloc] init] sender:nil];
                    break;
                case 1:
                    [self showViewController:[[FriendsViewController alloc] init] sender:nil];
                    break;
                case 2:
                    [self showViewController:[[MessageCenterViewController alloc] init] sender:nil];
                    break;
                case 3:
                    [self showViewController:[[MyBikeViewController alloc] init] sender:nil];
                    break;
                case 4:
                    [self showViewController:[[HistoryViewController alloc] init] sender:nil];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    [self cleanCache];
                    break;
                case 1:
                    [self showViewController:[[FeedbackViewController alloc] init] sender:nil];
                    break;
                case 2:
                    [self showViewController:[[AboutUsViewController alloc] init] sender:nil];
                    break;
                default:
                    break;
            }
            break;
        case 2:
            [self logout];
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 防止滑动过程中其他cell也变成红色，因为目前没找到其他解决办法，就先这样吧
    cell.detailTextLabel.text = @"";
    cell.textLabel.textColor = [UIColor blackColor];
}

@end
