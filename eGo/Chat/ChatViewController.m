//
//  ChatViewController.m
//  eGo
//
//  Created by 萧宇 on 8/25/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatReceiverTableViewCell.h"
#import "ChatSenderTableViewCell.h"

@interface ChatViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *messageTblView;
@property (strong, nonatomic) IBOutlet UITextField *inputTxtFld;

@property (nonatomic, strong) NSArray<NSDictionary *> *messages;

@end

@implementation ChatViewController {
    NSNumber *_isLoad;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = _name;
    _isLoad = @NO;
    
    self.messages = @[@{@"avatar" : @"DefaultImage", @"message" : @"Hello", @"from" : @"Daniel", @"to" : @"Peter"}, @{@"avatar" : @"DefaultImage", @"message" : @"Hello", @"from" : @"Daniel", @"to" : @"Peter"}, @{@"avatar" : @"DefaultImage", @"message" : @"Hello", @"from" : @"Daniel", @"to" : @"Peter"}, @{@"avatar" : @"DefaultImage", @"message" : @"Hello", @"from" : @"Daniel", @"to" : @"Peter"}, @{@"avatar" : @"Background", @"message" : @"Mr. Johnson had never been up in an aerophane before and he had read a lot about air accidents, so one day when a friend offered to take him for a ride in his own small phane, Mr. Johnson was very worried about accepting. Finally, however, his friend persuaded him that it was very safe, and Mr. Johnson boarded the plane.", @"from" : @"Peter", @"to" : @"Daniel"}, @{@"avatar" : @"DefaultImage", @"message" : @"Hello", @"from" : @"Daniel", @"to" : @"Peter"}, @{@"avatar" : @"Background", @"message" : @"His friend started the engine and began to taxi onto the runway of the airport. Mr. Johnson had heard that the most dangerous part of a flight were the take-off and the landing, so he was extremely frightened and closed his eyes.", @"from" : @"Peter", @"to" : @"Daniel"}, @{@"avatar" : @"DefaultImage", @"message" : @"Hello", @"from" : @"Daniel", @"to" : @"Peter"}, @{@"avatar" : @"Background", @"message" : @"After a minute or two he opened them again, looked out of the window of the plane, and said to his friend, 'Look at those people down there. They look as small as ants, don't they?'", @"from" : @"Peter", @"to" : @"Daniel"}, @{@"avatar" : @"DefaultImage", @"message" : @"Hello", @"from" : @"Daniel", @"to" : @"Peter"}, @{@"avatar" : @"Background", @"message" : @"Mr. Johnson had never been up in an aerophane before and he had read a lot about air accidents, so one day when a friend offered to take him for a ride in his own small phane, Mr. Johnson was very worried about accepting. Finally, however, his friend persuaded him that it was very safe, and Mr. Johnson boarded the plane.", @"from" : @"Peter", @"to" : @"Daniel"}, @{@"avatar" : @"DefaultImage", @"message" : @"Hello", @"from" : @"Daniel", @"to" : @"Peter"}, @{@"avatar" : @"Background", @"message" : @"'Those are ants,' answered his friend. 'We're still on the ground.'", @"from" : @"Peter", @"to" : @"Daniel"}, @{@"avatar" : @"DefaultImage", @"message" : @"Hello", @"from" : @"Daniel", @"to" : @"Peter"}, @{@"avatar" : @"Background", @"message" : @"Mr. Johnson had never been up in an aerophane before and he had read a lot about air accidents, so one day when a friend offered to take him for a ride in his own small phane, Mr. Johnson was very worried about accepting. Finally, however, his friend persuaded him that it was very safe, and Mr. Johnson boarded the plane.", @"from" : @"Peter", @"to" : @"Daniel"}, ];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.messageTblView.delegate = self;
    self.messageTblView.dataSource = self;
    self.inputTxtFld.delegate = self;
    
    // 页面即将显示时隐藏TabBarController
    [UIView animateWithDuration:0.1 animations:^{
        self.tabBarController.tabBar.center = CGPointMake(self.tabBarController.tabBar.center.x, self.tabBarController.tabBar.center.y + 48);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.messageTblView.delegate = nil;
    self.messageTblView.dataSource = nil;
    self.inputTxtFld.delegate = nil;
    
    // 页面即将退出时显示TabBarController
    [UIView animateWithDuration:0.3 animations:^{
        self.tabBarController.tabBar.center = CGPointMake(self.tabBarController.tabBar.center.x, self.tabBarController.tabBar.center.y - 48);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [_messageTblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_messages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGFloat offset = [UIScreen mainScreen].bounds.size.height - (_inputTxtFld.frame.origin.y + _inputTxtFld.frame.size.height + 256.0);
    if (offset < 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.1 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }];
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row && [_isLoad isEqual:@NO]){
        [_messageTblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_messages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        _isLoad = @YES;
    }
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ChatTableViewCell";
    ChatReceiverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if ([_messages[_messages.count - indexPath.row - 1][@"from"] isEqualToString:@"Daniel"]) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ChatSenderTableViewCell" owner:nil options:nil] lastObject];
        } else {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ChatReceiverTableViewCell" owner:nil options:nil] lastObject];
        }
    }
    
    cell.avatarImgView.image = [UIImage imageNamed:_messages[_messages.count - indexPath.row - 1][@"avatar"]];
    cell.avatarImgView.layer.masksToBounds = YES;
    cell.avatarImgView.layer.cornerRadius = cell.avatarImgView.frame.size.width / 2;
    cell.contentLbl.text = _messages[_messages.count - indexPath.row - 1][@"message"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
