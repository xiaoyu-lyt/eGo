//
//  MyBikeViewController.m
//  eGo
//
//  Created by 萧宇 on 9/1/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "MyBikeViewController.h"
#import "NewBikeViewController.h"

#import "Util.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface MyBikeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *bikeInfoTblView;
@property (nonatomic, strong) UIImageView *bikeImgView;

@property (nonatomic, strong) NSDictionary *bikeInfo;

@end

@implementation MyBikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [Util setNavigationBarTransparentWithViewController:self];
    [self getBikeInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [Util resetNavigationBarWithViewController:self andTitleColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getBikeInfo {
//    _bikeInfo = @{@"brand" : @"心艺", @"licence" : @"晋安A12345", @"acceptComment" : @1, @"favorableRate" : @"98.1", @"comments" : @""};
    _bikeInfo = nil;
    
    if (_bikeInfo == nil) {
        [self.view makeToast:@"暂无车辆信息"];
        [Util resetNavigationBarWithViewController:self andTitleColor:[UIColor whiteColor]];
        self.title = @"电动车信息";
        UIBarButtonItem *addNewBikeBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(addNewBikeBarBtnClicked:)];
        self.navigationItem.rightBarButtonItem = addNewBikeBarBtn;
    } else {
        UIBarButtonItem *editBikeBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editBikeInfoBarBtnClicked:)];
        self.navigationItem.rightBarButtonItem = editBikeBarBtn;
        
        self.bikeInfoTblView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 48.0)];
        self.bikeInfoTblView.delegate = self;
        self.bikeInfoTblView.dataSource = self;
        [self setTableHeaderView];
        [self.view addSubview:_bikeInfoTblView];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)setTableHeaderView {
    _bikeInfoTblView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, WIDTH, WIDTH / 2)];
    _bikeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, WIDTH, WIDTH / 2)];
    _bikeImgView.image = [UIImage imageNamed:@"DefaultImage"];
    _bikeImgView.userInteractionEnabled = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bikeInfoImgViewTapped:)];
    [_bikeImgView addGestureRecognizer:tap];
    [_bikeInfoTblView.tableHeaderView insertSubview:_bikeImgView atIndex:0];
}

- (void)bikeInfoImgViewTapped:(UITapGestureRecognizer *)tap {
    [self alertSheetMessage:nil withTitles:@[@"拍摄新照片", @"从相册选择"] andHandlers:@[^{
        NSLog(@"Take new photo");
    }, ^{
        NSLog(@"Choose photo");
    }]];
}

- (void)addNewBikeBarBtnClicked:(UIBarButtonItem *)Btn {
    [self showViewController:[[NewBikeViewController alloc] init] sender:nil];
}

- (void)editBikeInfoBarBtnClicked:(UIBarButtonItem *)btn {
    btn.title = @"保存";
    btn.action = @selector(saveBikeInfoBarBtnClicked:);
    self.bikeImgView.userInteractionEnabled = YES;
}

- (void)saveBikeInfoBarBtnClicked:(UIBarButtonItem *)btn {
    btn.title = @"编辑";
    btn.action = @selector(editBikeInfoBarBtnClicked:);
    self.bikeImgView.userInteractionEnabled = NO;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0 || _bikeImgView.userInteractionEnabled) {
        return;
    } else if (scrollView.contentOffset.y < -100.0) {
        [scrollView setContentOffset:CGPointMake(0.0, -100.0)];
    } else {
        CGRect frame = CGRectMake(scrollView.contentOffset.y, scrollView.contentOffset.y, WIDTH - 2 * scrollView.contentOffset.y, WIDTH / 2 - scrollView.contentOffset.y);
        self.bikeImgView.frame = frame;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_bikeImgView.isUserInteractionEnabled) {
        NSLog(@"Edited");
    } else if (indexPath.row == _bikeInfo.count - 1) {
        NSLog(@"Comments row clicked");
    }
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([_bikeInfo[@"acceptComment"] isEqual:@1]) ? 5 : 3;
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
            cell.detailTextLabel.text = _bikeInfo[@"brand"];
            break;
        case 1:
            cell.textLabel.text = @"车牌号";
            cell.detailTextLabel.text = _bikeInfo[@"licence"];
            break;
        case 2:
            cell.textLabel.text = @"开启评论";
            cell.detailTextLabel.text = ([_bikeInfo[@"acceptComment"] isEqual:@1]) ? @"是" : @"否";
            break;
        case 3:
            cell.textLabel.text = @"好评率";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%%", _bikeInfo[@"favorableRate"]];
            break;
        case 4:
            cell.textLabel.text = @"评论列表";
            cell.detailTextLabel.text = _bikeInfo[@"comments"];
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
