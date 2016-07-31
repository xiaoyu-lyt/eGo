//
//  FriendsViewController.m
//  eGo
//
//  Created by 萧宇 on 7/29/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendsTableViewCell.h"

@interface FriendsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, strong) NSArray *friendsArray;
@property (strong, nonatomic) IBOutlet UITableView *friendsTV;

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"好友列表";
    
    UIBarButtonItem *addBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriend:)];
    self.navigationItem.rightBarButtonItem = addBarBtn;
    
    self.friendsArray = [@[@{@"photo_name" : @"DefaultImage", @"name" : @"Daniel", @"message" : @"Hello", @"time" : @"12:23"}, @{@"photo_name" : @"DefaultImage", @"name" : @"Lam", @"message" : @"Hello", @"time" : @"12:23"}, @{@"photo_name" : @"DefaultImage", @"name" : @"Jerome", @"message" : @"Hello", @"time" : @"12:23"}, @{@"photo_name" : @"DefaultImage", @"name" : @"Jim", @"message" : @"Hello", @"time" : @"12:23"}] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1[@"name"] compare:obj2[@"name"]];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.friendsTV.delegate = self;
    self.friendsTV.dataSource = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.friendsTV.delegate = nil;
    self.friendsTV.dataSource = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addFriend:(UIBarButtonItem *)btn {
    NSLog(@"Add friend");
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FriendsTVCell";
    FriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FriendsTableViewCell" owner:nil options:nil] lastObject];
    }
    cell.userPhotoImgView.image = [UIImage imageNamed:self.friendsArray[indexPath.row][@"photo_name"]];
    cell.nameLbl.text = self.friendsArray[indexPath.row][@"name"];
    cell.messageLbl.text = self.friendsArray[indexPath.row][@"message"];
    cell.timeLbl.text = self.friendsArray[indexPath.row][@"time"];
    return cell;
}

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
