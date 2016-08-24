//
//  TabOneViewController.m
//  eGo
//
//  Created by 萧宇 on 8/18/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "TabOneViewController.h"

#import "Util.h"

@interface TabOneViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *availableBikeTblView;

@property (nonatomic, strong) NSArray<NSDictionary *> *availableBikeList;

@end

@implementation TabOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.availableBikeList = @[@{@"name" : @"三区→西三", @"time" : @"7:45"}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.availableBikeTblView.delegate = self;
    self.availableBikeTblView.dataSource = self;
    
    [self.availableBikeTblView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.availableBikeTblView.delegate = nil;
    self.availableBikeTblView.dataSource = nil;
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
    
    NSArray *titles = @[@"联系车主", @"申请"];
    NSArray *handlers = @[^{
        NSLog(@"联系车主");
    }, ^{
        NSLog(@"申请");
    }];
    [self alertSheetMessage:@"" withTitles:titles andHandlers:handlers];
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.availableBikeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AvailableBikeTVCell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = self.availableBikeList[indexPath.row][@"name"];
    cell.detailTextLabel.text = self.availableBikeList[indexPath.row][@"time"];
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
