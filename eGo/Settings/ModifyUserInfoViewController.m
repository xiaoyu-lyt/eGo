//
//  ModifyUserInfoViewController.m
//  eGo
//
//  Created by 萧宇 on 8/21/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "ModifyUserInfoViewController.h"

#import "User.h"
#import "Util.h"

@interface ModifyUserInfoViewController ()<UITextFieldDelegate>

@property (nonatomic, assign) NSNumber *isEdited;   // 当前信息是否改动

@end

@implementation ModifyUserInfoViewController {
    UITextField *_inputTxtFld1;     // 对应第一个TextField
    UITextField *_inputTxtFld2;     // 对应第二个TextField
    UITextField *_inputTxtFld3;     // 对应第三个TextField
    UIButton *_getVerifyCodeBtn;    // 获取验证码Button
    UIBarButtonItem *_saveBarBtn;   // 保存修改Button
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    switch (_userInfoType) {
        case UserInfoTypeNickname:
            self.title = @"修改昵称";
            [self modifyNickname];
            break;
        case UserInfoTypeTel:
            self.title = @"修改手机号";
            [self modifyTel];
            break;
        case UserInfoTypeEmail:
            self.title = @"修改邮箱";
            [self modifyEmail];
            break;
        case UserInfoTypePassword:
            self.title = @"修改密码";
            [self modifyPassword];
            break;
        default:
            break;
    }
    
    _saveBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStyleDone target:self action:@selector(saveUserInfoBrnClicked:)];
    _saveBarBtn.enabled = NO;
    self.navigationItem.rightBarButtonItem = _saveBarBtn;
    
    [self addObserver:self forKeyPath:@"isEdited" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeObserver:self forKeyPath:@"isEdited"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)modifyNickname {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 64.0, [UIScreen mainScreen].bounds.size.width, 44.0)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    _inputTxtFld1 = [[UITextField alloc] initWithFrame:CGRectMake(8.0, 8.0, view.frame.size.width - 16.0, view.frame.size.height - 16.0)];
    _inputTxtFld1.text = self.userInfo;
    _inputTxtFld1.clearButtonMode = UITextFieldViewModeWhileEditing;
    _inputTxtFld1.delegate = self;
    _inputTxtFld1.returnKeyType = UIReturnKeyDone;
    [_inputTxtFld1 becomeFirstResponder];
    [view addSubview:_inputTxtFld1];
}

- (void)modifyTel {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 64.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64.0)];
    [self.view addSubview:view];
    
    UILabel *areaLbl = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 8.0, 64.0, 36.0)];
    areaLbl.text = @"+86";
    areaLbl.backgroundColor = [UIColor whiteColor];
    areaLbl.textAlignment = NSTextAlignmentCenter;
    [view addSubview:areaLbl];
    
    _inputTxtFld1 = [[UITextField alloc] initWithFrame:CGRectMake(73.0, 8.0, [UIScreen mainScreen].bounds.size.width - 81.0, 36.0)];
    _inputTxtFld1.text = _userInfo;
    _inputTxtFld1.placeholder = @"请输入手机号";
    _inputTxtFld1.backgroundColor = [UIColor whiteColor];
    _inputTxtFld1.keyboardType = UIKeyboardTypeNumberPad;
    _inputTxtFld1.delegate = self;
    _inputTxtFld1.returnKeyType = UIReturnKeyNext;
    _inputTxtFld1.tag = 0 + BASIC_TAG_VALUE;
    [_inputTxtFld1 becomeFirstResponder];
    [view addSubview:_inputTxtFld1];
    
    _inputTxtFld2 = [[UITextField alloc] initWithFrame:CGRectMake(8.0, 45.0, [UIScreen mainScreen].bounds.size.width - 117.0, 36.0)];
    _inputTxtFld2.placeholder = @"手机验证码";
    _inputTxtFld2.backgroundColor = [UIColor whiteColor];
    _inputTxtFld2.keyboardType = UIKeyboardTypeNumberPad;
    _inputTxtFld2.delegate = self;
    _inputTxtFld2.returnKeyType = UIReturnKeyDone;
    _inputTxtFld2.tag = 1 + BASIC_TAG_VALUE;
    [view addSubview:_inputTxtFld2];
    
    _getVerifyCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 108.0, 45.0, 100.0, 36.0)];
    _getVerifyCodeBtn.enabled = NO;
    _getVerifyCodeBtn.backgroundColor = [UIColor whiteColor];
    _getVerifyCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_getVerifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVerifyCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_getVerifyCodeBtn addTarget:self action:@selector(getVerifyCodeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_getVerifyCodeBtn];
}

