//
//  RegisterViewController.m
//  eGo
//
//  Created by 萧宇 on 7/26/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "RegisterViewController.h"
#import "BaseViewController.h"

#import "User.h"
#import "Util.h"
#import "AFNetworking.h"

#define TOP_Y [UIScreen mainScreen].bounds.size.height * 0.225

@interface RegisterViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *accountText;
@property (nonatomic, strong) UIImageView *accountImg;
@property (nonatomic, strong) UITextField *passwordText;
@property (nonatomic, strong) UIImageView *passwordImg;
@property (nonatomic, strong) UITextField *vorifyCodeText;
@property (nonatomic, strong) UIImageView *vorifyCodeImg;
@property (nonatomic, strong) UIButton *getVeriftCodeBtn;
@property (nonatomic, strong) UIButton *registerBtn;

@property (nonatomic) int countTime;
@property (nonatomic, strong) NSString *verifyCode;

@end

@implementation RegisterViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"注册";
        
        UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Close"] style:UIBarButtonItemStyleDone target:self action:@selector(close)];
        self.navigationItem.rightBarButtonItem = closeBtn;
        
        // Logo
        UIImageView *logoImg = [[UIImageView alloc]
                                initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 180) / 2.0, TOP_Y, 180, 90)];
        logoImg.image = [UIImage imageNamed:@"AppLogo"];
        logoImg.userInteractionEnabled = YES;
        logoImg.clipsToBounds = YES;
        logoImg.layer.cornerRadius = 24.0f;
        logoImg.layer.borderWidth = 0.2f;
        logoImg.layer.borderColor = [[UIColor grayColor] CGColor];
        [self.view addSubview:logoImg];
        
        // 账号输入框
        self.accountText = [[UITextField alloc] initWithFrame:CGRectMake(50.0, TOP_Y + 108.0, [UIScreen mainScreen].bounds.size.width - 100.0, 30.0)];
        self.accountText.placeholder = @"手机号";
        [self.accountText setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        self.accountText.textColor = [UIColor lightGrayColor];
        self.accountText.textAlignment = NSTextAlignmentCenter;
        self.accountText.keyboardType = UIKeyboardTypeNumberPad;
        self.accountText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.view addSubview:self.accountText];
        // icon
        UIImageView *jwchIdIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        jwchIdIcon.image = [UIImage imageNamed:@"Account"];
        self.accountText.leftView = jwchIdIcon;
        self.accountText.leftViewMode = UITextFieldViewModeAlways;
        // 线
        self.accountImg = [[UIImageView alloc] initWithFrame:CGRectMake(50.0, TOP_Y + 140.0, [UIScreen mainScreen].bounds.size.width - 100.0, 2.0)];
        [self.view addSubview:self.accountImg];
        self.accountImg.image = [UIImage imageNamed:@"textfield_default_holo_light"];
        // 添加delegate
        self.accountText.delegate = self;
        
        // 密码输入框
        self.passwordText = [[UITextField alloc] initWithFrame:CGRectMake(50.0, TOP_Y + 164.0, [UIScreen mainScreen].bounds.size.width - 100.0, 30.0)];
        self.passwordText.placeholder = @"密码";
        [self.passwordText setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        self.passwordText.textColor = [UIColor lightGrayColor];
        self.passwordText.textAlignment = NSTextAlignmentCenter;
        [self.passwordText setSecureTextEntry:YES];
        self.passwordText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.view addSubview:self.passwordText];
        // icon
        UIImageView *passIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        passIcon.image = [UIImage imageNamed:@"Password"];
        self.passwordText.leftView = passIcon;
        self.passwordText.leftViewMode = UITextFieldViewModeAlways;
        // 线
        self.passwordImg = [[UIImageView alloc] initWithFrame:CGRectMake(50.0, TOP_Y + 196.0, [UIScreen mainScreen].bounds.size.width - 100.0, 2.0)];
        [self.view addSubview:self.passwordImg];
        self.passwordImg.image = [UIImage imageNamed:@"textfield_default_holo_light"];
        // 添加delegate
        self.passwordText.delegate = self;
        
        // 验证码输入框
        self.vorifyCodeText = [[UITextField alloc] initWithFrame:CGRectMake(50.0, TOP_Y + 220.0, [UIScreen mainScreen].bounds.size.width - 200.0, 30.0)];
        self.vorifyCodeText.placeholder = @"验证码";
        [self.vorifyCodeText setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        self.vorifyCodeText.textColor = [UIColor lightGrayColor];
        self.vorifyCodeText.textAlignment = NSTextAlignmentCenter;
        self.vorifyCodeText.keyboardType = UIKeyboardTypeNumberPad;
        self.vorifyCodeText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.view addSubview:self.vorifyCodeText];
        // icon
        UIImageView *vcodeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        vcodeIcon.image = [UIImage imageNamed:@"VerifyCode"];
        self.vorifyCodeText.leftView = vcodeIcon;
        self.vorifyCodeText.leftViewMode = UITextFieldViewModeAlways;
        // 线
        self.vorifyCodeImg = [[UIImageView alloc] initWithFrame:CGRectMake(50.0, TOP_Y + 252.0, [UIScreen mainScreen].bounds.size.width - 216.0, 2.0)];
        [self.view addSubview:self.vorifyCodeImg];
        self.vorifyCodeImg.image = [UIImage imageNamed:@"textfield_default_holo_light"];
        // 添加delegate
        self.vorifyCodeText.delegate = self;
        // 获取验证码Button
        self.getVeriftCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.getVeriftCodeBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 158.0, TOP_Y + 220.0, 100.0, 30.0);
        [self.getVeriftCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.getVeriftCodeBtn.backgroundColor = [UIColor colorWithRGBValue:0x12b4ed];
        self.getVeriftCodeBtn.clipsToBounds = YES;
        self.getVeriftCodeBtn.layer.cornerRadius = 6.4f;
        [self.getVeriftCodeBtn addTarget:self action:@selector(getVeriftCodeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.getVeriftCodeBtn];
        
        // 注册Button
        self.registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.registerBtn.frame = CGRectMake(72.0, TOP_Y + 276.0, [UIScreen mainScreen].bounds.size.width - 144.0, 44.0);
        [self.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        self.registerBtn.backgroundColor = [UIColor colorWithRGBValue:0x12b4ed];
        self.registerBtn.clipsToBounds = YES;
        self.registerBtn.layer.cornerRadius = 6.4f;
        [self.registerBtn addTarget:self action:@selector(registerBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.registerBtn];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.accountText.text = @"";
    self.passwordText.text = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 点击非输入区域退出输入状态
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

// 关闭注册页面回到登录页面
- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.view endEditing:YES];
}

- (void)registerBtnClicked {
    [self.view endEditing:YES];
    
    // 检验输入数据
    if (self.accountText.text.length == 0 || self.passwordText.text.length == 0) {
        [self.view makeToast:@"账号密码不能为空"];
        return;
    } else if (self.accountText.text.length != 11) {
        [self.view makeToast:@"账号格式不正确"];
        return;
    } else if (self.vorifyCodeText.text.length == 0) {
        [self.view makeToast:@"请输入验证码"];
    } else if (!([self.vorifyCodeText.text isEqualToString:self.verifyCode])) {
        [self.view makeToast:@"验证码错误"];
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[kApiUrl stringByAppendingPathComponent:[NSString stringWithFormat:@"User/register.html"]] parameters:@{@"tel" : self.accountText.text, @"password" : self.passwordText.text} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.view hideToastActivity];
        if ([responseObject[@"status"] integerValue] == 200) {
            [[User sharedUser].user setObject:responseObject[@"data"][@"token"] forKey:@"token"];
            [self.view makeToast:@"注册成功"];
            [NSThread sleepForTimeInterval:2];
            [self presentViewController:[[BaseViewController alloc] init] animated:YES completion:nil];
        } else {
            [self.view makeToast:responseObject[@"errorMsg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view hideToastActivity];
        NSLog(@"Faild:%@", [error localizedDescription]);
    }];
}

// 获取验证码
- (void)getVeriftCodeBtnClicked {
    [self.view endEditing:YES];
    
    // 检验输入数据
    if (self.accountText.text.length == 0) {
        [self.view makeToast:@"手机号不能为空"];
        return;
    } else if (self.accountText.text.length != 11) {
        [self.view makeToast:@"请输入正确的手机号"];
        return;
    }
    
    [self.view makeToastActivity:CSToastPositionCenter];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[kApiUrl stringByAppendingPathComponent:[NSString stringWithFormat:@"User/getVerifyCode/tel/%@.html", self.accountText.text]] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.view hideToastActivity];
        if ([responseObject[@"status"] integerValue] == 200) {
            [self.view makeToast:responseObject[@"data"]];
            self.verifyCode = responseObject[@"data"];
            
            // 开启重试倒计时
            self.countTime = 10;
            self.getVeriftCodeBtn.enabled = NO;
            self.getVeriftCodeBtn.backgroundColor = [UIColor grayColor];
            [self.getVeriftCodeBtn setTitle:[NSString stringWithFormat:@"%ds后再试", self.countTime] forState:UIControlStateNormal];
            
            NSTimer *countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(retryCountdown:) userInfo:nil repeats:YES];
            NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
            [runLoop addTimer:countDownTimer forMode:NSRunLoopCommonModes];
        } else {
            [self.view makeToast:responseObject[@"errorMsg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view hideToastActivity];
        NSLog(@"Faild:%@", [error localizedDescription]);
    }];

}

- (void)retryCountdown:(NSTimer *)countDownTimer {
    if (self.countTime == 0) {
        self.getVeriftCodeBtn.enabled = YES;
        [self.getVeriftCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.getVeriftCodeBtn.backgroundColor = [UIColor colorWithRGBValue:0x12b4ed];
        [countDownTimer invalidate];
        return;
    }
    
    [self.view hideToastActivity];
    [self.getVeriftCodeBtn setTitle:[NSString stringWithFormat:@"%ds后再试", --self.countTime] forState:UIControlStateNormal];
}

#pragma mark - TextFieldDelegate
// 点击输入框控件自动上滑到键盘以上
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGFloat offset = [UIScreen mainScreen].bounds.size.height - (self.accountText.frame.origin.y + self.passwordText.frame.size.height+ self.vorifyCodeText.frame.size.height + 216.0 + 152.0);
    if (offset < 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
    
    if (textField == self.accountText) {
        self.accountImg.image = [UIImage imageNamed:@"textfield_activated_holo_light"];
    } else if (textField == self.passwordText) {
        self.passwordImg.image = [UIImage imageNamed:@"textfield_activated_holo_light"];
    } else if (textField == self.vorifyCodeText) {
        self.vorifyCodeImg.image = [UIImage imageNamed:@"textfield_activated_holo_light"];
    }
}

// 退出输入状态控件回到原本位置
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }];
    
    if (textField == self.accountText) {
        self.accountImg.image = [UIImage imageNamed:@"textfield_default_holo_light"];
    } else if (textField == self.passwordText) {
        self.passwordImg.image = [UIImage imageNamed:@"textfield_default_holo_light"];
    } else if (textField == self.vorifyCodeText) {
        self.vorifyCodeImg.image = [UIImage imageNamed:@"textfield_default_holo_light"];
    }
    
    return YES;
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
