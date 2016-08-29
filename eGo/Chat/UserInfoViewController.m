//
//  UserInfoViewController.m
//  eGo
//
//  Created by 萧宇 on 8/29/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoTableViewCell.h"

@interface UserInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *userInfoTblView;
@property (strong, nonatomic) IBOutlet UIButton *optionBtn;

@property (nonatomic, strong) NSDictionary *userInfo;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"详细信息";
    
    self.userInfo = @{@"avatar" : @"Background", @"alias" : @"DanielLam", @"nickname" : @"Daniel", @"signature" : @"Hello ObjC", @"school" : @"福州大学", @"college" : @"数计学院", @"major" : @"软件工程"};
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.userInfoTblView.delegate = self;
    self.userInfoTblView.dataSource = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.userInfoTblView.delegate = nil;
    self.userInfoTblView.dataSource = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (self == 0) ? 80.0 : 48.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 1 : 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            static NSString *CellIdentifier1 = @"UserInfoTableViewCell";
            UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier1 owner:nil options:nil] lastObject];
            }
            cell.avatarImgView.image = [UIImage imageNamed:_userInfo[@"avatar"]];
            cell.aliasLbl.text = _userInfo[@"alias"];
            cell.nicknameLbl.text = _userInfo[@"nickname"];
            cell.signatureLbl.text = _userInfo[@"signature"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:{
            static NSString *CellIdentifier2 = @"StudentInfoTblViewCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier2];
            }
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:@"学校：%@", _userInfo[@"school"]];
                    break;
                case 1:
                    cell.textLabel.text = [NSString stringWithFormat:@"学院：%@", _userInfo[@"college"]];
                    break;
                case 2:
                    cell.textLabel.text = [NSString stringWithFormat:@"专业：%@", _userInfo[@"major"]];
                    break;
                default:
                    break;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
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
