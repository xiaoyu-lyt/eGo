//
//  FeedbackViewController.m
//  eGo
//
//  Created by 萧宇 on 7/29/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "FeedbackViewController.h"

#import "Util.h"

typedef enum : NSUInteger {
    RowSelectedNone,
    RowSelectedSender,
    RowSelectedTitle,
    RowSelectedContent,
} RowSelected;

@interface FeedbackViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *inputTblView;
@property (strong, nonatomic) IBOutlet UITextView *contentTxtView;
@property (strong, nonatomic) IBOutlet UITextField *inputTxtFld;

@property (nonatomic, strong) NSMutableDictionary *inputInfo;
@property (nonatomic, assign) RowSelected rowSelected;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"意见反馈";
    self.rowSelected = RowSelectedNone;
    self.inputInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"sender" : @"", @"title" : @"", @"content" : @""}];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *sendBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(sendBarBtnClicked:)];
    self.navigationItem.rightBarButtonItem = sendBarBtn;
    
    [_inputTxtFld addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.inputTblView.delegate = self;
    self.inputTblView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendBarBtnClicked:(UIBarButtonItem *)btn {
    _inputInfo[@"content"] = _contentTxtView.text;
    if ([NSString stringWithString:_inputInfo[@"sender"]].length == 0) {
        [self.view makeToast:@"发件人不能为空"];
        return;
    } else if ([NSString stringWithString:_inputInfo[@"title"]].length == 0) {
        [self.view makeToast:@"标题不能为空"];
        return;
    }else if ([NSString stringWithString:_inputInfo[@"content"]].length == 0) {
        [self.view makeToast:@"内容不能为空"];
        return;
    } else if (![Util isEmailAddress:_inputInfo[@"sender"]]) {
        [self.view makeToast:@"请输入正确的邮箱地址"];
        return;
    }
    [self.view makeToast:@"已反馈"];
}

- (void)textFieldDidChanged:(UITextField *)textField {
    switch (_rowSelected) {
        case RowSelectedSender:
            self.inputInfo[@"sender"] = textField.text;
            break;
        case RowSelectedTitle:
            self.inputInfo[@"title"] = textField.text;
            break;
        case RowSelectedContent:
            break;
        default:
            break;
    }
    [_inputTblView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.inputTxtFld.text = @"";
    switch (indexPath.row) {
        case 0:
            [self.inputTxtFld becomeFirstResponder];
            self.rowSelected = RowSelectedSender;
            break;
        case 1:
            [self.inputTxtFld becomeFirstResponder];
            self.rowSelected = RowSelectedTitle;
            break;
        case 2:
            [self.contentTxtView becomeFirstResponder];
            self.rowSelected = RowSelectedContent;
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _inputInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FeedBackInputTableVIewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"发件人";
            cell.detailTextLabel.text = _inputInfo[@"sender"];
            break;
        case 1:
            cell.textLabel.text = @"主题";
            cell.detailTextLabel.text = _inputInfo[@"title"];
            break;
        case 2:
            cell.textLabel.text = @"内容";
            break;
        default:
            break;
    }
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
