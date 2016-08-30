//
//  NoticeViewController.m
//  eGo
//
//  Created by 萧宇 on 8/29/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeDetailViewController.h"

#import "Util.h"

@interface NoticeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *noticeListTblView;

@property (nonatomic, strong) NSArray<NSArray<NSDictionary *> *> *noticeList;

@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.noticeList = @[@[@{@"image" : @"DefaultImage", @"title" : @"Daniel请求加你为好友", @"time" : @"12:00"}, @{@"image" : @"DefaultImage", @"title" : @"Daniel请求加你为好友", @"time" : @"12:00"}, @{@"image" : @"DefaultImage", @"title" : @"Daniel请求加你为好友", @"time" : @"12:00"}, @{@"image" : @"DefaultImage", @"title" : @"Daniel请求加你为好友", @"time" : @"12:00"}], @[@{@"image" : @"DefaultImage", @"title" : @"系统通知", @"time" : @"12:34", @"url" : @"http://219.229.132.21/FZU-VentureService/Home/venture_web/"}, @{@"image" : @"DefaultImage", @"title" : @"系统通知", @"time" : @"12:34", @"url" : @"http://219.229.132.21/FZU-VentureService/Home/venture_web/"}, @{@"image" : @"DefaultImage", @"title" : @"系统通知", @"time" : @"12:34", @"url" : @"http://219.229.132.21/FZU-VentureService/Home/venture_web/"}, @{@"image" : @"DefaultImage", @"title" : @"系统通知", @"time" : @"12:34", @"url" : @"http://219.229.132.21/FZU-VentureService/Home/venture_web/"}, @{@"image" : @"Account", @"title" : @"系统通知系统通知系统通知系统通知系统通知系统通知系统通知系统通知", @"time" : @"12:34", @"url" : @"http://219.229.132.21/FZU-VentureService/Home/venture_web/"}]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.noticeListTblView.delegate = self;
    self.noticeListTblView.dataSource = self;
    
    [self.noticeListTblView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.noticeListTblView.delegate = nil;
    self.noticeListTblView.dataSource = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (section == [_noticeListTblView numberOfSections] - 1) ? 1 : 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        [self alertConfirmMessage:_noticeList[indexPath.section][indexPath.row][@"title"] withTitle1:@"拒接" style1:UIAlertActionStyleCancel handler1:^{
            NSLog(@"Cancel");
        } andTitle2:@"添加" style2:UIAlertActionStyleDefault handler2:^{
            NSLog(@"Add");
        }];
    } else {
        NoticeDetailViewController *noticeDetailVC = [[NoticeDetailViewController alloc] init];
        noticeDetailVC.title = _noticeList[indexPath.section][indexPath.row][@"title"];
        noticeDetailVC.url = _noticeList[indexPath.section][indexPath.row][@"url"];
        [self showViewController:noticeDetailVC sender:nil];
    }
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _noticeList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _noticeList[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NoticeTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.imageView.image = [Util setImage:[UIImage imageNamed:_noticeList[indexPath.section][indexPath.row][@"image"]] withWidth:44.0 andHeight:44.0];
    cell.textLabel.text = _noticeList[indexPath.section][indexPath.row][@"title"];
    cell.detailTextLabel.text = _noticeList[indexPath.section][indexPath.row][@"time"];
    cell.accessoryType = (indexPath.section != 0) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    return cell;
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
