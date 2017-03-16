//
//  AppDelegate.m
//  yuanmaiDriver
//
//  Created by 姜宁桃 on 2017/1/26.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LoginViewController.h"
#import "TabBarViewController.h"
#import "BGTask.h"
#import "BGLogation.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<btnClickDelegate, JPUSHRegisterDelegate>
@property (strong , nonatomic) BGTask *task;
@property (strong , nonatomic) NSTimer *bgTimer;
@property (strong , nonatomic) BGLogation *bgLocation;
@property (strong , nonatomic) CLLocationManager *location;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [NSThread sleepForTimeInterval:1];//设置启动页面时间
    [self configLocation];  // 集成位置
    [self configAPNsWithOptions:launchOptions]; // 注册通知
    
    //启动app---检查是否是首次启动此app
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id haveOpen = [defaults objectForKey:@"firstOpen"];
    if (![haveOpen boolValue]) {
        ViewController *vc = [[ViewController alloc] init];
        vc.clickDelegate = self;
        self.window.rootViewController = vc;
        [defaults setValue:@"YES" forKey:@"firstOpen"];
        [UserDefaults setObject:@"YES" forKey:RELOGIN];
        [UserDefaults synchronize];
    }else {
        
        [self checkLoginEvnet];
    }
    
    return YES;
}

- (void)configLocation
{
//    _task = [BGTask shareBGTask];
    UIAlertView *alert;
    //判断定位权限
    if([UIApplication sharedApplication].backgroundRefreshStatus == UIBackgroundRefreshStatusDenied)
    {
        alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"应用没有不可以定位，需要在在设置/通用/后台应用刷新开启" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([UIApplication sharedApplication].backgroundRefreshStatus == UIBackgroundRefreshStatusRestricted)
    {
        alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不可以定位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        self.bgLocation = [[BGLogation alloc]init];
        [self.bgLocation startLocation];
//        [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(log) userInfo:nil repeats:YES];
    }

}

-(void)log
{
    NSLog(@"执行 上传我的位置信息到后台服务端");
    [self uploadMyLocationToService];
}

// 上传我的位置信息到后台服务端
- (void)uploadMyLocationToService
{
    if ([UserDefaults objectForKey:@"data"][@"driver_id"] && [UserDefaults objectForKey:LOCATION] && [GetLocationDict objectForKey:@"longitude"] && [GetLocationDict objectForKey:@"latitude"]) {
        NSDictionary * locationParams = @{@"sid":GETDriver_ID,@"mobile":[UserDefaults objectForKey:@"data"][@"user_name"], @"longitude":GetLongitude, @"latitude":GetLatitude};
        NSLog(@"%@?%@", API_UPLoadLocation_URL, locationParams);
        [NetRequest postDataWithUrlString:API_UPLoadLocation_URL withParams:locationParams success:^(id data) {
            
            NSLog(@"位置信息上传：data：%@", data);
            if ([data[@"code"] isEqualToString:@"1"]) {
                
                NSLog(@"上传位置信息成功！message：%@", data[@"message"]);
            }else if ([data[@"code"] isEqualToString:@"2"]){
                
                NSLog(@"上传位置信息成功！message：%@", data[@"message"]);
            }else
            {
                NSLog(@"上传位置信息成功！message：%@", data[@"message"]);
            }
        } fail:^(NSString *errorDes) {
            
            NSLog(@"上传位置信息失败！原因：%@", errorDes);
        }];
    }
}

-(void)startBgTask
{
    [_task beginNewBackgroundTask];
}

- (void)checkLoginEvnet
{
    NSLog(@"%@", GETTOKEN_Str);
    if (GETTOKEN_Str) {
        // 如果有token缓存值，则开始检查登录状态
        [NetRequest checkOtherPlaceLoginWithUrlString:CHECK_TokenStr_UrlStr withParams:@{@"str":GETTOKEN_Str} success:^(id data) {
            NSLog(@"%@", data);
            if ([data[@"code"] isEqualToString:@"101"]) {
                // 登陆正常
                [self turnToTabBarVC];
            }else
            {
                // 异地登陆
                [self initLoginVC];
            }
        } fail:^(NSString *errorDes) {
            
            NSLog(@"%@", errorDes);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{             
                [self initLoginVC];
            });
        }];
    }else
    {
        [self initLoginVC];
    }
    
}

