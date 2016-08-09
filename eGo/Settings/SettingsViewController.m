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
#import "HistoryViewController.h"
#import "MessageCenterViewController.h"
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
@property (strong, nonatomic) IBOutlet UITableView *settingsTV;

@property (nonatomic, strong) NSArray<NSArray *> *operations;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBarButton];
    
    self.operations = @[@[@"个人信息", @"好友列表", @"出行记录", @"消息中心"], @[@"清空缓存", @"意见反馈", @"关于eGo"], @[@"注销"]];
    [self.userPhotoImg tapToShow];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.userPhotoImg.layer.masksToBounds = YES;
    self.userPhotoImg.layer.cornerRadius = self.userPhotoImg.frame.size.width / 2;
    self.userPhotoImg.image = [Util getPhotoImageWithPhotoName:[User sharedUser].photoName];
    self.genderImg.image = ([[User sharedUser].gender integerValue] == 1) ? [UIImage imageNamed:@"Male"] : [UIImage imageNamed:@"Female"];
    self.nameLbl.text = ([User sharedUser].name.length == 0) ? @"某同学" : [User sharedUser].name;
    self.signatureLbl.text = ([User sharedUser].signature.length > 15) ? [NSString stringWithFormat:@"%@...", [[User sharedUser].signature substringToIndex:15]] : [User sharedUser].signature;
    
    self.settingsTV.delegate = self;
    self.settingsTV.dataSource = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.settingsTV.delegate = nil;
    self.settingsTV.dataSource = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cleanCache {
    [self alertConfirmMessage:@"是否清楚本地缓存" withTitle1:@"取消" style1:UIAlertActionStyleCancel handler1:^{
        
    } andTitle2:@"清除" style2:UIAlertActionStyleDefault handler2:^{
        
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SettingsTVCell";
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
                    cell.imageView.image = [UIImage imageNamed:@"History"];
                    break;
                case 3:
                    cell.imageView.image = [UIImage imageNamed:@"Message"];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.imageView.image = [UIImage imageNamed:@"Delete"];
                    cell.detailTextLabel.text = @"2.03M";
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
                    [self showViewController:[[HistoryViewController alloc] init] sender:nil];
                    break;
                case 3:
                    [self showViewController:[[MessageCenterViewController alloc] init] sender:nil];
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20.0;
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
