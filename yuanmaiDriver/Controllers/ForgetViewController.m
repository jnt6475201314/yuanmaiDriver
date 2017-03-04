//
//  ForgetViewController.m
//  yuanmaiDriver
//
//  Created by 姜宁桃 on 2017/1/29.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "ForgetViewController.h"

@interface ForgetViewController ()<UITextFieldDelegate>
{
    UITextField * _telNumberTF;
    UITextField * _passWordsTF;
    UITextField * _surePwdTF;
    UITextField * _verifyCodeTF;
    
    UIButton * _sureButton;
    JKCountDownButton * _codeBtn;
    
    UIButton * _seePwdBtn;
    UIButton * _seeSurePwdBtn;
    
    BOOL isPwdSecureTextEntry;
    BOOL isSurePwdSecureTextEntry;
}
@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"找回密码";
    [self showBackBtn];
    
    [self configUI];
}

- (void)configUI
{
    NSArray * phArr = @[@"请输入注册手机号", @"请输入验证码", @"请输入设置密码", @"请再次输入密码"];
    NSArray * titleArr = @[@" 手机号：", @" 验证码：", @" 设置密码：", @" 确认密码："];
    
    _codeBtn = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    _codeBtn.frame = CGRectMake(screen_width  - 140, 0, 100, 40);
    [_codeBtn addTarget:self action:@selector(codeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _codeBtn.titleLabel.font = systemFont(15);
    [_codeBtn setTitle:@"获取验证码 " forState:UIControlStateNormal];
    _codeBtn.enabled = NO;
    [_codeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    UIView * _seePwdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
    _seePwdBtn = [UIButton buttonWithFrame:CGRectMake(10, 12.5, 25, 15) title:@"" image:@"tf_eye_gray" target:self action:@selector(seePwdButtonEvent:)];
    [_seePwdView addSubview:_seePwdBtn];
    isPwdSecureTextEntry = YES;     // 密码不可见
    
    UIView * _seeSurePwdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
    _seeSurePwdBtn =  [UIButton buttonWithFrame:CGRectMake(10, 12.5, 25, 15) title:@"" image:@"tf_eye_gray" target:self action:@selector(seeSurePwdButtonEvent:)];
    [_seeSurePwdView addSubview:_seeSurePwdBtn];
    isSurePwdSecureTextEntry = YES;     // 确认密码不可见
    
    
    for (int i = 0; i < titleArr.count; i++) {
        UITextField * tf = [MYFactoryManager createTextField:CGRectMake(20, 100+i*(40+15*heightScale), screen_width-40, 40) withPlaceholder:phArr[i] withLeftViewTitle:titleArr[i] withLeftViewTitleColor:[UIColor darkGrayColor] withLeftFont:15 withLeftViewWidth:84*widthScale withDelegate:self];
        tf.layer.cornerRadius = 10;
        tf.clipsToBounds = YES;
        tf.layer.borderColor = [UIColor lightGrayColor].CGColor;
        tf.layer.borderWidth = 0.5f;
        tf.tag = 50+i;
        if (i == 0) {
            _telNumberTF = tf;
            _telNumberTF.keyboardType = UIKeyboardTypeNumberPad;
        }else if (i == 1){
            _verifyCodeTF = tf;
            _verifyCodeTF.keyboardType = UIKeyboardTypeNumberPad;
            _verifyCodeTF.rightView = _codeBtn;
            _verifyCodeTF.rightViewMode = UITextFieldViewModeAlways;
        }else if (i == 2){
            _passWordsTF = tf;
            _passWordsTF.secureTextEntry = YES;
            _passWordsTF.rightView = _seePwdView;
            _passWordsTF.rightViewMode = UITextFieldViewModeUnlessEditing;
        }else if (i == 3){
            _surePwdTF = tf;
            _surePwdTF.secureTextEntry = YES;
            _surePwdTF.rightView = _seeSurePwdView;
            _surePwdTF.rightViewMode = UITextFieldViewModeUnlessEditing;
        }
        [self.view addSubview:tf];
    }
    
    _sureButton = [UIButton buttonWithFrame:CGRectMake(20, screen_height - 60, screen_width - 40, 40) title:@"确认修改" image:nil target:self action:@selector(sureButtonEvent:)];
    _sureButton.backgroundColor = [UIColor lightGrayColor];
    _sureButton.layer.cornerRadius = 10;
    _sureButton.clipsToBounds = YES;
    _sureButton.enabled = NO;
    [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_sureButton];
}

#pragma  mark - Event Hander
-(void)backClick:(UIButton *)button
{
    [self.view endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)codeBtnClicked:(JKCountDownButton *)sender
{
//    [self.view endEditing:YES];
    if ([MYFactoryManager phoneNum:_telNumberTF.text]) {
        sender.enabled = NO;
        //button type要 设置成custom 否则会闪动
        [sender startCountDownWithSecond:30];
        
        [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
            
            NSString *title = [NSString stringWithFormat:@"%ld秒后重试",second];
            [countDownButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            return title;
        }];
        
        [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
            countDownButton.enabled = YES;
            [countDownButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            return @"重新获取 ";
        }];
        [self sendMessage];
    }else{
        [self showTipView:@"手机号码格式不正确"];
        _telNumberTF.text = nil;
        [_telNumberTF becomeFirstResponder];
    }
}

// 发送验证码数据请求
- (void)sendMessage{
    
    NSDictionary * params = @{@"user_name":_telNumberTF.text, @"type":@"siji"};
    NSLog(@"%@?user_name=%@", API_GetVerifyCode_URL, _telNumberTF.text);
    [NetRequest postDataWithUrlString:API_GetVerifyCode_URL withParams:params success:^(id data) {
        
        NSLog(@"%@", data);
        if ([data[@"code"] isEqualToString:@"1"]) {
            [self showTipView:data[@"message"]];
            [_verifyCodeTF becomeFirstResponder];
        }else if ([data[@"code"] isEqualToString:@"2"]) {
            if ([data[@"message"] isEqualToString:@"手机号码不存在"]) {
                [self showTipView:@"手机号码不存在，请重新输入"];
                _telNumberTF.text = nil;
                [_telNumberTF becomeFirstResponder];
            }else
            {
                [self showTipView:data[@"message"]];
            }
        }else{
            [self showTipView:data[@"message"]];
        }
    } fail:^(id errorDes) {
        
        [self showTipView:@"获取验证码失败！请检查网络状态或稍候重试。"];
        NSLog(@"获取验证码失败！error：%@", errorDes);
    }];
}

- (void)sureButtonEvent:(UIButton *)sureBtn
{
    if ([_passWordsTF.text isEqualToString:_surePwdTF.text]) {
        // 两次输入密码一致
        
        NSDictionary *params = @{@"user_name":_telNumberTF.text,@"password":_passWordsTF.text,@"code":_verifyCodeTF.text};
        NSLog(@"%@?%@", API_ForgetPasswords_URL, params);
        [self showHUD:@"修改中，请稍候。。。" isDim:YES];
        [NetRequest postDataWithUrlString:API_ForgetPasswords_URL withParams:params success:^(id data) {
            [self hideHUD];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([data[@"code"] isEqualToString:@"1"]) {
                    NSLog(@"修改成功！");
                    [self showTipView:@"修改密码成功！即将跳转至登陆页。"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                }else if ([data[@"code"] isEqualToString:@"2"]){
                    NSLog(@"修改失败！");
                    [self showTipView:data[@"message"]];
                }else
                {
                    [self showTipView:data[@"message"]];
                }
            });
            
        } fail:^(NSString *errorDes) {
            [self hideHUD];
            NSLog(@"error:%@", errorDes);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showTipView:@"修改密码失败！请检查网络设置或稍候再试。"];
            });
        }];
    }else
    {
        // 两次输入密码不一致
        [self showTipView:@"两次密码输入不一致，请重新输入！"];
        _passWordsTF.text = nil;
        _surePwdTF.text = nil;
        [_passWordsTF becomeFirstResponder];
    }
    
}

