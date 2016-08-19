//
//  SearchViewController.m
//  eGo
//
//  Created by 萧宇 on 8/15/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "SearchViewController.h"
#import "SiteInfoViewController.h"

@interface SearchViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *searchResultTV;

@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSArray<NSDictionary *> *searchResult;
@property (nonatomic, strong) NSArray<NSDictionary *> *sitesList;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initSearchBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.searchResultTV.delegate = self;
    self.searchResultTV.dataSource = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.searchResultTV.delegate = nil;
    self.searchResultTV.dataSource = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.sitesList = @[@{@"name" : @"福州大学", @"latitude" : @"26.059522", @"longitude" : @"119.194197"}, @{@"name" : @"福州大学图书馆", @"latitude" : @"26.054522", @"longitude" : @"119.190197"}, @{@"name" : @"行政北楼", @"latitude" : @"26.059522", @"longitude" : @"119.194197"}, @{@"name" : @"行政南楼", @"latitude" : @"26.059522", @"longitude" : @"119.194197"}, @{@"name" : @"数计学院", @"latitude" : @"26.059522", @"longitude" : @"119.194197"}, @{@"name" : @"风雨操场", @"latitude" : @"26.059522", @"longitude" : @"119.194197"}];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSearchBar {
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    [self.searchBar becomeFirstResponder];
    self.navigationItem.titleView = self.searchBar;
    self.coverView = [[UIView alloc] initWithFrame:self.view.frame];
    self.coverView.hidden = YES;
    [self.view insertSubview:self.coverView atIndex:99];
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    self.coverView.hidden = NO;
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    self.coverView.hidden = YES;
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *string = searchText;
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"%K CONTAINS %@", @"name", string];
    self.searchResult = [self.sitesList filteredArrayUsingPredicate:searchPredicate];
    [self.searchResultTV reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    SiteInfoViewController *siteInfoVC = [[SiteInfoViewController alloc] init];
    siteInfoVC.keywords = searchBar.text;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:siteInfoVC] animated:YES completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [self searchBar:searchBar textDidChange:searchBar.text];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SiteInfoViewController *siteInfoVC = [[SiteInfoViewController alloc] init];
    siteInfoVC.site = self.searchResult[indexPath.row];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:siteInfoVC] animated:YES completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SearchResultTVCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = self.searchResult[indexPath.row][@"name"];
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
