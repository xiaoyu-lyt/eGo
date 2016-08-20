//
//  SelectSiteViewController.m
//  eGo
//
//  Created by 萧宇 on 8/10/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "SelectSiteViewController.h"

@interface SelectSiteViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *sitesTV;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *sitesList;

@end

@implementation SelectSiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initSearchBar];
    
    self.sitesList = @[@{@"name" : @"福州大学", @"latitude" : @"26.059522", @"longitude" : @"119.194197"}, @{@"name" : @"福州大学图书馆", @"latitude" : @"26.051522", @"longitude" : @"119.191197"}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.sitesTV.delegate = self;
    self.sitesTV.dataSource = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.sitesTV.delegate = nil;
    self.sitesTV.dataSource = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSearchBar {
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.text = self.site;
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.text = @"";
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate site:self.sitesList[indexPath.row] selectedForType:self.siteType];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sitesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SitesTVCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = _sitesList[indexPath.row][@"name"];
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