- (void)seePwdButtonEvent:(UIButton *)seePwdBtn
{
    if (isPwdSecureTextEntry) {
        isPwdSecureTextEntry = !isPwdSecureTextEntry;
        _passWordsTF.secureTextEntry = NO;
        [_seePwdBtn setBackgroundImage:[UIImage imageNamed:@"tf_eye_blue"] forState:UIControlStateNormal];
    }else
    {
        isPwdSecureTextEntry = !isPwdSecureTextEntry;
        _passWordsTF.secureTextEntry = YES;
        [_seePwdBtn setBackgroundImage:[UIImage imageNamed:@"tf_eye_gray"] forState:UIControlStateNormal];
    }
}

- (void)seeSurePwdButtonEvent:(UIButton *)seeSurePwdBtn
{
    if (isSurePwdSecureTextEntry) {
        isSurePwdSecureTextEntry = !isSurePwdSecureTextEntry;
        _surePwdTF.secureTextEntry = NO;
        [_seeSurePwdBtn setBackgroundImage:[UIImage imageNamed:@"tf_eye_blue"] forState:UIControlStateNormal];
    }else
    {
        isSurePwdSecureTextEntry = !isSurePwdSecureTextEntry;
        _surePwdTF.secureTextEntry = YES;
        [_seeSurePwdBtn setBackgroundImage:[UIImage imageNamed:@"tf_eye_gray"] forState:UIControlStateNormal];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.layer.borderColor = red_color.CGColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _surePwdTF) {
        [self.view endEditing:YES];
    }else{
        UITextField * tf = (UITextField *)[self.view viewWithTag:textField.tag + 1];
        [tf becomeFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self judgeInfo];
    if (textField == _telNumberTF) {
        if(_telNumberTF.text.length == 11){
            _codeBtn.enabled = YES;
            [_codeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }else{
        _codeBtn.enabled = NO;
        [_codeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
    return YES;
}

- (void)judgeInfo{
    if (_telNumberTF.text.length > 0 && _verifyCodeTF.text.length > 0 && _passWordsTF.text.length > 0 && _surePwdTF.text.length > 0) {
        _sureButton.enabled = YES;
        _sureButton.backgroundColor = red_color;
    }else
    {
        _sureButton.enabled = NO;
        _sureButton.backgroundColor = [UIColor lightGrayColor];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==_telNumberTF) {
        // 避免崩溃
        if(range.length + range.location > textField.text.length){
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        // 设置限制长度
        if (textField.text.length >= 11) {
            [_verifyCodeTF becomeFirstResponder];
        }
        return newLength <= 11;
    }else if(textField == _verifyCodeTF){
        // 避免崩溃
        if(range.length + range.location > textField.text.length){
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        // 设置限制长度
        return newLength <= 6;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkLoginEvnet
{
    
}

- (void)configLocation
{
    NSLog(@"未登录，不发送地址信息");
}

@end
