//
//  HistoryViewController.m
//  eGo
//
//  Created by 萧宇 on 7/29/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *historyTblView;

@property (nonatomic, strong) NSArray<NSDictionary *> *historyList;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"出行记录";
    self.historyList = @[@{@"from" : @"东三", @"to" : @"数计院楼", @"time" : @"12:00"}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.historyTblView.delegate = self;
    self.historyTblView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _historyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"HistoryTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@→%@", _historyList[indexPath.row][@"from"], _historyList[indexPath.row][@"to"]];
    cell.detailTextLabel.text = _historyList[indexPath.row][@"time"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

@end