- (void)modifyEmail {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 64.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64.0)];
    [self.view addSubview:view];
    
    _inputTxtFld1 = [[UITextField alloc] initWithFrame:CGRectMake(8.0, 8.0, [UIScreen mainScreen].bounds.size.width - 16.0, 36.0)];
    _inputTxtFld1.text = _userInfo;
    _inputTxtFld1.placeholder = @"请输入邮箱";
    _inputTxtFld1.backgroundColor = [UIColor whiteColor];
    _inputTxtFld1.keyboardType = UIKeyboardTypeEmailAddress;
    _inputTxtFld1.delegate = self;
    _inputTxtFld1.returnKeyType = UIReturnKeyNext;
    _inputTxtFld1.tag = 0 + BASIC_TAG_VALUE;
    [_inputTxtFld1 becomeFirstResponder];
    [view addSubview:_inputTxtFld1];
    
    _inputTxtFld2 = [[UITextField alloc] initWithFrame:CGRectMake(8.0, 45.0, [UIScreen mainScreen].bounds.size.width - 117.0, 36.0)];
    _inputTxtFld2.placeholder = @"邮件验证码";
    _inputTxtFld2.backgroundColor = [UIColor whiteColor];
    _inputTxtFld2.keyboardType = UIKeyboardTypeNumberPad;
    _inputTxtFld2.delegate = self;
    _inputTxtFld2.returnKeyType = UIReturnKeyDone;
    _inputTxtFld2.tag = 1 + BASIC_TAG_VALUE;
    [view addSubview:_inputTxtFld2];
    
    _getVerifyCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 108.0, 45.0, 100.0, 36.0)];
    _getVerifyCodeBtn.enabled = NO;
    _getVerifyCodeBtn.backgroundColor = [UIColor whiteColor];
    _getVerifyCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_getVerifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVerifyCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_getVerifyCodeBtn addTarget:self action:@selector(getVerifyCodeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_getVerifyCodeBtn];
}

- (void)modifyPassword {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 64.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64.0)];
    [self.view addSubview:view];
    
    _inputTxtFld1 = [[UITextField alloc] initWithFrame:CGRectMake(8.0, 8.0, [UIScreen mainScreen].bounds.size.width - 16.0, 36.0)];
    _inputTxtFld1.placeholder = @"当前密码";
    _inputTxtFld1.backgroundColor = [UIColor whiteColor];
    _inputTxtFld1.secureTextEntry = YES;
    _inputTxtFld1.clearsOnBeginEditing = YES;
    _inputTxtFld1.delegate = self;
    _inputTxtFld1.returnKeyType = UIReturnKeyNext;
    _inputTxtFld1.tag = 0 + BASIC_TAG_VALUE;
    [view addSubview:_inputTxtFld1];
    
    _inputTxtFld2 = [[UITextField alloc] initWithFrame:CGRectMake(8.0, 45.0, [UIScreen mainScreen].bounds.size.width - 16.0, 36.0)];
    _inputTxtFld2.placeholder = @"新密码";
    _inputTxtFld2.backgroundColor = [UIColor whiteColor];
    _inputTxtFld2.secureTextEntry = YES;
    _inputTxtFld2.clearsOnBeginEditing = YES;
    _inputTxtFld2.delegate = self;
    _inputTxtFld2.returnKeyType = UIReturnKeyNext;
    _inputTxtFld2.tag = 1 + BASIC_TAG_VALUE;
    [view addSubview:_inputTxtFld2];
    
    _inputTxtFld3 = [[UITextField alloc] initWithFrame:CGRectMake(8.0, 82.0, [UIScreen mainScreen].bounds.size.width - 16.0, 36.0)];
    _inputTxtFld3.placeholder = @"确认密码";
    _inputTxtFld3.backgroundColor = [UIColor whiteColor];
    _inputTxtFld3.secureTextEntry = YES;
    _inputTxtFld3.clearsOnBeginEditing = YES;
    _inputTxtFld3.delegate = self;
    _inputTxtFld3.returnKeyType = UIReturnKeyDone;
    _inputTxtFld3.tag = 2 + BASIC_TAG_VALUE;
    [view addSubview:_inputTxtFld3];
}

- (void)saveUserInfoBrnClicked:(UIBarButtonItem *)btn {
    switch (_userInfoType) {
        case UserInfoTypeNickname:
            [[User sharedUser].user setObject:_inputTxtFld1.text forKey:@"nickname"];
            break;
            
        default:
            break;
    }
    NSLog(@"%@", [[User sharedUser] saveData]);
    NSLog(@"a");
}

