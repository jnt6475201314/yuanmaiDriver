//
//  BaseViewController.m
//  YouLX
//
//  Created by king on 15/12/12.
//  Copyright © 2015年 feiwei. All rights reserved.
//

#import "BaseViewController.h"
#import <UMSocialQQHandler.h>
#import <UMSocialWechatHandler.h>
#import <UMSocialSinaHandler.h>
#import <UMSocialSinaSSOHandler.h>
#import "TabBarViewController.h"

@interface BaseViewController ()<UMSocialUIDelegate>
//加载视图
@property (nonatomic,strong)UILabel *tipLabel;

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.toolbar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    
    TabBarViewController *tabVC = (TabBarViewController *)self.tabBarController;
    if (self.navigationController.viewControllers.count > 1) {
        [tabVC showTabbar:NO];
    }else {
        [tabVC showTabbar:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavView];
    
    if (iOS7Later) { // 判断是否是IOS7
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
    
    if ([GetRELOGINStatus isEqualToString:@"YES"]) {
        [self checkLoginEvnet];     // 允许检测异地登录
    }
    
    // 获取位置信息
    [self configLocation];
}

- (void)initNavView{
    //创建主视图包含基础视图
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, screen_width, screen_height-20)];
    //创建背景视图
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_width, backView.frame.size.height)];
    _backImageView.backgroundColor = background_color;
    [backView addSubview:_backImageView];
    [self.view addSubview:backView];
    
    //自定义导航栏视图
    _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 64)];
    _navView.backgroundColor = red_color;
    _sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 63, screen_width, 1)];
    _sepView.backgroundColor = sepline_color;
    [_navView addSubview:_sepView];
    //标题视图
    _titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    _titleView.frame = CGRectMake(0, 0, 30, 24);
    _titleView.center = CGPointMake(screen_width/2, 20+22);
    [_navView addSubview:_titleView];
    //标题名
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((screen_width-200)/2, 24, 200, 36)];
    _titleLabel.textAlignment = 1;
    _titleLabel.font = [UIFont systemFontOfSize:20.0f];
    _titleLabel.textColor = [UIColor whiteColor];
    [_navView addSubview:_titleLabel];
    [self.view addSubview:_navView];
    
    //输入提示框
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screen_width, 30)];
    _tipLabel.textColor = [UIColor whiteColor];
    _tipLabel.backgroundColor = color(0, 0, 0, 0.7);
    _tipLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _tipLabel.layer.cornerRadius = 5;
    _tipLabel.clipsToBounds = YES;
    _tipLabel.textAlignment = 1;
}

