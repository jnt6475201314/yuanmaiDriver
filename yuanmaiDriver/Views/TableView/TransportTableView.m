//
//  TransportTableView.m
//  yuanmaiDriver
//
//  Created by 姜宁桃 on 2017/5/13.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "TransportTableView.h"

#import "TransportTableViewCell.h"
#import "OrderListModel.h"


@implementation TransportTableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.tabViewDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TransportTableViewCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"TransportTableViewCell" owner:nil options:nil]lastObject];
    OrderListModel * model = self.tabViewDataSource[indexPath.section];
    
    if (model.contract_num == NULL) {
        cell.Frist.text = [NSString stringWithFormat:@"订单号：%@", model.order_number];
    }else{
        cell.Frist.text = [NSString stringWithFormat:@"合同123号：%@", model.contract_num];
    }
    //cell.OrderStateLabel.text= model.state;
    cell.secound.text = [NSString stringWithFormat:@"发货地址：%@", model.send];
    cell.thrid.text = [NSString stringWithFormat:@"到货地址：%@", model.arrival_address];
    //cell.OrderDestinationLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return cellHeight;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}


@end