- (void)turnToTabBarVC{
    TabBarViewController * tabBarVC = [[TabBarViewController alloc] init];
    AppDelegate * appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDele.window.rootViewController = tabBarVC;
}


- (void)btnhaveClicked{
    [self initLoginVC];
}

- (void)initLoginVC {
    self.window.rootViewController = nil;
    for (UIView *view in self.window.subviews) {
        [view removeFromSuperview];
    }
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [UIView animateWithDuration:0.5 animations:^{
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        self.window.rootViewController = loginVC;
    }];
}

- (void)configAPNsWithOptions:(NSDictionary *)launchOptions
{
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey
                          channel:JPushChannel
                 apsForProduction:YES];
    
}

#pragma mark - JPUSHRegisterDelegate
// 注册APNs成功并上报 DeviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    NSLog(@"%@", deviceToken);
    [JPUSHService registerDeviceToken:deviceToken];
    
    NSLog(@"deviceToken:%@",deviceToken);
    NSString *deviceTokenStr = [[[[deviceToken description]
                                  stringByReplacingOccurrencesOfString:@"<" withString:@""]
                                 stringByReplacingOccurrencesOfString:@">" withString:@""]
                                stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceTokenStr:%@",deviceTokenStr);
    if (deviceToken) {
        [UserDefaults setObject:deviceTokenStr forKey:@"deviceToken"];
        [UserDefaults synchronize];
    }else
    {
        [UserDefaults setObject:@"" forKey:@"deviceToken"];
        [UserDefaults synchronize];
    }
}
// 实现注册APNs失败接口
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required     应用正在打开使用时，收到通知会进入这里
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSLog(@"iOS 10 Support userInfo:%@", userInfo);
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(nil); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    
    self.bgLocation = [[BGLogation alloc]init];
    [self.bgLocation startLocation];
//    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(log) userInfo:nil repeats:YES];
//    [self startBgTask];
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required     通过点击通知打开程序的时候会进入这里
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"iOS 10 Support userInfo:%@", userInfo);
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
    [MYFactoryManager uploadMyLocationToService];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    // 取得 APNs 标准信息内容
    
    [MYFactoryManager uploadMyLocationToService];
//    NSDictionary *aps = [userInfo valueForKey:@"aps"];
//    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
//    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
//    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    // 取得Extras字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeExtras"]; //服务端中Extras字段，key是自己定义的
//    NSLog(@"content =[%@], badge=[%ld], sound=[%@], customize field  =[%@]",content,(long)badge,sound,customizeField1);
    //判断程序是否在前台运行
    if (application.applicationState ==UIApplicationStateActive) {
        //如果应用在前台，在这里执行
//        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"极光推送" message:content delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//        [alertView show];
    }
    
    // iOS 7 Support Required,处理收到的APNS信息
    //如果应用在后台，在这里执行
    NSLog(@"如果应用在后台，在这里执行 userInfo:%@", userInfo);
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    [JPUSHService setBadge:0];//清空JPush服务器中存储的badge值
    [application setApplicationIconBadgeNumber:0];//小红点清0操作
}

//2. 如果App状态为正在前台或者点击通知栏的通知消息，苹果的回调函数将被调用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [MYFactoryManager uploadMyLocationToService];
    // Required,For systems with less than or equal to iOS6
    NSLog(@"如果App状态为正在前台或者点击通知栏的通知消息，苹果的回调函数将被调用 userInfo:%@", userInfo);
    
    [JPUSHService setBadge:0];//清空JPush服务器中存储的badge值
    [application setApplicationIconBadgeNumber:0];//小红点清0操作
    [JPUSHService handleRemoteNotification:userInfo];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"applicationDidEnterBackground");
//    [MYFactoryManager uploadMyLocationToService];   // 上传我的位置信息到后台服务器
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    NSLog(@"applicationWillEnterForeground");
//    [MYFactoryManager uploadMyLocationToService];   // 上传我的位置信息到后台服务器
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"applicationDidBecomeActive");
//    [MYFactoryManager uploadMyLocationToService];   // 上传我的位置信息到后台服务器
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    
    NSLog(@"applicationWillTerminate");
//    [MYFactoryManager uploadMyLocationToService];   // 上传我的位置信息到后台服务器
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"yuanmaiDriver"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
