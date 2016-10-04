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
    
    self.chatArray = @[];
    
    self.chatTV.delegate = self;
    self.chatTV.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigationBarButton];
    
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[kApiUrl stringByAppendingString:@"chat-center.html"] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.chatArray = responseObject;
        [_chatTV reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"");
    }];
}

- (BOOL)isLiked:(NSArray *)likedList {
    for (NSDictionary *dict in likedList) {
        if ([[User sharedUser].stuNum isEqualToString:dict[@"user_id"]]) {
            return YES;
        }
    }
    return NO;
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
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil] lastObject];
    }
    
    [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:[kImageUrl stringByAppendingString:[NSString stringWithFormat:@"User/%@.png", [User sharedUser].avatar]]] placeholderImage:[UIImage imageNamed:@"loading.gif"]];
    cell.avatarImgView.layer.masksToBounds = YES;
    cell.avatarImgView.layer.cornerRadius = 24;
    cell.nameLbl.text = self.chatArray[indexPath.section][@"name"];
    cell.genderImgView.image = [UIImage imageNamed:([self.chatArray[indexPath.section][@"gender"] integerValue] == 0) ? @"Male" : @"Female"];
    cell.timeLbl.text = self.chatArray[indexPath.section][@"time"];
    cell.placeLbl.text = self.chatArray[indexPath.section][@"place"];
    cell.contentLbl.text = self.chatArray[indexPath.section][@"content"];
    NSArray *likedList = self.chatArray[indexPath.section][@"likedList"];
    [cell.likeBtn setImage:[UIImage imageNamed:([self isLiked:likedList]) ? @"Liked" : @"Like"] forState:UIControlStateNormal];
    [cell.likeBtn setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)likedList.count] forState:UIControlStateNormal];
    [cell.likeBtn addTarget:self action:@selector(likeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    NSArray *commentsList = self.chatArray[indexPath.section][@"commentsList"];
    [cell.commentBtn setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)commentsList.count] forState:UIControlStateNormal];
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