#pragma mark -- 创建控件
//------默认的右边按钮-------
- (void)showRightBtn {
    if (_rightButton == nil) {
        //基础控件的初始化
        _rightButton = [MyPicButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setFrame:CGRectMake(screen_width-45, 24, 40, 36)];
        [_rightButton setBtnViewWithImage:@"" withImageWidth:30 withTitle:@"" withTitleColor:[UIColor whiteColor] withFont:systemFont(17.0f)];
        [_rightButton setOnlyText];
        [_rightButton addTarget:self action:@selector(navRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:_rightButton];
    }
}
//------自定义的右边按钮(图片)-------
- (void)showRightBtn:(CGRect)rightBtnFrame withImage:(NSString *)imageName withImageWidth:(float)imageWidth{
    if (_rightButton == nil) {
        //基础控件的初始化
        _rightButton = [MyPicButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setFrame:rightBtnFrame];
        [_rightButton setBtnViewWithImage:imageName withImageWidth:imageWidth withTitle:@"" withTitleColor:[UIColor whiteColor] withFont:systemFont(17.0f)];
        [_rightButton addTarget:self action:@selector(navRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:_rightButton];
    }
}
//------自定义的右边按钮(文字)-------
- (void)showRightBtn:(CGRect)rightBtnFrame withFont:(UIFont *)font withTitle:(NSString *)title withTitleColor:(UIColor *)titleColor{
    if (_rightButton == nil) {
        //基础控件的初始化
        _rightButton = [MyPicButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setFrame:rightBtnFrame];
        [_rightButton setBtnViewWithImage:@"" withImageWidth:1 withTitle:title withTitleColor:titleColor withFont:font];
//        _rightButton.picPlacement = 2;
        [_rightButton setOnlyText];
        [_rightButton addTarget:self action:@selector(navRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:_rightButton];
    }
}

//当push的时候显示返回按钮
//------默认的返回按钮-------
- (void)showBackBtn {
    if (_backButton == nil) {
        _backButton = [MyPicButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(10, 24, 55, 36);
        _backButton.imageDistant = 0;
        [_backButton setBtnViewWithImage:@"backImg" withImageWidth:25 withTitle:@"" withTitleColor:[UIColor whiteColor] withFont:systemFont(17.0f)];
        [_backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:_backButton];
    }
    //    _titleView.left = _backButton.right;
}
//------自定义的返回按钮(图片)-------
- (void)showBackBtn:(CGRect)rightBtnFrame withImage:(NSString *)imageName withImageWidth:(float)imageWidth {
    if (_backButton == nil) {
        //基础控件的初始化
        _backButton = [MyPicButton buttonWithType:UIButtonTypeCustom];
        [_backButton setFrame:rightBtnFrame];
        [_backButton setBtnViewWithImage:imageName withImageWidth:imageWidth withTitle:@"" withTitleColor:[UIColor whiteColor] withFont:systemFont(17.0f)];
        [_backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:_backButton];
    }
}
//------自定义的返回按钮(文字)-------
- (void)showBackBtn:(CGRect)rightBtnFrame withFont:(UIFont *)font withTitle:(NSString *)title withTitleColor:(UIColor *)titleColor {
    if (_backButton == nil) {
        //基础控件的初始化
        _backButton = [MyPicButton buttonWithType:UIButtonTypeCustom];
        [_backButton setFrame:rightBtnFrame];
        [_backButton setBtnViewWithImage:@"" withImageWidth:1 withTitle:title withTitleColor:titleColor withFont:font];
        [_backButton setOnlyText];
        [_backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:_backButton];
    }
}
//------默认的其他按钮-------
- (void)showOtherBtn {
    if (_otherButton == nil) {
        //基础控件的初始化
        _otherButton = [MyPicButton buttonWithType:UIButtonTypeCustom];
        [_otherButton setFrame:CGRectMake(screen_width-80, 27, 30, 30)];
        [_otherButton setBtnViewWithImage:@"" withImageWidth:30 withTitle:@"" withTitleColor:[UIColor whiteColor] withFont:systemFont(17.0f)];
        [_otherButton addTarget:self action:@selector(navOtherBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:_otherButton];
    }
}

#pragma 加载框
- (void)showHUD:(NSString *)title isDim:(BOOL)isDim{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = title;
    self.hud.dimBackground = isDim;
}

- (void)showHUDComplete:(NSString *)title{
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.labelText = title;
    [self.hud hide:YES afterDelay:1];
}
- (void)hideHUD
{
    [self.hud hide:YES];
}

#pragma 提示框
- (void)showTipView:(NSString *)tipStr {
    if (![_tipLabel superview]) {
        [_tipLabel removeFromSuperview];
        _tipLabel.text = tipStr;
        CGSize size = [_tipLabel sizeThatFits:CGSizeMake(MAXFLOAT, 30)];
        _tipLabel.width = size.width+30;
        _tipLabel.center = CGPointMake(screen_width/2, screen_height/2);
        [self.view addSubview:_tipLabel];
    }
    [_tipLabel performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];
}

#pragma 导航栏按钮事件
//左边
- (void)backClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}
//右边
- (void)navRightBtnClick:(UIButton *)button {
    
}
//其他
- (void)navOtherBtnClick:(UIButton *)button {
    
}


#pragma 分享事件
- (void)shareQQAndWechat:(NSString *)urlStr {
    [UMSocialWechatHandler setWXAppId:WEIXIN_ID appSecret:WEIXIN_KEY url:urlStr];
    [UMSocialQQHandler setQQWithAppId:YOUMENG_QQ_ID appKey:YOUMENG_QQ_KEY url:urlStr];
}
//控制器
- (void)shareController:(NSString *)shareText withImage:(NSString *)shareImage {
    [UMSocialSnsService presentSnsController:self appKey:YOUMENG_APPKEY shareText:shareText shareImage:[UIImage imageNamed:shareImage] shareToSnsNames:@[UMShareToWechatSession,UMShareToQQ,UMShareToWechatTimeline,UMShareToSina] delegate:self];
}
//活动视图
- (void)shareSheetView:(NSString *)shareText withImage:(NSString *)shareImage {
    [UMSocialSnsService presentSnsIconSheetView:self appKey:YOUMENG_APPKEY shareText:shareText shareImage:[UIImage imageNamed:shareImage] shareToSnsNames:@[UMShareToWechatSession,UMShareToQQ,UMShareToWechatTimeline,UMShareToSina] delegate:self];
}
//分享
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //分享成功操作
    if (response.responseCode == UMSResponseCodeSuccess) {
        [self showTipView:@"分享成功"];
    } else if(response.responseCode != UMSResponseCodeCancel) {
        [self showTipView:@"分享失败"];
    }
}

-(BOOL)closeOauthWebViewController:(UINavigationController *)navigationCtroller socialControllerService:(UMSocialControllerService *)socialControllerService{
    
    
    return NO;
}
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerTyp {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)checkLoginEvnet{
    
    if (GETTOKEN_Str) {
        [NetRequest checkOtherPlaceLoginWithUrlString:CHECK_TokenStr_UrlStr withParams:@{@"str":GETTOKEN_Str} success:^(id data) {
            NSLog(@"%@", data);
            if ([data[@"code"] isEqualToString:@"101"]) {
                // 登陆正常
            }else
            {
                // 异地登陆
                [self showReloginAlertView];
            }
        } fail:^(NSString *errorDes) {
            
            NSLog(@"%@", errorDes);
        }];
    }
    
}

- (void)showReloginAlertView{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"安全提示" message:@"检测到您的账号在其他地方登陆，请重新登陆并检查账户是否安全！" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    UIAlertAction * callAction = [UIAlertAction actionWithTitle:@"重新登陆" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self turnToLoginVC];
    }];
    [alertController addAction:callAction];
}

//- (void)checkNotification
//{
//    if (![MYFactoryManager isAllowedNotification]) {
//        // 不允许
//        [UserDefaults setObject:@"NO" forKey:NOTIFICATION];
//        [UserDefaults synchronize];
//    }else
//    {
//        [UserDefaults setObject:@"YES" forKey:NOTIFICATION];
//        [UserDefaults synchronize];
//    }
//}

- (void)turnToLoginVC{
    LoginViewController * loginVC = [[LoginViewController alloc] init];
    AppDelegateInstance.window.rootViewController = loginVC;
}



/**
 *  添加翻页动画
 *
 *  @param type      翻页类型
 *  @param direction 翻页反向
 */
- (void)addAnimationWithType:(NSString *)type Derection:(NSString *)direction{
    CATransition * animation = [CATransition animation];
    animation.duration = 0.4;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = type;
    animation.subtype = direction;
    [self.view.window.layer addAnimation:animation forKey:@"animation"];
}

- (void)configLocation{
    // 初始化定位服务
    [self allocCLLocationManager];
    
    [self.locationManager requestAlwaysAuthorization];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusNotDetermined) {
            UIAlertView *alvertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"需要您开启定位服务,请到设置->隐私,打开定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alvertView show];
        }
        else if (status == kCLAuthorizationStatusAuthorizedAlways ||
                 status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            
            [self.locationManager startUpdatingLocation];
        }
        else {
            UIAlertView *alvertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"定位服务授权失败,请检查您的定位设置!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alvertView show];
        }
    });
    
}

