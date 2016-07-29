//
//  SettingsViewController.m
//  eGo
//
//  Created by 萧宇 on 7/27/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "SettingsViewController.h"
#import "LoginViewController.h"

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
    self.userPhotoImg.image = [Util getPhotoImageWithPhotoName:[[User sharedUser].user objectForKey:@"photoName"]];
    self.genderImg.image = ([[[User sharedUser].user objectForKey:@"gender"] integerValue] == 1) ? [UIImage imageNamed:@"Male"] : [UIImage imageNamed:@"Female"];
    self.nameLbl.text = [[User sharedUser].user objectForKey:@"name"];
    NSString *signature = [[User sharedUser].user objectForKey:@"signature"];
    self.signatureLbl.text = (signature.length > 15) ? [NSString stringWithFormat:@"%@...", [signature substringToIndex:15]] : signature;
    
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
        NSLog(@"cancel");
    } andTitle2:@"清除" style2:UIAlertActionStyleDefault handler2:^{
        NSLog(@"clean");
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
                    NSLog(@"个人信息");
                    break;
                case 1:
                    NSLog(@"好友列表");
                    break;
                case 2:
                    NSLog(@"出行记录");
                    break;
                case 3:
                    NSLog(@"消息中心");
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
                    NSLog(@"意见反馈");
                    break;
                case 2:
                    NSLog(@"关于eGo");
                    break;
                default:
                    break;
            }
            break;
        case 2:
            NSLog(@"注销");
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
