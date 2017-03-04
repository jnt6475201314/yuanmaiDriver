//
//  UploadReceiptViewController.h
//  yuanmaiDriver
//
//  Created by 姜宁桃 on 2017/3/4.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderListModel.h"

@interface UploadReceiptViewController : BaseViewController
@property(nonatomic,strong)UIImage *signImage;
@property(nonatomic,strong)UIImage *receiptImage;

@property (nonatomic, strong) OrderListModel * orderModel;

@end
