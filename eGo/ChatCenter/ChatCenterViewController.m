//
//  ChatCenterViewController.m
//  eGo
//
//  Created by 萧宇 on 7/27/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "ChatCenterViewController.h"
#import "ChatTableViewCell.h"

@interface ChatCenterViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *chatTV;

@property (nonatomic, strong) NSArray<NSDictionary *> *chatArray;

@end

@implementation ChatCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"下课聊";
    
    self.chatArray = @[@{@"avatar" : @"DefaultImage", @"name" : @"Lam", @"time" : @"12:00", @"place" : @"FZU", @"content" : @"HelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHello"}];
    
    self.chatTV.delegate = self;
    self.chatTV.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 128.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MessageTVCell";
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChatTableViewCell" owner:nil options:nil] lastObject];
    }
    
    cell.avatarImgView.layer.masksToBounds = YES;
    cell.avatarImgView.layer.cornerRadius = cell.imageView.frame.size.width / 2;
    cell.avatarImgView.image = [UIImage imageNamed:self.chatArray[indexPath.section][@"avatar"]];
    cell.nameLbl.text = self.chatArray[indexPath.section][@"name"];
    cell.timeLbl.text = self.chatArray[indexPath.section][@"time"];
    cell.placeLbl.text = self.chatArray[indexPath.section][@"place"];
    cell.contentLbl.text = self.chatArray[indexPath.section][@"content"];
    
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
