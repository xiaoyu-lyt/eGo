//
//  DetailViewController.m
//  eGo
//
//  Created by 萧宇 on 8/6/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "DetailViewController.h"
#import "ChatTableViewCell.h"
#import "CommentsTableViewCell.h"

#import "User.h"
#import "Util.h"
#import "AFNetworking.h"

@interface DetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *detailTblView;
@property (strong, nonatomic) IBOutlet UITextField *inputTxtFld;

@property (nonatomic, strong) NSArray<NSDictionary *> *commentsArray;
@property (nonatomic, strong) NSArray<NSString *> *cellList;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"详情";
    self.cellList = @[@"detailTblViewCell", @"CommentsTVCell"];
    
    self.commentsArray = @[@{@"content" : @"啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊", @"superFloor" : @"1"}, @{@"content" : @"1"}, @{@"content" : @"1"}, @{@"content" : @"1"}, @{@"content" : @"1"}, @{@"content" : @"1"}, @{@"content" : @"1"}, @{@"content" : @"1"}, @{@"content" : @"1"}, @{@"content" : @"1"}, @{@"content" : @"1"}, @{@"content" : @"1"}, @{@"content" : @"1"}, @{@"content" : @"1"}, @{@"content" : @"1"}, @{@"content" : @"1"}, @{@"content" : @"1"}, @{@"content" : @"1"}, @{@"content" : @"1"}, @{@"content" : @"1"}, @{@"content" : @"1"}, @{@"content" : @"1"}, @{@"content" : @"1"}, @{@"content" : @"1"}, @{@"content" : @"1"}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.detailTblView.delegate = self;
    self.detailTblView.dataSource = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.detailTblView.delegate = nil;
    self.detailTblView.dataSource = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 1 : self.commentsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0) ? 0.0 : 24.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, 24.0)];
    headerLbl.text = [NSString stringWithFormat:@"共%lu条评论", (unsigned long)self.commentsArray.count];
    headerLbl.backgroundColor = [UIColor colorWithRGBValue:0xdddddd];
    return headerLbl;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            static NSString *CellIdentifier1 = @"ChatTableViewCell";
            ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier1 owner:nil options:nil] lastObject];
            }
            cell.avatarImgView.image = [UIImage imageNamed:self.chatInfo[@"avatar"]];
            cell.nameLbl.text = self.chatInfo[@"name"];
            cell.genderImgView.image = [UIImage imageNamed:([self.chatInfo[@"gender"] integerValue] == 1) ? @"Male" : @"Female"];
            cell.timeLbl.text = self.chatInfo[@"time"];
            cell.placeLbl.text = self.chatInfo[@"place"];
            cell.contentLbl.text = self.chatInfo[@"content"];
            [cell.likeBtn setTitle:self.chatInfo[@"likeNum"] forState:UIControlStateNormal];
            [cell.likeBtn addTarget:self action:@selector(likeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.commentBtn setTitle:self.chatInfo[@"commentNum"] forState:UIControlStateNormal];
            [cell.commentBtn addTarget:self action:@selector(commentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.shareBtn setTitle:@"分享" forState:UIControlStateNormal];
            [cell.shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:{
            static NSString *CellIdentifier2 = @"CommentsTableViewCell";
            CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier2 owner:nil options:nil] lastObject];
            }
            NSString *superFloor = [NSString stringWithFormat:@"%@", self.commentsArray[indexPath.row][@"superFloor"]];
            cell.contentLbl.text = ([superFloor isEqual:@"(null)"]) ? self.commentsArray[indexPath.row][@"content"] : [NSString stringWithFormat:@"@%@L：%@", superFloor, self.commentsArray[indexPath.row][@"content"]];
            cell.likeBtn.tag = BASIC_TAG_VALUE + indexPath.row;
            [cell.likeBtn setTitle:self.commentsArray[indexPath.row][@"likeNum"] forState:UIControlStateNormal];
            [cell.likeBtn addTarget:self action:@selector(likeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.commentBtn.tag = BASIC_TAG_VALUE + indexPath.row;;
            [cell.commentBtn addTarget:self action:@selector(commentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Button Clicked

- (void)likeBtnClicked:(UIButton *)btn {
    NSLog(@"Like button clicked");
    NSLog(@"%ld", btn.tag);
}

- (void)commentBtnClicked:(UIButton *)btn {
    NSLog(@"Comment button clicked");
}

- (void)shareBtnClicked:(UIButton *)btn {
    NSLog(@"Share button clicked");
    [self.view makeToast:@"更多功能敬请期待"];
}

@end
