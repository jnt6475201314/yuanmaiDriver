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
@property (nonatomic, copy) NSString<Optional> * contract_num;
@property (nonatomic, copy) NSString<Optional> * driver_id;
@property (nonatomic, copy) NSString<Optional> * send;
@property (nonatomic, copy) NSString<Optional> * state;
@property (nonatomic, copy) NSString<Optional> * uid;

@end
