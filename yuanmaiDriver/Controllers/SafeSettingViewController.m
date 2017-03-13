//
//  SafeSettingViewController.m
//  SpecialLine
//
//  Created by 姜宁桃 on 2017/1/7.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "SafeSettingViewController.h"
#import "LoginViewController.h"

@interface SafeSettingViewController ()<UITextFieldDelegate>
{
    UIImageView * _logoImageView;   // logo图片
    
    UITextField * _telNumberTF;
    UITextField * _oldPasswordTF;
    UITextField * _passwordTF;
    UITextField * _surepwdTF;
    
    UIButton * _submitButton;
}
@property (nonatomic, strong) NSArray * tfplaceHoldArray;
@property (nonatomic, strong) NSArray * tfTitleArray;

@end

@implementation SafeSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"安全设置";
    [self showBackBtn];
    [self configUI];
}

- (void)configUI
{
    _logoImageView = [UIImageView imageViewWithFrame:CGRectMake(screen_width/2-68*widthScale*0.8, 64+25*heightScale, 136*widthScale*0.8, 96*heightScale*0.8) image:@"yuanmaiLogo"];
    [self.view addSubview:_logoImageView];
    
    
    for (int i = 0; i < self.tfTitleArray.count; i++) {
        UITextField * tf = [MYFactoryManager createTextField:CGRectMake(screen_width/2-120*widthScale, _logoImageView.bottom +25*heightScale+i*50*heightScale, 240*widthScale, 35*heightScale) withPlaceholder:self.tfplaceHoldArray[i] withLeftViewTitle:self.tfTitleArray[i] withLeftViewTitleColor:[UIColor darkGrayColor] withLeftFont:15 withLeftViewWidth:84*widthScale withDelegate:self];
        tf.layer.cornerRadius = 17*widthScale;
        tf.clipsToBounds = YES;
        tf.layer.borderColor = [UIColor lightGrayColor].CGColor;
        tf.layer.borderWidth = 1;
        tf.textColor = [UIColor darkTextColor];
        tf.tag = 50+i;
        switch (i) {
            case 0:
            {
                _telNumberTF = tf;
                NSDictionary * data = [UserDefaults objectForKey:@"data"];
                NSLog(@"%@", data);
                _telNumberTF.text = data[@"user_name"];
                _telNumberTF.enabled = NO;
                break;
            }
            case 1:
                _oldPasswordTF = tf;
                _oldPasswordTF.returnKeyType = UIReturnKeyNext;
                _oldPasswordTF.secureTextEntry = YES;
                break;
            case 2:
                _passwordTF = tf;
                _passwordTF.secureTextEntry = YES;
                _passwordTF.returnKeyType = UIReturnKeyNext;
                break;
            case 3:
                _surepwdTF = tf;
                _surepwdTF.secureTextEntry = YES;
                _surepwdTF.returnKeyType = UIReturnKeyDone;
                break;
                
            default:
                break;
        }
        
        [self.view addSubview:tf];
    }
    
    _submitButton = [UIButton buttonWithFrame:CGRectMake(screen_width/2-120*widthScale, _surepwdTF.bottom +30*heightScale, 240*widthScale, 40*heightScale) title:@"确定修改" image:nil target:self action:@selector(submitButtonEvnet:)];
    _submitButton.backgroundColor = [UIColor grayColor];// color(23, 199, 189, 1);
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitButton.titleLabel.font = boldSystemFont(17);
    _submitButton.layer.cornerRadius = 20*heightScale;
    _submitButton.clipsToBounds = YES;
    _submitButton.enabled = NO;
    [self.view addSubview:_submitButton];
    
}

