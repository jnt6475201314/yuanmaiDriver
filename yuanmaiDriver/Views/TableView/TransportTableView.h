//
//  TransportTableView.h
//  yuanmaiDriver
//
//  Created by 姜宁桃 on 2017/5/13.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "BaseTableView.h"

@protocol TSDelegate <NSObject>

-(void)OrderBtnClick:(id)model;

@end

@interface TransportTableView : BaseTableView

@property (nonatomic, weak)id<TSDelegate> TSdelegate;

@end
