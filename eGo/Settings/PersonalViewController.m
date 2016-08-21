//
//  PersonalViewController.m
//  eGo
//
//  Created by 萧宇 on 7/29/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "PersonalViewController.h"
#import "ModifyUserInfoViewController.h"

#import "User.h"
#import "Util.h"

@interface PersonalViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *userInfoTV;

@property (nonatomic) BOOL isChanged;
@property (nonatomic, strong) NSArray<NSArray *> *userInfoArray;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) UIVisualEffectView *blurEffectView;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"个人信息";
    
    self.isChanged = NO;
    self.userInfoArray = @[@[@"头像"], @[@"昵称", @"手机", @"邮箱", @"密码"], @[@"学号", @"姓名", @"性别", @"学校", @"学院", @"专业"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.userInfoTV.delegate = self;
    self.userInfoTV.dataSource = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.userInfoTV.delegate = nil;
    self.userInfoTV.dataSource = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImageView *)getUserPhotoImgView {
    static UIImageView *userPhotoImgView = nil;
    if (userPhotoImgView == nil) {
        userPhotoImgView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 96.0, 12, 56.0, 56.0)];
        userPhotoImgView.image = [UIImage imageNamed:@"DefaultImage"];
        userPhotoImgView.layer.masksToBounds = YES;
        userPhotoImgView.layer.cornerRadius = userPhotoImgView.frame.size.width / 2;
    }
    return userPhotoImgView;
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.userInfoArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userInfoArray[section].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80.0;
    }
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0;
    }
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UserInfoTVCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = self.userInfoArray[indexPath.section][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.section) {
        case 0:{
            [cell.contentView addSubview:[self getUserPhotoImgView]];
        }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.detailTextLabel.text = [User sharedUser].nickname;
                    break;
                case 1:
                    cell.detailTextLabel.text = [User sharedUser].tel;
                    break;
                case 2:
                    cell.detailTextLabel.text = [User sharedUser].email;
                    break;
                case 3:
                    cell.detailTextLabel.text = @"****";
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    cell.detailTextLabel.text = [User sharedUser].stuId;
                    break;
                case 1:
                    cell.detailTextLabel.text = [User sharedUser].name;
                    break;
                case 2:
                    cell.detailTextLabel.text = ([[[User sharedUser].user objectForKey:@"gender"] integerValue] == 0) ? @"男" : @"女";
                    break;
                case 3:
                    cell.detailTextLabel.text = [User sharedUser].school;
                    break;
                case 4:
                    cell.detailTextLabel.text = [User sharedUser].college;
                    break;
                case 5:
                    cell.detailTextLabel.text = [User sharedUser].major;
                    break;
                default:
                    break;
            }
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            [self alertSheetMessage:nil withTitles:@[@"拍摄新照片", @"从相册选择"] andHandlers:@[^{
                NSLog(@"Take new photo");
            }, ^{
                NSLog(@"Choose photo");
            }]];
            break;
        case 1:{
            ModifyUserInfoViewController *modifyUerInfoVC = [[ModifyUserInfoViewController alloc] init];
            switch (indexPath.row) {
                case 0:
                    modifyUerInfoVC.userInfoType = UserInfoTypeNickname;
                    modifyUerInfoVC.userInfo = [User sharedUser].nickname;
                    break;
                case 1:
                    modifyUerInfoVC.userInfoType = UserInfoTypeTel;
                    modifyUerInfoVC.userInfo = [User sharedUser].tel;
                    break;
                case 2:
                    modifyUerInfoVC.userInfoType = UserInfoTypeEmail;
                    modifyUerInfoVC.userInfo = [User sharedUser].email;
                    break;
                case 3:
                    modifyUerInfoVC.userInfoType = UserInfoTypePassword;
                    break;
                default:
                    break;
            }
            [self showViewController:modifyUerInfoVC sender:nil];
        }
            break;
        case 2:{
            if ([[User sharedUser].user objectForKey:@"stuId"] != nil) {
                return;
            }
            [self alertConfirmMessage:@"是否进行学生认证" withTitle1:@"取消" style1:UIAlertActionStyleCancel handler1:^{
                NSLog(@"");
            } andTitle2:@"认证" style2:UIAlertActionStyleDefault handler2:^{
                [self showViewController:[[PersonalViewController alloc] init] sender:nil];
            }];
        }
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 防止滑动过程中其他cell也变成红色，因为目前没找到其他解决办法，就先这样吧
    cell.detailTextLabel.text = @"";
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
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