#pragma mark - CLLocationManager

- (void)allocCLLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    // 设置定位的精确度和更新频率
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 1000.0f;
    
    self.locationManager.delegate = self;
    // 授权状态是没有做过选择
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];  // 后台也可以定位
    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue] > 9)
    {
        /** iOS9新特性：将允许出现这种场景：同一app中多个location manager：一些只能在前台定位，另一些可在后台定位（并可随时禁止其后台定位）。 */
        [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    }
}

#pragma mark -  定位代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //得到newLocation
    CLLocation *loc = [locations objectAtIndex:0];
    
    NSMutableDictionary * location = [[NSMutableDictionary alloc] init];
    NSString * _longitude = [NSString stringWithFormat:@"%f", loc.coordinate.longitude];
    NSString * _latitude = [NSString stringWithFormat:@"%f", loc.coordinate.latitude];
    
    [location setObject:_longitude forKey:@"longitude"];
    [location setObject:_latitude forKey:@"latitude"];
    NSLog(@"经纬度  %f  %f ",loc.coordinate.latitude,loc.coordinate.longitude);
//    [self showTipView:[NSString stringWithFormat:@"经度：%@, 纬度：%@", _longitude, _latitude]];
    
    [UserDefaults setObject:location forKey:LOCATION];
    [UserDefaults synchronize];
    
    [self uploadMyLocationToService];
//    [self.locationManager stopUpdatingLocation];
}

// 上传我的位置信息到后台服务端
- (void)uploadMyLocationToService
{
    if ([UserDefaults objectForKey:@"data"][@"driver_id"] && [UserDefaults objectForKey:LOCATION] && [GetLocationDict objectForKey:@"longitude"] && [GetLocationDict objectForKey:@"latitude"]) {
        NSDictionary * locationParams = @{@"sid":GETDriver_ID, @"longitude":GetLongitude, @"latitude":GetLatitude};
        NSLog(@"%@?%@", API_UPLoadLocation_URL, locationParams);
        [NetRequest postDataWithUrlString:API_UPLoadLocation_URL withParams:locationParams success:^(id data) {
            
            NSLog(@"位置信息上传：data：%@", data);
            if ([data[@"code"] isEqualToString:@"1"]) {
//                [self showTipView:@"上传位置信息成功！"];
                NSLog(@"上传位置信息成功！message：%@", data[@"message"]);
            }else if ([data[@"code"] isEqualToString:@"2"]){
//                [self showTipView:[NSString stringWithFormat:@"上传位置信息成功！message：%@", data[@"message"]]];
            }else
            {
//                [self showTipView:[NSString stringWithFormat:@"上传位置信息成功！message：%@", data[@"message"]]];
            }
        } fail:^(NSString *errorDes) {
            
//            [self showTipView:@"上传位置信息失败！请检查当前网络状态或位置权限。"];
            NSLog(@"上传位置信息失败！原因：%@", errorDes);
        }];
    }
}

// 定位失败的方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失败：%@", error);
}

// 授权状态改变的方法
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"AuthorizationStatus:%d", status);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
