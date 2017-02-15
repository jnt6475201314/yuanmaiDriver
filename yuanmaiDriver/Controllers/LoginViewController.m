//
//  LoginViewController.m
//  SpecialLine
//
//  Created by 姜宁桃 on 2016/12/30.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "LoginViewController.h"
#import "TabBarViewController.h"
#import "RegisterViewController.h"
#import "ForgetViewController.h"

//#import "JVFloatingDrawerSpringAnimator.h"
//#import "HomeViewController.h"
//#import "PersonalCenterViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    UIImageView * _bgImageView;
    UIImageView * _logoImageView;
    UIImageView * _companyNameImgView;
    
    UITextField * _username_TF;
    UITextField * _password_TF;
    
    UIButton * _loginButton;
    UIButton * _registerButton;
    UIButton * _forgetButton;
}

@end

@implementation LoginViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self allViewAnimation];
}

- (void)allViewAnimation
{
    [UIView animateWithDuration:0.3 delay:0.2 usingSpringWithDamping:0.23 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
        
        _logoImageView.transform = CGAffineTransformMakeScale(1, 1);
        _companyNameImgView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
    
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.23 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        _username_TF.center = CGPointMake(screen_width/2, _username_TF.center.y);
    } completion:nil];
    [UIView animateWithDuration:0.25 delay:0.15 usingSpringWithDamping:0.23 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        _password_TF.center = CGPointMake(screen_width/2, _password_TF.center.y);
    } completion:nil];
    [UIView animateWithDuration:0.2 delay:0.2 usingSpringWithDamping:0.23 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        _loginButton.center = CGPointMake(screen_width/2, _loginButton.center.y);
    } completion:^(BOOL finished) {
        
//        [self checkLoginEvnet];  // 检查是否异地登录
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self configUI];
    
}

- (void)configUI{
    _bgImageView = [UIImageView imageViewWithFrame:screen_bounds image:@"backgroundImage"];
    [self.view addSubview:_bgImageView];
    
    _logoImageView = [UIImageView imageViewWithFrame:CGRectMake(screen_width/2-68*widthScale, 60*heightScale, 136*widthScale, 96*heightScale) image:@"yuanmaiLogo"];
    [self.view addSubview:_logoImageView];
    
    _companyNameImgView = [UIImageView imageViewWithFrame:CGRectMake(screen_width/2-60*widthScale, _logoImageView.bottom+10*heightScale, 120*widthScale, 30*heightScale) image:@"login_companyName_text"];
    [self.view addSubview:_companyNameImgView];
    
    UIImageView * userImgView = [UIImageView imageViewWithFrame:CGRectMake(10*widthScale, 10*heightScale, 20*widthScale, 20*heightScale) image:@"Login_TF_userImg"];
    UIView * userView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40*heightScale, 40*widthScale)];
    [userView addSubview:userImgView];
    _username_TF = [MYFactoryManager createTextField:CGRectMake(screen_width/2-132*widthScale, _companyNameImgView.bottom+40*heightScale, 264*widthScale, 40*heightScale) withLeftView:userView withPlaceholder:@"请输入登录账号" withDelegate:self];
    _username_TF.background = [UIImage imageNamed:@"login_TF_bgImg"];
    _username_TF.textColor = [UIColor whiteColor];
    [_username_TF setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _username_TF.returnKeyType = UIReturnKeyNext;
    _username_TF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_username_TF];
    
    UIImageView * pwdImgView = [UIImageView imageViewWithFrame:CGRectMake(10*widthScale, 10*heightScale, 20*widthScale, 20*heightScale) image:@"login_TF_pwdImg"];
    UIView * pwdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40*heightScale, 40*widthScale)];
    [pwdView addSubview:pwdImgView];
    _password_TF = [MYFactoryManager createTextField:CGRectMake(screen_width/2-132*widthScale, _username_TF.bottom+25*heightScale, 264*widthScale, 40*heightScale) withLeftView:pwdView withPlaceholder:@"请输入登录密码" withDelegate:self];
    _password_TF.background = [UIImage imageNamed:@"login_TF_bgImg"];
    _password_TF.textColor = [UIColor whiteColor];
    [_password_TF setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _password_TF.secureTextEntry = YES;
    _password_TF.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_password_TF];
    
    _loginButton = [UIButton buttonWithFrame:CGRectMake(screen_width/2-119*widthScale, _password_TF.bottom+50*heightScale, 238*widthScale, 38*heightScale) title:@"登 录" image:@"" target:self action:@selector(loginButtonEvent:)];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _loginButton.titleLabel.font = boldSystemFont(17);
    _loginButton.layer.cornerRadius = 15;
    _loginButton.clipsToBounds = YES;
    _loginButton.backgroundColor = red_color;
    [self.view addSubview:_loginButton];
    
    _registerButton = [UIButton buttonWithFrame:CGRectMake(_loginButton.left, _loginButton.bottom+5, 80, 40) title:@"注册" image:nil target:self action:@selector(registerButtonEvent:)];
    [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_registerButton];
    
    _forgetButton = [UIButton buttonWithFrame:CGRectMake(_loginButton.right-100, _loginButton.bottom+5, 100, 40) title:@"忘记密码？" image:nil target:self action:@selector(forgetButtonEvent:)];
    [_forgetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_forgetButton];
    
    _logoImageView.transform = CGAffineTransformMakeScale(0, 0);
    _companyNameImgView.transform = CGAffineTransformMakeScale(0, 0);
    _username_TF.center = CGPointMake(_username_TF.origin.x-screen_width, _username_TF.center.y);
    _password_TF.center = CGPointMake(_password_TF.origin.x-screen_width, _password_TF.center.y);
    _loginButton.center = CGPointMake(_loginButton.origin.x-screen_width, _loginButton.center.y);
    
    if ([UserDefaults objectForKey:@"userName"]) {
        NSString * tel = [UserDefaults objectForKey:@"userName"];
        NSLog(@"tel:%@", tel);
        _username_TF.text = tel;
        _password_TF.text = [UserDefaults objectForKey:tel];
        NSLog(@"account:%@password:%@", _username_TF.text, _password_TF.text);
    }
}

