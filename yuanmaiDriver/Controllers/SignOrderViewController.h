//
//  SignOrderViewController.h
//  yuanmaiDriver
//
//  Created by 姜宁桃 on 2017/2/1.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderListModel.h"

@interface SignOrderViewController : BaseViewController

@property (nonatomic, strong) NSMutableDictionary * params;
@property (nonatomic, strong) OrderListModel * orderModel;

@end
