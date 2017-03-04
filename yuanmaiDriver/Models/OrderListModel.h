//
//  OrderListModel.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/20.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface OrderListModel : JSONModel

@property (nonatomic, copy) NSString<Optional> * arrival_address;
@property (nonatomic, copy) NSString<Optional> * contract_num;  // 合同号
@property (nonatomic, copy) NSString<Optional> * driver_id;
@property (nonatomic, copy) NSString<Optional> * send;
@property (nonatomic, copy) NSString<Optional> * state;
@property (nonatomic, copy) NSString<Optional> * uid;

@property (nonatomic, copy) NSString<Optional> * gid;   // 运单id
@property (nonatomic, copy) NSString<Optional> * order_number;  // 定单号
@property (nonatomic, copy) NSString<Optional> * cooperation_company;   // 3 时不用回单
@property (nonatomic, copy) NSString<Optional> * add_time;

@end
