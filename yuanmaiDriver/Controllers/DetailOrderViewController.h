//
//  DetailOrderViewController.h
//  yuanmaiDriver
//
//  Created by 姜宁桃 on 2017/2/1.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderListModel.h"
#import "ScanModel.h"

@interface DetailOrderViewController : BaseViewController

@property (nonatomic, copy) NSString * upVCTitle;
@property (nonatomic, strong) ScanModel * scanModel;
@property (nonatomic, strong) OrderListModel * orderModel;

@end