#pragma mark - Event Hander
- (void)loginButtonEvent:(UIButton *)loginBtn{
    
    loginBtn.center = CGPointMake(screen_width/2 - 30, loginBtn.center.y);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        loginBtn.center = CGPointMake(screen_width/2, loginBtn.center.y);
    } completion:^(BOOL finished) {
        
        if (_username_TF.text.length > 0 && _password_TF.text.length > 0) {
            
            [self loginNetWork];  // 登陆操作
        }else{
            [self showTipView:@"用户名或密码不能为空"];
        }
    }];
    
}

- (void)registerButtonEvent:(UIButton *)registerButton
{
    RegisterViewController * registerVC = [[RegisterViewController alloc] init];
//    [self.navigationController pushViewController:registerVC animated:YES];
    [self presentViewController:registerVC animated:YES completion:nil];
}

- (void)forgetButtonEvent:(UIButton *)forgetButton
{
    ForgetViewController * forgetVC = [[ForgetViewController alloc] init];
//    [self.navigationController pushViewController:forgetVC animated:YES];
    [self presentViewController:forgetVC animated:YES completion:nil];
}

- (void)loginNetWork{
    [self showHUD:@"正在登录，请稍候" isDim:YES];
    NSDictionary * params = @{@"user_name":_username_TF.text, @"password":_password_TF.text};
    NSLog(@"%@?user_name=%@&password=%@", API_LOGIN_URL, _username_TF.text, _password_TF.text);
    [NetRequest postDataWithUrlString:API_LOGIN_URL withParams:params success:^(id data) {
        
        [self hideHUD];
        NSLog(@"data：%@", data);
        if ([data[@"code"] isEqualToString:@"1"]) {
            // 登陆成功
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"登陆成功");
                [self showTipView:@"登录成功！"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self saveUserInfo:data];   // 存储用户信息
                });
            });
            
        }else if ([data[@"code"] isEqualToString:@"2"]){
            // 登陆失败
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showTipView:data[@"message"]];
            });
        }
    } fail:^(NSString *errorDes) {
        
        NSLog(@"%@", errorDes);
        [self hideHUD];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showTipView:@"登录失败，登录信息是否有误或网络出错"];
        });
    }];
}

// 存储用户信息
- (void)saveUserInfo:(NSDictionary *)data{
    [[NSUserDefaults standardUserDefaults] setObject:data[@"data"] forKey:@"data"];
    [UserDefaults setObject:data[@"aa"] forKey:@"token_str"];  // 存储token_str
    [UserDefaults setObject:_username_TF.text forKey:@"userName"];
    [UserDefaults setObject:_password_TF.text forKey:_username_TF.text];
    [UserDefaults synchronize];
    NSLog(@"存储信息成功！");
    NSString * username = [UserDefaults objectForKey:@"userName"];
    NSLog(@"username:%@ , pwd:%@", username, [UserDefaults objectForKey:username]);
    // 跳转到首页
    [self turnToTabBarVC];
}

