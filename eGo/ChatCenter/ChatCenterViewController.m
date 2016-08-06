//
//  ChatCenterViewController.m
//  eGo
//
//  Created by 萧宇 on 7/27/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "ChatCenterViewController.h"
#import "ChatTableViewCell.h"
#import "DetailViewController.h"

#include "User.h"
#include "Util.h"
#include "AFNetworking.h"

@interface ChatCenterViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *chatTV;

@property (nonatomic, strong) NSArray<NSDictionary *> *chatArray;

@end

@implementation ChatCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBarButton];
    
    self.chatArray = @[@{@"id" : @"1", @"avatar" : @"DefaultImage", @"name" : @"Daniel", @"gender" : @"1", @"time" : @"12:34", @"place" : @"FZU", @"content" : @"This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.", @"likeNum" : @"123", @"commentNum" : @"456"}, @{@"id" : @"2", @"avatar" : @"Bike", @"name" : @"Daniel", @"gender" : @"1", @"time" : @"12:34", @"place" : @"FZU", @"content" : @"This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.", @"likeNum" : @"123", @"commentNum" : @"456"}, @{@"id" : @"3", @"avatar" : @"Settings", @"name" : @"Daniel", @"gender" : @"1", @"time" : @"12:34", @"place" : @"FZU", @"content" : @"This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.", @"likeNum" : @"123", @"commentNum" : @"456"}, @{@"id" : @"4", @"avatar" : @"User", @"name" : @"Daniel", @"gender" : @"0", @"time" : @"12:34", @"place" : @"FZU", @"content" : @"This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.This is a long text for test.", @"likeNum" : @"123", @"commentNum" : @"456"}, @{@"id" : @"5", @"avatar" : @"DefaultImage", @"name" : @"Daniel", @"gender" : @"1", @"time" : @"12:34", @"place" : @"FZU", @"content" : @"Hello OC", @"likeNum" : @"123", @"commentNum" : @"456"}];
    
    self.chatTV.delegate = self;
    self.chatTV.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.chatArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ChatTableViewCell";
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChatTableViewCell" owner:nil options:nil] lastObject];
    }
    
    cell.avatarImgView.layer.masksToBounds = YES;
    cell.avatarImgView.layer.cornerRadius = cell.imageView.frame.size.width / 2;
    cell.avatarImgView.image = [UIImage imageNamed:self.chatArray[indexPath.section][@"avatar"]];
    cell.nameLbl.text = self.chatArray[indexPath.section][@"name"];
    cell.genderImgView.image = [UIImage imageNamed:([self.chatArray[indexPath.section][@"gender"] integerValue] == 1) ? @"Male" : @"Female"];
    cell.timeLbl.text = self.chatArray[indexPath.section][@"time"];
    cell.placeLbl.text = self.chatArray[indexPath.section][@"place"];
    cell.contentLbl.text = self.chatArray[indexPath.section][@"content"];
    [cell.likeBtn setTitle:self.chatArray[indexPath.section][@"likeNum"] forState:UIControlStateNormal];
    [cell.likeBtn addTarget:self action:@selector(likeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commentBtn setTitle:self.chatArray[indexPath.section][@"commentNum"] forState:UIControlStateNormal];
    [cell.commentBtn addTarget:self action:@selector(commentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [cell.shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.chatInfo = self.chatArray[indexPath.section];
    [self showViewController:detailVC sender:nil];
}

#pragma mark - Button Clicked

- (void)likeBtnClicked:(UIButton *)btn {
    NSLog(@"Like button clicked");
}

- (void)commentBtnClicked:(UIButton *)btn {
    NSLog(@"Comment button clicked");
}

- (void)shareBtnClicked:(UIButton *)btn {
    NSLog(@"Share button clicked");
    [self.view makeToast:@"更多功能敬请期待"];
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
