//
//  MessageCenterViewController.m
//  eGo
//
//  Created by 萧宇 on 7/26/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "MessageTableViewCell.h"

@interface MessageCenterViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *messageTV;

@property (nonatomic, strong) NSArray<NSArray *> *messageArray;

@end

@implementation MessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"消息中心";
    
    self.messageTV.delegate = self;
    self.messageTV.dataSource = self;
    
    self.messageArray = @[@[@{@"photo_name" : @"DefaultImage", @"name" : @"Daniel", @"message" : @"Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello ", @"time" : @"12:23"}, @{@"photo_name" : @"DefaultImage", @"name" : @"颜晨倩", @"message" : @"Hello", @"time" : @"12:23"},], @[@{@"photo_name" : @"DefaultImage", @"name" : @"Daniel", @"message" : @"Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello ", @"time" : @"12:23"}, @{@"photo_name" : @"DefaultImage", @"name" : @"颜晨倩", @"message" : @"Hello", @"time" : @"12:23"}, @{@"photo_name" : @"DefaultImage", @"name" : @"Peter", @"message" : @"Hello", @"time" : @"12:23"}, @{@"photo_name" : @"DefaultImage", @"name" : @"林渊腾", @"message" : @"Hello", @"time" : @"12:23"}]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.messageArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArray[section].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MessageTVCell";
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageTableViewCell" owner:nil options:nil] lastObject];
    }
    
    cell.imageView.image = [UIImage imageNamed:self.messageArray[indexPath.section][indexPath.row][@"photo_name"]];
    cell.nameLbl.text = self.messageArray[indexPath.section][indexPath.row][@"name"];
    cell.messageLbl.text = self.messageArray[indexPath.section][indexPath.row][@"message"];
    cell.timeLbl.text = self.messageArray[indexPath.section][indexPath.row][@"time"];
    
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
