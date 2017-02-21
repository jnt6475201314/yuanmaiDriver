//
//  NetAPI.h
//  BaseUseWork
//
//  Created by 姜宁桃 on 2016/12/25.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#ifndef NetAPI_h
#define NetAPI_h

// 获取司机ID   driver_id
#define GETDriver_ID [UserDefaults objectForKey:@"data"][@"driver_id"]
#define GETTOKEN_Str [UserDefaults objectForKey:@"token_str"]
#define GETDeviceToken [UserDefaults objectForKey:@"deviceToken"]

#if 0   // 测试时使用的
#define CommonHeadUrl @"http://139.196.29.1/test/Admin/"
#endif

#if 1   // 上线时使用的
#define CommonHeadUrl @"http://202.91.248.43/Admin/"
#endif

#define CHECK_TokenStr_UrlStr [NSString stringWithFormat:@"%@Appdriver/verify", CommonHeadUrl]  // 检查异地登录

#define guideCommonHeadUrl @"http://139.196.29.1/test/"
#define API_GETGUIDANCEIMAGE_URL [NSString stringWithFormat:@"%@/Admin/Applineorder/guideImage", guideCommonHeadUrl]     // 引导页图片
#define API_guideheadImageUrl [NSString stringWithFormat:@"%@Public/Admin_Uploads/guide_image/", guideCommonHeadUrl]

#define API_LOGIN_URL [NSString stringWithFormat:@"%@App/do_login.html", CommonHeadUrl]  // 登录
#define API_GetVerifyCode_URL [NSString stringWithFormat:@"%@App/code.html", CommonHeadUrl]  // 获取验证码
#define API_ForgetPasswords_URL [NSString stringWithFormat:@"%@App/back_password.html", CommonHeadUrl]  // 忘记密码
#define API_Register_URL [NSString stringWithFormat:@"%@App/register.html", CommonHeadUrl]  // 注册
#define API_ResourceOfOrders_URL [NSString stringWithFormat:@"%@Appdriver/goods_info", CommonHeadUrl]  // 获取货源数据
#define API_OrderDetailWith(uid) [NSString stringWithFormat:@"%@Applineorder/test?id=%@", CommonHeadUrl,uid]   // 运单详情
#define API_SCAN_URL [NSString stringWithFormat:@"%@Appdriver/scanning", CommonHeadUrl]  // 运单扫描
#define API_OrderAction_URL [NSString stringWithFormat:@"%@Appdriver/goods_statu", CommonHeadUrl]  // 运单操作
#define API_SUGGESTION_URL [NSString stringWithFormat:@"%@Apporder/opinion.html", CommonHeadUrl]   // 建议
#define API_UPDATEPWD_URL [NSString stringWithFormat:@"%@App/edit.html", CommonHeadUrl]      // 修改密码
#define API_UPLoadLocation_URL [NSString stringWithFormat:@"%@Appdriver/location", CommonHeadUrl]      // 上传地址信息

#endif /* NetAPI_h */