- (void)turnToTabBarVC{
    TabBarViewController * tabBarVC = [[TabBarViewController alloc] init];
    AppDelegate * appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDele.window.rootViewController = tabBarVC;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _username_TF) {
        [_password_TF becomeFirstResponder];
    }else if (textField == _password_TF){
        [self.view endEditing:YES];
        if (_username_TF.text.length > 0 && _password_TF.text.length > 0) {
            
            [self loginNetWork];  // 登陆操作
        }else{
            [self showTipView:@"用户名或密码不能为空"];
        }
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==_username_TF) {
        // 避免崩溃
        if(range.length + range.location > textField.text.length){
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        // 设置限制长度
        return newLength <= 11;
    }else{
        // 避免崩溃
        if(range.length + range.location > textField.text.length){
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        // 设置限制长度
        return newLength <= 16;
    }
    return YES;
}


- (void)checkLoginEvnet
{
    NSLog(@"%@", GETTOKEN_Str);
    if (GETTOKEN_Str && !self.logOut) {
        // 如果有token缓存值，则开始检查登录状态
        [self showHUD:@"正在检查登录状态，请稍候。。。" isDim:YES];
        [NetRequest checkOtherPlaceLoginWithUrlString:CHECK_TokenStr_UrlStr withParams:@{@"str":GETTOKEN_Str} success:^(id data) {
            NSLog(@"%@", data);
            if ([data[@"code"] isEqualToString:@"101"]) {
                // 登陆正常
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self hideHUD];
                    [self showTipView:@"登录正常，即将跳转至首页"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self turnToTabBarVC];
                    });
                });
                
            }else
            {
                // 异地登陆
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self hideHUD];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self showTipView:@"检测到您的账号异地登录, 请重新登录！"];
                    });
                });
            }
        } fail:^(NSString *errorDes) {
            
            NSLog(@"%@", errorDes);
            [self hideHUD];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showTipView:@"检测失败，请检查当前网络状态"];
            });
        }];
    }
    
    // 否则不需要
    
}

- (void)configLocation
{
    NSLog(@"未登录，不发送地址信息");
}

#if 0
#pragma mark - Event Hander
- (void)loginButtonEvent:(UIButton *)loginBtn{
    loginBtn.center = CGPointMake(screen_width/2 - 30, loginBtn.center.y);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        loginBtn.center = CGPointMake(screen_width/2, loginBtn.center.y);
    } completion:^(BOOL finished) {
        
        if (_username_TF.text.length > 0 && _password_TF.text.length > 0) {
            
            [self loginNetWork];  // 登陆操作
        }else{
            [self showTipView:@"用户名或密码不能为空"];
        }
    }];
}

//  进行登陆账号密码网络验证操作
- (void)loginNetWork{
    [self showHUD:@"正在登录，请稍候" isDim:YES];
    NSDictionary * params = @{@"user_name":_username_TF.text, @"password":_password_TF.text};
    NSLog(@"%@?user_name=%@&password=%@", API_LOGIN_URL, _username_TF.text, _password_TF.text);
    [NetRequest postDataWithUrlString:API_LOGIN_URL withParams:params success:^(id data) {
        
        [self hideHUD];
        NSLog(@"data：%@", data);
        if ([data[@"code"] isEqualToString:@"1"]) {
            // 登陆成功
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"登陆成功");
                [self showTipView:@"登录成功！"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self saveUserInfo:data];   // 存储用户信息
                });
            });
            
        }else if ([data[@"code"] isEqualToString:@"2"]){
            // 登陆失败
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showTipView:data[@"message"]];
            });
        }
    } fail:^(NSString *errorDes) {
        
        NSLog(@"%@", errorDes);
        [self hideHUD];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showTipView:@"登录失败，登录信息是否有误或网络出错"];
        });
    }];
}

// 存储用户信息
- (void)saveUserInfo:(NSDictionary *)data{
    [[NSUserDefaults standardUserDefaults] setObject:data[@"data"] forKey:@"data"];
    [UserDefaults setObject:data[@"datas"][@"token_str"] forKey:@"token_str"];  // 存储token_str
    [UserDefaults setObject:_username_TF.text forKey:@"userName"];
    [UserDefaults setObject:_password_TF.text forKey:_username_TF.text];
    [UserDefaults synchronize];
    NSLog(@"存储信息成功！");
    // 跳转到首页
    [self setupDrawer];
}

- (void)setupDrawer
{
    PersonalCenterViewController *leftVC = [[PersonalCenterViewController alloc] init];
    UINavigationController *leftNav = [[UINavigationController alloc] initWithRootViewController:leftVC];

    HomeViewController *centerVC = [[HomeViewController alloc] init];
    UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:centerVC];
    
    // 实例化它
    JVFloatingDrawerViewController *drawer = [[JVFloatingDrawerViewController alloc] init];
    
    // 设置ViewController
    drawer.leftViewController = leftNav;
    drawer.leftDrawerWidth = screen_width * 0.618;
    
    //    drawer.rightViewController = rightVC;
    drawer.rightDrawerWidth = 100;
    
    drawer.centerViewController = centerNav;
    
    // 设置动画器
    JVFloatingDrawerSpringAnimator *springAnimator = [[JVFloatingDrawerSpringAnimator alloc] init];
    drawer.animator = springAnimator;
    
    // 设置背景图片
    drawer.backgroundImage = [UIImage imageNamed:@"login_bg_img"];
    
    AppDelegate * appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDele.window.rootViewController = drawer;
}

- (JVFloatingDrawerViewController *)drawerViewController
{
    return (JVFloatingDrawerViewController *)AppDelegateInstance.window.rootViewController;
}
#endif



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
