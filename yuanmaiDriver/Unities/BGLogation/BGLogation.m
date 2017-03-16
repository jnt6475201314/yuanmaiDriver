//
//  BGLogation.m
//  locationdemo
//
//  Created by yebaojia on 16/2/24.
//  Copyright © 2016年 mjia. All rights reserved.
//

#import "BGLogation.h"
#import "BGTask.h"
#import "MHTransformCorrdinate.h"
@interface BGLogation()
{
    BOOL isCollect;
}
@property (strong , nonatomic) BGTask *bgTask; //后台任务
@property (strong , nonatomic) NSTimer *restarTimer; //重新开启后台任务定时器
@property (strong , nonatomic) NSTimer *closeCollectLocationTimer; //关闭定位定时器 （减少耗电）
@end
@implementation BGLogation
//初始化
-(instancetype)init
{
    if(self == [super init])
    {
        //
        _bgTask = [BGTask shareBGTask];
        isCollect = NO;
        //监听进入后台通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}
+(CLLocationManager *)shareBGLocation
{
    static CLLocationManager *_locationManager;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            _locationManager.allowsBackgroundLocationUpdates = YES;
            _locationManager.pausesLocationUpdatesAutomatically = NO;
    });
    return _locationManager;
}
//后台监听方法
-(void)applicationEnterBackground
{
    NSLog(@"come in background");
    CLLocationManager *locationManager = [BGLogation shareBGLocation];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // 不移动也可以后台刷新回调
    if ([[UIDevice currentDevice].systemVersion floatValue]>= 8.0) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    [_bgTask beginNewBackgroundTask];
}
//重启定位服务
-(void)restartLocation
{
    NSLog(@"重新启动定位");
    CLLocationManager *locationManager = [BGLogation shareBGLocation];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // 不移动也可以后台刷新回调
    if ([[UIDevice currentDevice].systemVersion floatValue]>= 8.0) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    [self.bgTask beginNewBackgroundTask];
}
//开启服务
- (void)startLocation {
    NSLog(@"开启定位");
    
    if ([CLLocationManager locationServicesEnabled] == NO) {
        NSLog(@"locationServicesEnabled false");
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [servicesDisabledAlert show];
    } else {
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        
        if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
            NSLog(@"authorizationStatus failed");
        } else {
            NSLog(@"authorizationStatus authorized");
            CLLocationManager *locationManager = [BGLogation shareBGLocation];
            locationManager.distanceFilter = kCLDistanceFilterNone;
            
            if([[UIDevice currentDevice].systemVersion floatValue]>= 8.0) {
                [locationManager requestAlwaysAuthorization];
            }
            [locationManager startUpdatingLocation];
        }
    }
}

//停止后台定位
-(void)stopLocation
{
    NSLog(@"停止定位");
    isCollect = NO;
    CLLocationManager *locationManager = [BGLogation shareBGLocation];
    [locationManager stopUpdatingLocation];
}
#pragma mark --delegate
//定位回调里执行重启定位和关闭定位
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSLog(@"定位收集");
    //如果正在10秒定时收集的时间，不需要执行延时开启和关闭定位
    if (isCollect) {
        return;
    }
    //得到newLocation
    CLLocation *loc = [locations objectAtIndex:0];
    
    NSMutableDictionary * location = [[NSMutableDictionary alloc] init];
    
    CLLocationCoordinate2D GoogleLoc = [MHTransformCorrdinate GPSLocToGoogleLoc:loc.coordinate];
//    CLLocationCoordinate2D GoogleLoc = [MHTransformCorrdinate getBaiduLocFromGoogleLocLat:loc.coordinate.latitude lng:loc.coordinate.longitude];
    CLLocationCoordinate2D baiduLoc = [MHTransformCorrdinate getBaiduLocFromGoogleLocLat:GoogleLoc.latitude lng:GoogleLoc.longitude];
    
    NSLog(@"系统的经纬度  %f  %f ",loc.coordinate.latitude,loc.coordinate.longitude);
    NSLog(@"谷歌的经纬度 %@", [NSString stringWithFormat:@"经度：%f, 纬度：%f", GoogleLoc.latitude, GoogleLoc.longitude]);
    NSLog(@"百度的经纬度  %f  %f ",baiduLoc.latitude, baiduLoc.longitude);
    NSString * _longitude = [NSString stringWithFormat:@"%f", GoogleLoc.longitude];
    NSString * _latitude = [NSString stringWithFormat:@"%f", GoogleLoc.latitude];
    [location setObject:_longitude forKey:@"longitude"];
    [location setObject:_latitude forKey:@"latitude"];
    
    NSDictionary * locationParams = @{@"sid":GETDriver_ID,@"mobile":[UserDefaults objectForKey:@"data"][@"user_name"], @"longitude":_longitude, @"latitude":_latitude};
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
    
    [self performSelector:@selector(restartLocation) withObject:nil afterDelay:120];
    [self performSelector:@selector(stopLocation) withObject:nil afterDelay:10];
    isCollect = YES;//标记正在定位
}
- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error
{
    // NSLog(@"locationManager error:%@",error);
    
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络错误" message:@"请检查网络连接" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case kCLErrorDenied:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请开启后台服务" message:@"应用没有不可以定位，需要在在设置/通用/后台应用刷新开启" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        default:
        {
            
        }
            break;
    }
}

@end