#pragma mark - Event Hander
- (void)submitButtonEvnet:(UIButton *)btn
{
    _submitButton.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        _submitButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
        if ([_passwordTF.text isEqualToString:_surepwdTF.text]) {
            if ([_passwordTF.text isEqualToString:_oldPasswordTF.text]) {
                [self showTipView:@"新密码不能跟旧密码一致，请重新输入！"];
                _passwordTF.text = nil;
                _surepwdTF.text = nil;
                [_passwordTF becomeFirstResponder];
            }else
            {
                // 两次密码输入一致，进行修改
                [self NetWorkOfUpdatePazxssWord];     // 修改密码的网络请求
            }
        }else
        {
            [self showTipView:@"两次输入的新密码不一致，请重新输入！"];
            _passwordTF.text = nil;
            _surepwdTF.text = nil;
            [_passwordTF becomeFirstResponder];
        }
        
    }];
}

- (void)NetWorkOfUpdatePazxssWord
{
    [self.view endEditing:YES];
    
    NSDictionary *params = @{@"user_name":_telNumberTF.text,@"pwd":_oldPasswordTF.text,@"password":_passwordTF.text,@"state":@2};
    NSLog(@"%@?%@", API_UPDATEPWD_URL, params);
    [self showHUD:@"密码修改中，请稍候。。。" isDim:YES];
    [NetRequest postDataWithUrlString:API_UPDATEPWD_URL withParams:params success:^(id data) {
        NSLog(@"%@", data);
        [self hideHUD];
        if ([data[@"code"] isEqualToString:@"1"]) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showTipView:@"修改成功！即将跳转到登录界面重新登录。"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    LoginViewController * loginVC = [[LoginViewController alloc] init];
                    loginVC.logOut = @"YES";
                    AppDelegateInstance.window.rootViewController = loginVC;
                });
            });
        }else if ([data[@"code"] isEqualToString:@"2"]){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showTipView:data[@"message"]];
            });
        }
    } fail:^(id errorDes) {
        
        NSLog(@"%@", errorDes);
        [self hideHUD];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showTipView:@"修改密码出错，请检查网络是否正常或联系客服"];
        });
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _oldPasswordTF || textField == _passwordTF || textField == _telNumberTF) {
        UITextField * tf = (UITextField *)[self.view viewWithTag:textField.tag + 1];
        [tf becomeFirstResponder];
    }else if (textField == _surepwdTF)
    {
        [self.view endEditing:YES];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _telNumberTF) {
        // 避免崩溃
        if(range.length + range.location > textField.text.length){
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        // 设置限制长度
        return newLength <= 11;
    }
    // 避免崩溃
    if(range.length + range.location > textField.text.length){
        return NO;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    // 设置限制长度
    return newLength < 16;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.textColor == [UIColor darkTextColor]) {
        textField.textColor = color(23, 199, 189, 1);
        textField.layer.borderColor = color(23, 199, 189, 1).CGColor;
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.textColor != [UIColor darkTextColor]) {
        textField.textColor = [UIColor darkTextColor];
        textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    [self JudgeAllData];
}

// 判断所有数据是否完整
- (void)JudgeAllData
{
    if (_telNumberTF.text.length > 0 && _oldPasswordTF.text.length > 0 && _passwordTF.text.length > 0 && _surepwdTF.text.length > 0) {
        // 都不为空
        [UIView animateWithDuration:0.2 animations:^{
            
            _submitButton.backgroundColor = color(23, 199, 189, 1);
            _submitButton.enabled = YES;
        }];
    }else
    {
        [UIView animateWithDuration:0.2 animations:^{
            
            _submitButton.backgroundColor = [UIColor grayColor];
            _submitButton.enabled = NO;
        }];
    }
}



#pragma mark - Getter
- (NSArray *)tfTitleArray
{
    if (!_tfTitleArray) {
        _tfTitleArray = @[@"  手机号：",@"  旧密码：", @"  新密码：", @" 确认密码："];
    }
    return _tfTitleArray;
}

-(NSArray *)tfplaceHoldArray
{
    if (!_tfplaceHoldArray) {
        _tfplaceHoldArray = @[@"请输入手机号码",@"请输入旧密码", @"请输入新密码", @"请再次输入新密码"];
    }
    return _tfplaceHoldArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backClick:(UIButton *)button
{
    [self addAnimationWithType:TAnimationMoveIn Derection:FAnimationFromLeft];
   [self.navigationController popViewControllerAnimated:YES];
}

@end
