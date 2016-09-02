//
//  BikeViewController.m
//  eGo
//
//  Created by 萧宇 on 8/29/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "BikeViewController.h"

#import "Util.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface BikeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *bikeInfoTblView;

@property (nonatomic, strong) NSDictionary *bikeInfoList;

@end

@implementation BikeViewController {
    UIImageView *_bikeInfoImgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setTableHeaderView];
    
    self.bikeInfoList = @{@"brand" : @"心艺", @"licence" : @"晋安A12345", @"acceptComment" : @NO, @"applauseRate" : @"83%", @"comments" : @"点击查看详情"};
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.bikeInfoTblView.delegate = self;
    self.bikeInfoTblView.dataSource = self;
    
    // 将NavigationBar设置为透明
    [Util setNavigationBarTransparentWithViewController:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.bikeInfoTblView.delegate = nil;
    self.bikeInfoTblView.dataSource = nil;
    
    // 将NavigationBar改回默认状态
    [Util resetNavigationBarWithViewController:self andTitleColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTableHeaderView {
    _bikeInfoTblView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, WIDTH, WIDTH / 2)];
    _bikeInfoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, WIDTH, WIDTH / 2)];
    _bikeInfoImgView.image = [UIImage imageNamed:@"DefaultImage"];
    _bikeInfoImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bikeInfoImgViewTapped:)];
    [_bikeInfoImgView addGestureRecognizer:tap];
    [_bikeInfoTblView.tableHeaderView insertSubview:_bikeInfoImgView atIndex:0];
}

- (void)bikeInfoImgViewTapped:(UITapGestureRecognizer *)tap {
    [self alertSheetMessage:nil withTitles:@[@"拍摄新照片", @"从相册选择"] andHandlers:@[^{
        NSLog(@"Take new photo");
    }, ^{
        NSLog(@"Choose photo");
    }]];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0) {
        return;
    } else if (scrollView.contentOffset.y < -100.0) {
        [scrollView setContentOffset:CGPointMake(0.0, -100.0)];
    } else {
        CGRect frame = CGRectMake(scrollView.contentOffset.y, scrollView.contentOffset.y, WIDTH - 2 * scrollView.contentOffset.y, WIDTH / 2 - scrollView.contentOffset.y);
        _bikeInfoImgView.frame = frame;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0;
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([_bikeInfoList[@"acceptComment"] isEqual:@YES]) ? _bikeInfoList.count : 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"BikeInfoTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"品牌";
            cell.detailTextLabel.text = _bikeInfoList[@"brand"];
            break;
        case 1:
            cell.textLabel.text = @"车牌号";
            cell.detailTextLabel.text = _bikeInfoList[@"licence"];
            break;
        case 2:
            cell.textLabel.text = @"开启评论";
            cell.detailTextLabel.text = ([_bikeInfoList[@"acceptComment"] isEqual:@YES]) ? @"是" : @"否";
            break;
        case 3:
            cell.textLabel.text = @"好评率";
            cell.detailTextLabel.text = _bikeInfoList[@"applauseRate"];
            break;
        case 4:
            cell.textLabel.text = @"评论列表";
            cell.detailTextLabel.text = _bikeInfoList[@"comments"];
            break;
        default:
            break;
    }
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
