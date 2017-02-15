//
//  NetRequest.h
//  CustomHUD
//
//  Created by feiwei on 15/11/23.
//  Copyright © 2015年 feiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XZQProgressHUD;

typedef void(^SuccessBlock)(id data);
typedef void(^FailBlock)(NSString *errorDes);
typedef void(^HideHUDBlock)();

@interface NetRequest : NSObject

+ (void)getDataWithUrlString:(NSString *)urlString withParams:(NSDictionary *)params success:(SuccessBlock)successBlock fail:(FailBlock)failBlock;

+ (void)postDataWithUrlString:(NSString *)urlString withParams:(NSDictionary *)params success:(SuccessBlock)successBlock fail:(FailBlock)failBlock;

//+ (void)getDataWithUrlString:(NSString *)urlString withParams:(NSDictionary *)params isShowHUD:(BOOL)isShow HUD:(XZQProgressHUD *)HUD showNetworkErrorAlert:(BOOL)showAlert success:(SuccessBlock)successBlock fail:(FailBlock)failBlock;
//
//+ (void)postDataWithUrlString:(NSString *)urlString withParams:(NSDictionary *)params isShowHUD:(BOOL)isShow HUD:(XZQProgressHUD *)HUD showNetworkErrorAlert:(BOOL)showAlert success:(SuccessBlock)successBlock fail:(FailBlock)failBlock;

/* 检查是否异地登陆的操作 */
+ (void)checkOtherPlaceLoginWithUrlString:(NSString *)urlString withParams:(NSDictionary *)params success:(SuccessBlock)successBlock fail:(FailBlock)failBloc;

@end