- (void)getVerifyCodeBtnClicked:(UIButton *)btn {
    switch (_userInfoType) {
        case UserInfoTypeTel:
            NSLog(@"Tel verify code");
            break;
        case UserInfoTypeEmail:
            NSLog(@"Email verify code");
            break;
        default:
            break;
    }
}

#pragma mark - KVO method

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([self.isEdited isEqual:@YES]) {
        _saveBarBtn.enabled = YES;
    } else {
        _saveBarBtn.enabled = NO;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_userInfoType == UserInfoTypePassword) {
        self.isEdited = @NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_userInfoType == UserInfoTypePassword && textField.text.length >= 6) {
        switch (textField.tag - BASIC_TAG_VALUE) {
            case 0:
                [_inputTxtFld2 becomeFirstResponder];
                break;
            case 1:
                [_inputTxtFld3 becomeFirstResponder];
                break;
            case 2:
                break;
            default:
                break;
        }
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    switch (_userInfoType) {
        case UserInfoTypeNickname:
            if (![[NSString stringWithFormat:@"%@%@", [textField.text substringToIndex:range.location], string] isEqualToString:_userInfo]) {
                self.isEdited = @YES;
            } else {
                self.isEdited = @NO;
            }
            break;
        case UserInfoTypeTel:
            switch (textField.tag - BASIC_TAG_VALUE) {
                case 0:{
                    NSString *tel = [NSString stringWithFormat:@"%@%@", [textField.text substringToIndex:range.location], string];
                    if (tel.length > 11) {
                        return NO;
                    }
                    if (![tel isEqualToString:_userInfo] && tel.length == 11) {
                        _getVerifyCodeBtn.enabled = YES;
                        [_getVerifyCodeBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                    } else {
                        _getVerifyCodeBtn.enabled = NO;
                        [_getVerifyCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    }
                }
                    break;
                case 1:{
                    NSString *verifyCode = [NSString stringWithFormat:@"%@%@", [textField.text substringToIndex:range.location], string];
                    if (verifyCode.length > 6) {
                        return NO;
                    } else if (verifyCode.length == 6) {
                        self.isEdited = @YES;
                    } else {
                        self.isEdited = @NO;
                    }
                }
                    break;
                default:
                    break;
            }
            break;
        case UserInfoTypeEmail:
            switch (textField.tag - BASIC_TAG_VALUE) {
                case 0:{
                    NSString *email = [NSString stringWithFormat:@"%@%@", [textField.text substringToIndex:range.location], string];
                    if (![email isEqualToString:_userInfo]) {
                        _getVerifyCodeBtn.enabled = YES;
                        [_getVerifyCodeBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                    } else {
                        _getVerifyCodeBtn.enabled = NO;
                        [_getVerifyCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    }
                }
                    break;
                case 1:{
                    NSString *verifyCode = [NSString stringWithFormat:@"%@%@", [textField.text substringToIndex:range.location], string];
                    if (verifyCode.length > 6) {
                        return NO;
                    } else if (verifyCode.length == 6) {
                        self.isEdited = @YES;
                    } else {
                        self.isEdited = @NO;
                    }
                }
                    break;
                default:
                    break;
            }
            break;
        case UserInfoTypePassword:
            if ([NSString stringWithFormat:@"%@%@", [textField.text substringToIndex:range.location], string].length > 20) {
                return NO;
            }
            switch (textField.tag - BASIC_TAG_VALUE) {
                case 0:{
                    NSString *input1 = [NSString stringWithFormat:@"%@%@", [textField.text substringToIndex:range.location], string];
                    NSString *input2 = _inputTxtFld2.text;
                    NSString *input3 = _inputTxtFld3.text;
                    if (input1.length >= 6 && input2.length >= 6 && input3.length >= 6) {
                        self.isEdited = @YES;
                    } else {
                        self.isEdited = @NO;
                    }
                }
                    break;
                case 1:{
                    NSString *input1 = _inputTxtFld1.text;
                    NSString *input2 = [NSString stringWithFormat:@"%@%@", [textField.text substringToIndex:range.location], string];
                    NSString *input3 = _inputTxtFld3.text;
                    if (input1.length >= 6 && input2.length >= 6 && input3.length >= 6) {
                        self.isEdited = @YES;
                    } else {
                        self.isEdited = @NO;
                    }
                }
                    break;
                case 2:{
                    NSString *input1 = _inputTxtFld1.text;
                    NSString *input2 = _inputTxtFld2.text;
                    NSString *input3 = [NSString stringWithFormat:@"%@%@", [textField.text substringToIndex:range.location], string];
                    if (input1.length >= 6 && input2.length >= 6 && input3.length >= 6) {
                        self.isEdited = @YES;
                    } else {
                        self.isEdited = @NO;
                    }
                }
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    return YES;
}

@end
