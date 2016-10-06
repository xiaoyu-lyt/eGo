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
    
    NSLog(@"%@", _chatInfo);
    
    self.commentsArray = @[];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getData];
    
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

- (void)getData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[kApiUrl stringByAppendingString:[NSString stringWithFormat:@"chat-center/comments/%@.html", _chatInfo[@"id"]]] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.commentsArray = responseObject;
        [_detailTblView reloadData];
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

#pragma mark - UITableViewDatasource

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
            [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:[kImageUrl stringByAppendingString:[NSString stringWithFormat:@"User/%@.png", [User sharedUser].avatar]]] placeholderImage:[UIImage imageNamed:@"loading.gif"]];
            cell.avatarImgView.layer.masksToBounds = YES;
            cell.avatarImgView.layer.cornerRadius = 24;
            cell.nameLbl.text = self.chatInfo[@"name"];
            cell.genderImgView.image = [UIImage imageNamed:([self.chatInfo[@"gender"] integerValue] == 0) ? @"Male" : @"Female"];
            cell.timeLbl.text = self.chatInfo[@"time"];
            cell.placeLbl.text = self.chatInfo[@"place"];
            cell.contentLbl.text = self.chatInfo[@"content"];
            NSArray *likedList = _chatInfo[@"likedList"];
            [cell.likeBtn setImage:[UIImage imageNamed:([self isLiked:likedList]) ? @"Liked" : @"Like"] forState:UIControlStateNormal];
            [cell.likeBtn setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)likedList.count] forState:UIControlStateNormal];
            [cell.likeBtn addTarget:self action:@selector(likeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            NSArray *commentsList = _chatInfo[@"commentsList"];
            [cell.commentBtn setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)commentsList.count] forState:UIControlStateNormal];
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
            [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:[kImageUrl stringByAppendingString:[NSString stringWithFormat:@"User/%@.png", [User sharedUser].avatar]]] placeholderImage:[UIImage imageNamed:@"loading.gif"]];
            cell.avatarImgView.layer.masksToBounds = YES;
            cell.avatarImgView.layer.cornerRadius = 20;
            NSInteger floor = [[NSString stringWithFormat:@"%@", self.commentsArray[indexPath.row][@"floor"]] integerValue];
            cell.floorLbl.text = [NSString stringWithFormat:@"%ldL", (long)floor];
            cell.nameLbl.text = self.commentsArray[indexPath.row][@"name"];
            cell.timeLbl.text = self.commentsArray[indexPath.row][@"time"];
            cell.placeLbl.text = self.commentsArray[indexPath.row][@"place"];
            NSInteger superFloor = [[NSString stringWithFormat:@"%@", self.commentsArray[indexPath.row][@"super_floor"]] integerValue];
            cell.contentLbl.text = (superFloor == 0) ? self.commentsArray[indexPath.row][@"content"] : [NSString stringWithFormat:@"@%ldL：%@", (long)superFloor, self.commentsArray[indexPath.row][@"content"]];
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
