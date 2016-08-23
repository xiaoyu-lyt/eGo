//
//  AddBikeInfoViewController.m
//  eGo
//
//  Created by 萧宇 on 8/23/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "AddBikeInfoViewController.h"

typedef enum : NSUInteger {
    WaitStateFiveMinutes,
    WaitStateTenMinutes,
} WaitState;

@interface AddBikeInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *inputTblView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIImageView *isWaitImgView;
@property (strong, nonatomic) IBOutlet UIView *waitTimeView;
@property (strong, nonatomic) IBOutlet UIButton *waitForFiveMinutesBtn;
@property (strong, nonatomic) IBOutlet UIButton *waitForTenMinutesBtn;

@end

@implementation AddBikeInfoViewController {
    NSNumber *_isWait;
    WaitState _waitState;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"发布新消息";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.waitTimeView.hidden = YES;
    
    UIBarButtonItem *publishBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(publishBarBtnClicked:)];
    self.navigationItem.rightBarButtonItem = publishBarBtn;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(isWaitImgViewTapped:)];
    self.isWaitImgView.userInteractionEnabled = YES;
    [self.isWaitImgView addGestureRecognizer:tap];
    _isWait = @NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.inputTblView.delegate = self;
    self.inputTblView.dataSource = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.inputTblView.delegate = nil;
    self.inputTblView.dataSource = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)publishBarBtnClicked:(UIBarButtonItem *)Btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)isWaitImgViewTapped:(UITapGestureRecognizer *)tap {
    if ([_isWait isEqual:@YES]) {
        self.isWaitImgView.image = [UIImage imageNamed:@"CheckBox-Unchecked"];
        self.waitTimeView.hidden = YES;
        _isWait = @NO;
    } else {
        self.isWaitImgView.image = [UIImage imageNamed:@"CheckBox-Checked"];
        self.waitTimeView.hidden = NO;
        _isWait = @YES;
    }
    
}

- (IBAction)waitForFiveMinutesBtnClicked:(id)sender {
    [self.waitForFiveMinutesBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.waitForTenMinutesBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _waitState = WaitStateFiveMinutes;
}

- (IBAction)waitForTenMinutesBtnClicked:(id)sender {
    [self.waitForFiveMinutesBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.waitForTenMinutesBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _waitState = WaitStateTenMinutes;
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"InputTlbViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.imageView.image = (indexPath.row == 0) ? [UIImage imageNamed:@"Origin"] : [UIImage imageNamed:@"Destination"];
    cell.textLabel.text = (indexPath.row == 0) ? _origin : _destination;
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
