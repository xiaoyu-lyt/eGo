//
//  NewBikeViewController.m
//  eGo
//
//  Created by 萧宇 on 9/1/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "NewBikeViewController.h"

typedef enum : NSUInteger {
    RowSelectedNone,
    RowSelectedBrand,
    RowSelectedLicence,
} RowSelected;

@interface NewBikeViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *bikeImgView;
@property (strong, nonatomic) IBOutlet UITableView *bikeInfoTblView;
@property (strong, nonatomic) IBOutlet UITextField *inputTxtFld;

@property (nonatomic, strong) NSMutableDictionary *bikeInfo;
@property (nonatomic, assign) RowSelected rowSelected;

@end

@implementation NewBikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"添加电动车";
    self.rowSelected = RowSelectedNone;
    self.bikeInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"brand" : @"aaa", @"licence" : @"bbb"}];
    self.inputTxtFld.returnKeyType = UIReturnKeyDone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.bikeInfoTblView.delegate = self;
    self.bikeInfoTblView.dataSource = self;
    self.inputTxtFld.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.bikeInfoTblView.delegate = nil;
    self.bikeInfoTblView.dataSource = nil;
    self.inputTxtFld.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)saveBtnClicked:(id)sender {
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSLog(@"a");
    switch (_rowSelected) {
        case RowSelectedBrand:
            textField.text = _bikeInfo[@"brand"];
            break;
        case RowSelectedLicence:
            textField.text = _bikeInfo[@"licence"];
            break;
        default:
            break;
    }
    return YES;
} 

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *str = [NSString stringWithFormat:@"%@%@", [textField.text substringToIndex:range.location], string];
    switch (_rowSelected) {
        case RowSelectedBrand:
            self.bikeInfo[@"brand"] = str;
            break;
        case RowSelectedLicence:
            self.bikeInfo[@"licence"] = str;
            break;
        default:
            break;
    }
    [_bikeInfoTblView reloadData];
    return YES;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            self.rowSelected = RowSelectedBrand;
            [_inputTxtFld resignFirstResponder];
            [_inputTxtFld becomeFirstResponder];
            break;
        case 1:
            self.rowSelected = RowSelectedLicence;
            [_inputTxtFld resignFirstResponder];
            [_inputTxtFld becomeFirstResponder];
        default:
            break;
    }
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"BikeInfoTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"品牌";
            cell.detailTextLabel.text = _bikeInfo[@"brand"];
            break;
        case 1:
            cell.textLabel.text = @"车牌号";
            cell.detailTextLabel.text = _bikeInfo[@"licence"];
            break;
        default:
            break;
    }
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
