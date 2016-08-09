//
//  CampusBikeViewController.m
//  eGo
//
//  Created by 萧宇 on 8/8/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "CampusBikeViewController.h"
#import "DLPageView.h"

#import "User.h"
#import "Util.h"
#import "AFNetworking.h"

@interface CampusBikeViewController ()<DLPageViewDelegate, DLPageViewDatasource, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *inputTV;
@property (strong, nonatomic) IBOutlet UITableView *historyTV;
@property (strong, nonatomic) IBOutlet UIButton *cleanBtn;

@property (nonatomic, strong) NSArray *bannerImgArray;
@property (nonatomic, strong) DLPageView *adBannerView;
@property (nonatomic, strong) NSArray<NSDictionary *> *historyArray;

@end

@implementation CampusBikeViewController {
    NSArray *_imgArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBarButton];
    
    self.bannerImgArray = @[@"Background", @"DefaultImage"];
    [self addAdBannerView];
    
    _imgArray = @[@"Origin", @"Destination"];
    self.historyArray = @[@{@"origin" : @"三区", @"destination" : @"数计院楼"}, @{@"origin" : @"三区", @"destination" : @"数计院楼"}, @{@"origin" : @"三区", @"destination" : @"数计院楼"}, @{@"origin" : @"三区", @"destination" : @"数计院楼"}, @{@"origin" : @"三区", @"destination" : @"数计院楼"}];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.inputTV.delegate = self;
    self.inputTV.dataSource = self;
    self.historyTV.delegate = self;
    self.historyTV.dataSource = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.inputTV.delegate = nil;
    self.inputTV.dataSource = nil;
    self.historyTV.delegate = nil;
    self.historyTV.dataSource = nil;
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
    [self.view addSubview:self.adBannerView];
}

- (IBAction)searchBtnClicked:(id)sender {
    NSLog(@"searching");
}

#pragma mark - DLPageViewDatasource
- (NSInteger)numberOfPagesInPageView:(DLPageView *)pageView {
    return self.bannerImgArray.count;
}

- (UIView *)pageView:(DLPageView *)pageView viewForPageAtIndexPath:(NSIndexPath *)indexPath {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.adBannerView.frame.size.width, self.adBannerView.frame.size.height)];
    imgView.image = [UIImage imageNamed:self.bannerImgArray[indexPath.row]];
    return imgView;
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (tableView == self.inputTV) ? 2 : self.historyArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.inputTV) {
        static NSString *CellIdentifier = @"InputTCCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.imageView.image = [UIImage imageNamed:_imgArray[indexPath.row]];
        cell.textLabel.text = (indexPath.row == 0) ? @"我的位置" : @"";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (tableView == self.historyTV) {
        static NSString *CellIdentifier = @"HistoryTVCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.imageView.image = [Util setImage:[UIImage imageNamed:@"History"] withWidth:12.0 andHeight:12.0];
        cell.textLabel.text = [NSString stringWithFormat:@"%@→%@", self.historyArray[indexPath.row][@"origin"], self.historyArray[indexPath.row][@"destination"]];
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
