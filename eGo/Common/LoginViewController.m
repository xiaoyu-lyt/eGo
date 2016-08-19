//
//  LoginViewController.m
//  eGo
//
//  Created by 萧宇 on 7/26/16.
//  Copyright © 2016 萧宇. All rights reserved.
//

#import "LoginViewController.h"
#import "BaseViewController.h"
#import "RegisterViewController.h"

#import "User.h"
#import "Util.h"
#import "AFNetworking.h"

#define TOP_Y [UIScreen mainScreen].bounds.size.height * 0.2

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *accountText;
@property (nonatomic, strong) UIImageView *accountImg;
@property (nonatomic, strong) UITextField *passwordText;
@property (nonatomic, strong) UIImageView *passwordImg;
@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation LoginViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 设置背景图片
        UIImageView *backgroundImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background"]];
        backgroundImg.frame = [UIScreen mainScreen].bounds;
        [self.view insertSubview:backgroundImg atIndex:0];
        
        // 设置背景的模糊效果
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.alpha = .92f;
        blurEffectView.frame = [UIScreen mainScreen].bounds;
        [self.view insertSubview:blurEffectView aboveSubview:backgroundImg];
        
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
        
        // 登录Button
        self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.loginBtn.frame = CGRectMake(72.0, TOP_Y + 220.0, [UIScreen mainScreen].bounds.size.width - 144.0, 44.0);
        [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        self.loginBtn.backgroundColor = [UIColor colorWithRGBValue:0x12b4ed];
        self.loginBtn.clipsToBounds = YES;
        self.loginBtn.layer.cornerRadius = 6.4f;
        [self.loginBtn addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.loginBtn];
        
        // 注册与忘记密码
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height - 50.0, [UIScreen mainScreen].bounds.size.width, 44.0)];
        [self.view addSubview:bottomView];
        
        UILabel *registerLbl = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100.0, 4.0, 100.0, 36.0)];
        registerLbl.text = @"用户注册";
        registerLbl.textAlignment = NSTextAlignmentCenter;
        registerLbl.userInteractionEnabled = YES;
        UITapGestureRecognizer *registerTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registerTapped)];
        [registerLbl addGestureRecognizer:registerTapped];
        [bottomView addSubview:registerLbl];
        
        UILabel *orLbl = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 4.0, 4.0, 8.0, 36.0)];
        orLbl.text = @"|";
        orLbl.textAlignment = NSTextAlignmentCenter;
        [bottomView addSubview:orLbl];
        
        UILabel *forgetPasswordLbl = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 + 4.0, 4.0, 100.0, 36.0)];
        forgetPasswordLbl.text = @"忘记密码";
        forgetPasswordLbl.textAlignment = NSTextAlignmentCenter;
        [bottomView addSubview:forgetPasswordLbl];
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

// 点击登录Button后触发事件
- (void)loginButtonClicked:(UIButton *)sender {
    [self.view endEditing:YES];
    
    // 检验输入数据
    if (self.accountText.text.length == 0 || self.passwordText.text.length == 0) {
        [self.view makeToast:@"账号密码不能为空"];
        return;
    } else if (self.accountText.text.length != 11) {
        [self.view makeToast:@"账号格式不正确"];
        return;
    }
    
    [self.view makeToastActivity:CSToastPositionCenter];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[kApiUrl stringByAppendingPathComponent:@"login.html"] parameters:@{@"tel" : self.accountText.text, @"password" : self.passwordText.text} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.view hideToastActivity];
        [[User sharedUser].user setObject:responseObject[@"token"] forKey:@"token"];
        [[User sharedUser].user setObject:self.accountText.text forKey:@"tel"];
        [self presentViewController:[[BaseViewController alloc] init] animated:YES completion:^{
            [[User sharedUser] updateUserInfo];
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view hideToastActivity];
        switch (((NSHTTPURLResponse *)task.response).statusCode) {
            case 400:
                [self.view makeToast:@"账号或密码错误"];
                break;
            case 404:
                [self.view makeToast:@"该账号未注册"];
                break;
            default:
                break;
        }
    }];
}

// 点击用户注册Label后触发事件
- (void)registerTapped {
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[RegisterViewController alloc] init]] animated:YES completion:nil];
}

// 点击忘记密码Label后触发事件
- (void)forgetPasswordTapped {
    NSLog(@"forget password tapped");
}

#pragma mark - TextFieldDelegate
// 点击输入框控件自动上滑到键盘以上
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGFloat offset = [UIScreen mainScreen].bounds.size.height - (self.accountText.frame.origin.y + self.passwordText.frame.size.height + 216.0 + 128.0);
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
