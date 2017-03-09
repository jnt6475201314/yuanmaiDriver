//
//  Constants.h
//  CarSpider
//
//  Created by fwios001 on 15/11/23.
//  Copyright © 2015年 fwios001. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

// 系统的版本判断
#define kSysVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

#define iOS8Later (kSysVersion >= 8.0f)
#define iOS7Later (kSysVersion >= 7.0f)
#define iOS6Later (kSysVersion >= 6.0f)

#define iOS7 (kSysVersion >= 7.0f && kSysVersion < 8.0f)

//图片宽度
#define pic_width (screen_width-5*4-10*2)/5
//背景颜色
#define background_color color(244, 244, 244, 1)
//app默认橙色
#define pink_color color(238, 109, 140, 1)
#define blue_color color(70, 150, 252, 1)
#define red_color color(27, 146, 52, 1)
//文本颜色
#define default_text_color color(139, 139, 139, 1)
//tabBar颜色
#define navBar_color color(67, 89, 224, 1)
//tabBar颜色
#define tabBar_color color(255, 255, 255, 1)
//边框颜色
#define pic_borderColor color(229, 229, 229, 1)
//分割线颜色
#define sepline_color color(242, 242, 242, 1)
//广告视图高度
#define adver_picHeight 150

#define imageView_width 50

#define iPhone6                                                                \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
? CGSizeEqualToSize(CGSizeMake(750, 1334),                              \
[[UIScreen mainScreen] currentMode].size)           \
: NO)
#define iPhone6Plus                                                            \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
? CGSizeEqualToSize(CGSizeMake(1242, 2208),                             \
[[UIScreen mainScreen] currentMode].size)           \
: NO)
#define AppDelegateInstance ((AppDelegate*)([UIApplication sharedApplication].delegate))

//高德配置
#define GAODEMAP_APIKEY @"bcc021ddc512ceab0a4df9d112cbd144"
//融云基础设置
#define SERVICE_ID @"KEFU145829438876942"
#define RONGCLOUD_IM_APPKEY @"25wehl3uwm6kw"
#define RONGCLOUD_IM_USER_TOKEN @"H9jiUyfYboCeMoq7s6xjdhUemNGWtqIdEqgZhC0uPXJ0zmjg46ZldwlxLp4Rj8uwp2W4svd4Skkkvmuic5cmlXeGUQDvyBU3"
//极光配置
#define JPushAppKey @"60b3fb582d563a102ecb9d5d"
#define JPushChannel @"Publish channel"
//友盟配置
#define YOUMENG_APPKEY @"5895903a7f2c744eeb000f73"
//------QQ-------
#define YOUMENG_QQ_ID @"1105813015"
#define YOUMENG_QQ_KEY @"rJC5vMLciwmWZbPe"
//------WX-------
#define WEIXIN_ID @"wxa21ef727795aa3a2"
#define WEIXIN_KEY @"c948e7a83fa0195824d4f480b28198d8"
//------WB-------
#define YOUMENG_WEIBO_KEY @"3128254811"

#define ORDER_PAY_NOTIFICATION @"ORDER_PAY_NOTIFICATION"

#define BASE_URL @"http://202.91.248.43/project/index.php"

#define SHAREAPP_URL @"https://itunes.apple.com/cn/app/yuan-mai-wu-liu-si-ji-ban/id1180261369?mt=8"

//token验证
#define CHECK_TOKEN_URL [NSString stringWithFormat:@"%@/Admin/Appline/verify.html", ForTestCommonHeadUrl]  //验证token

// 是否通知
#define NOTIFICATION @"notification"   //
#define GetNotificationStatus [UserDefaults objectForKey:NOTIFICATION]

// 是否检测异地登录
#define RELOGIN @"relogin"   //
#define GetRELOGINStatus [UserDefaults objectForKey:RELOGIN]

// 获取位置信息
#define LOCATION @"location"
#define GetLocationDict [UserDefaults objectForKey:LOCATION]
// 获取经度
#define GetLongitude [UserDefaults objectForKey:@"longitude"]
// 获取纬度
#define GetLatitude [UserDefaults objectForKey:@"latitude"]



#endif 
