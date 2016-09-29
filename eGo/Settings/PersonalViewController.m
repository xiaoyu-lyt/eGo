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
#import "AFNetworking.h"

@interface PersonalViewController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *userInfoTblView;

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
    
    self.userInfoTblView.delegate = self;
    self.userInfoTblView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_userInfoTblView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImageView *)getUserPhotoImgView {
    static UIImageView *userPhotoImgView = nil;
    if (userPhotoImgView == nil) {
        userPhotoImgView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 96.0, 12, 56.0, 56.0)];
        [userPhotoImgView sd_setImageWithURL:[NSURL URLWithString:[kImageUrl stringByAppendingString:[NSString stringWithFormat:@"User/%@.png", [User sharedUser].avatar]]] placeholderImage:[UIImage imageNamed:@"loading.gif"]];
        userPhotoImgView.layer.masksToBounds = YES;
        userPhotoImgView.layer.cornerRadius = userPhotoImgView.frame.size.width / 2;
    }
    return userPhotoImgView;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSData *imageData = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 0.9);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager PUT:[kApiUrl stringByAppendingPathComponent:@"user-avatar"] parameters:@{@"token" : [User sharedUser].token, @"jwchId" : [User sharedUser].stuNum, @"image" : imageData, @"filename" : [NSString stringWithFormat:@"%@_%d", [User sharedUser].stuNum, (int)[[NSDate date] timeIntervalSince1970]]} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        [[User sharedUser] updateUserInfo];
        [[_userInfoTblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].contentView.subviews[0] sd_setImageWithURL:[NSURL URLWithString:[kImageUrl stringByAppendingString:[NSString stringWithFormat:@"User/%@.png", [NSString stringWithFormat:@"%@_%d", [User sharedUser].stuNum, (int)[[NSDate date] timeIntervalSince1970]]]]] placeholderImage:[UIImage imageNamed:@"loading.gif"]];
        [self.view makeToast:@"设置成功"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Faild:%@", [error localizedDescription]);
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
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
    static NSString *CellIdentifier = @"userInfoTblViewCell";
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
                    cell.detailTextLabel.text = [User sharedUser].stuNum;
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
        case 0:{
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            
            [self alertSheetMessage:nil withTitles:@[@"拍摄新照片", @"从相册选择"] andHandlers:@[^{
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }, ^{
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }]];
        }
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
