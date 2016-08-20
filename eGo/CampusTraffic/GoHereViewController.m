//
//  GoHereViewController.m
//  eGo
//
//  Created by 萧宇 on 8/19/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "GoHereViewController.h"
#import "SelectSiteViewController.h"
#import "ShowRouteViewController.h"

#import "Util.h"
#import "AMapManager.h"

@interface GoHereViewController ()<SelectSiteDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *inputTblView;
@property (strong, nonatomic) IBOutlet UITableView *historyTblView;
@property (strong, nonatomic) IBOutlet UIButton *cleanBtn;

@property (nonatomic, strong) NSArray<NSDictionary *> *historyList;
@property (nonatomic, strong) NSDictionary *origin;

@end

@implementation GoHereViewController {
    NSArray *_imgArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"路线查询";
    self.origin = @{@"name" : @"我的位置", @"latitude" : @([[AMapManager manager] userLocation].location.coordinate.latitude), @"longitude" : @([[AMapManager manager] userLocation].location.coordinate.longitude)};
    
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

- (IBAction)searchBtnClicked:(id)sender {
    if (((NSString *)_origin[@"name"]).length == 0) {
        [self.view makeToast:@"起点不能为空"];
        return;
    } else if (((NSString *)_destination[@"name"]).length == 0) {
        [self.view makeToast:@"终点不能为空"];
        return;
    }
    
    ShowRouteViewController *showRouteVC = [[ShowRouteViewController alloc] init];
    showRouteVC.origin = _origin;
    showRouteVC.destination = _destination;
    [self showViewController:showRouteVC sender:nil];
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
            self.destination = site;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.inputTblView cellForRowAtIndexPath:indexPath].textLabel.text = site[@"name"];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0;
}

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

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (tableView == _inputTblView) ? 2 : _historyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _inputTblView) {
        static NSString *CellIdentifier = @"InputTCCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.imageView.image = [UIImage imageNamed:_imgArray[indexPath.row]];
        cell.textLabel.text = (indexPath.row == 0) ? _origin[@"name"] : ((indexPath.row == 1) ? _destination[@"name"] : @"");
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (tableView == _historyTblView) {
        static NSString *CellIdentifier = @"HistoryTVCell";
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
