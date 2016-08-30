//
//  MessageViewController.m
//  eGo
//
//  Created by 萧宇 on 8/29/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "ChatViewController.h"

@interface MessageViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *messageListTblView;

@property (nonatomic, strong) NSArray *messageList;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.messageList = @[@{@"avatar" : @"DefaultImage", @"alias" : @"Daniel", @"content" : @"Hello", @"time" : @"12:00"}, @{@"avatar" : @"DefaultImage", @"alias" : @"Daniel", @"content" : @"Hello", @"time" : @"12:00"}, @{@"avatar" : @"DefaultImage", @"alias" : @"Daniel", @"content" : @"Hello", @"time" : @"12:00"}, @{@"avatar" : @"DefaultImage", @"alias" : @"Daniel", @"content" : @"Hello", @"time" : @"12:00"}, @{@"avatar" : @"DefaultImage", @"alias" : @"Daniel", @"content" : @"Hello", @"time" : @"12:00"}, @{@"avatar" : @"DefaultImage", @"alias" : @"Daniel", @"content" : @"Hello", @"time" : @"12:00"}, @{@"avatar" : @"DefaultImage", @"alias" : @"Daniel", @"content" : @"Hello", @"time" : @"12:00"}, @{@"avatar" : @"DefaultImage", @"alias" : @"Daniel", @"content" : @"Hello", @"time" : @"12:00"}, @{@"avatar" : @"DefaultImage", @"alias" : @"Daniel", @"content" : @"Hello", @"time" : @"12:00"}, @{@"avatar" : @"DefaultImage", @"alias" : @"Daniel", @"content" : @"Hello", @"time" : @"12:00"}, @{@"avatar" : @"DefaultImage", @"alias" : @"Daniel", @"content" : @"Hello", @"time" : @"12:00"}, @{@"avatar" : @"DefaultImage", @"alias" : @"Daniel", @"content" : @"Hello", @"time" : @"12:00"}, @{@"avatar" : @"DefaultImage", @"alias" : @"Daniel", @"content" : @"Hello", @"time" : @"12:00"}, @{@"avatar" : @"DefaultImage", @"alias" : @"Daniel", @"content" : @"Hello", @"time" : @"12:00"}, @{@"avatar" : @"DefaultImage", @"alias" : @"Daniel", @"content" : @"Hello", @"time" : @"12:00"}, @{@"avatar" : @"DefaultImage", @"alias" : @"Daniel", @"content" : @"Hello", @"time" : @"12:00"}, @{@"avatar" : @"Background", @"alias" : @"Potter", @"content" : @"HelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHello", @"time" : @"12:34"}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.messageListTblView.delegate = self;
    self.messageListTblView.dataSource = self;
    
    [self.messageListTblView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.messageListTblView.delegate = nil;
    self.messageListTblView.dataSource = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ChatViewController *chatVC = [[ChatViewController alloc] init];
    chatVC.name = _messageList[indexPath.row][@"alias"];
    [self showViewController:chatVC sender:nil];
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MessageTableViewCell";
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil] lastObject];
    }
    cell.userPhotoImgView.layer.masksToBounds = YES;
    cell.userPhotoImgView.layer.cornerRadius = 24.0;
    cell.userPhotoImgView.image = [UIImage imageNamed:_messageList[indexPath.row][@"avatar"]];
    cell.nameLbl.text = _messageList[indexPath.row][@"alias"];
    cell.timeLbl.text = _messageList[indexPath.row][@"time"];
    cell.messageLbl.text = _messageList[indexPath.row][@"content"];
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
