//
//  CampusBikeViewController.m
//  eGo
//
//  Created by 萧宇 on 8/8/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "CampusBikeViewController.h"
#import "SelectSiteViewController.h"
#import "AvailableBikeViewController.h"

#import "DLPageView.h"

#import "User.h"
#import "Util.h"
#import "AFNetworking.h"

@interface CampusBikeViewController ()<DLPageViewDelegate, DLPageViewDatasource, SelectSiteDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *inputTblView;
@property (strong, nonatomic) IBOutlet UITableView *historyTblView;
@property (strong, nonatomic) IBOutlet UIButton *cleanBtn;

@property (nonatomic, strong) NSArray *bannerImgList;
@property (nonatomic, strong) DLPageView *adBannerView;
@property (nonatomic, strong) NSDictionary *origin;
@property (nonatomic, strong) NSDictionary *destination;
@property (nonatomic, strong) NSArray<NSDictionary *> *historyList;

@end

@implementation CampusBikeViewController {
    NSArray *_imgArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBarButton];
    
    self.bannerImgList = @[@"Background", @"DefaultImage"];
    [self addAdBannerView];
    
    _imgArray = @[@"Origin", @"Destination"];
    self.historyList = @[@{@"origin" : @"三区", @"destination" : @"数计院楼"}, @{@"origin" : @"三区", @"destination" : @"数计院楼"}, @{@"origin" : @"三区", @"destination" : @"数计院楼"}, @{@"origin" : @"三区", @"destination" : @"数计院楼"}, @{@"origin" : @"三区", @"destination" : @"数计院楼"}, @{@"origin" : @"三区", @"destination" : @"数计院楼"}, @{@"origin" : @"三区", @"destination" : @"数计院楼"}, @{@"origin" : @"三区", @"destination" : @"数计院楼"}, @{@"origin" : @"三区", @"destination" : @"数计院楼"}];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.inputTblView.delegate = self;
    self.inputTblView.dataSource = self;
    self.historyTblView.delegate = self;
    self.historyTblView.dataSource = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    self.inputTblView.delegate = nil;
//    self.inputTblView.dataSource = nil;
    self.historyTblView.delegate = nil;
    self.historyTblView.dataSource = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addAdBannerView {
    self.adBannerView = [[DLPageView alloc] initWithFrame:CGRectMake(0.0, 64.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 2 / 5)];
    self.adBannerView.delegate = self;
    self.adBannerView.datasource = self;
    // 消除因NavigationController引起的顶部空白
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_adBannerView];
}

- (IBAction)searchBtnClicked:(id)sender {
    if ([_inputTblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].textLabel.text.length == 0) {
        [self.view makeToast:@"起点不能为空"];
        return;
    } else if ([_inputTblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].textLabel.text.length == 0) {
        [self.view makeToast:@"终点不能为空"];
        return;
    }
    AvailableBikeViewController *availableBikeVC = [[AvailableBikeViewController alloc] init];
    availableBikeVC.origin = [_inputTblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].textLabel.text;
    availableBikeVC.destination = [_inputTblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].textLabel.text;
    [self showViewController:availableBikeVC sender:nil];
//    [self presentViewController:availableBikeVC animated:YES completion:nil];
}

#pragma mark - DLPageViewDatasource
- (NSInteger)numberOfPagesInPageView:(DLPageView *)pageView {
    return _bannerImgList.count;
}

- (UIView *)pageView:(DLPageView *)pageView viewForPageAtIndexPath:(NSIndexPath *)indexPath {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, _adBannerView.frame.size.width, _adBannerView.frame.size.height)];
    imgView.image = [UIImage imageNamed:_bannerImgList[indexPath.row]];
    return imgView;
}

#pragma mark - SelectSiteDelegate

- (void)site:(NSDictionary *)site selectedForType:(SiteType)type {
    switch (type) {
        case SiteTypeOrigin:{
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
            self.origin = site;
            [self.inputTblView cellForRowAtIndexPath:indexPath].textLabel.text = site[@"name"];
        }
            break;
        case SiteTypeDestination:{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            self.destination = site;
            [self.inputTblView cellForRowAtIndexPath:indexPath].textLabel.text = site[@"name"];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (tableView == _inputTblView) ? 2 : _historyList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _inputTblView) {
        static NSString *CellIdentifier = @"inputTblViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.imageView.image = [UIImage imageNamed:_imgArray[indexPath.row]];
        cell.textLabel.text = (indexPath.row == 0) ? @"我的位置" : @"";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (tableView == _historyTblView) {
        static NSString *CellIdentifier = @"historyTblViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.imageView.image = [Util setImage:[UIImage imageNamed:@"History"] withWidth:12.0 andHeight:12.0];
        cell.textLabel.text = [NSString stringWithFormat:@"%@→%@", _historyList[indexPath.row][@"origin"], _historyList[indexPath.row][@"destination"]];
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == _inputTblView) {
        SelectSiteViewController *selectSiteVC = [[SelectSiteViewController alloc] init];
        selectSiteVC.site = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        switch (indexPath.row) {
            case 0:
                selectSiteVC.siteType = SiteTypeOrigin;
                break;
            case 1:
                selectSiteVC.siteType = SiteTypeDestination;
            default:
                break;
        }
        selectSiteVC.delegate = self;
        [self showViewController:selectSiteVC sender:nil];
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
