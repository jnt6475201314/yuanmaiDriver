//
//  OrderTableView.m
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/20.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import "OrderTableView.h"
#import "OrderTableViewCell.h"
#import "OrderListModel.h"

@implementation OrderTableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:baseTableViewIdentifier];
    
    OrderListModel * model = self.tabViewDataSource[indexPath.section];
    
    cell.OrderNumberLabel.text = [NSString stringWithFormat:@"合同号：%@", model.contract_num];
    if ([model.state isEqualToString:@"10"]) {
        cell.OrderStateLabel.text = @"待接单";
    }else if ([model.state isEqualToString:@"11"]){
        cell.OrderStateLabel.text= @"运输中";
    }else if ([model.state isEqualToString:@"12"]){
        cell.OrderStateLabel.text= @"已到达";
    }else if ([model.state isEqualToString:@"13"]){
        cell.OrderStateLabel.text= @"已回单";
    }
    cell.OrderStartingLabel.text = [NSString stringWithFormat:@"发货地址：%@", model.send];
    cell.OrderDestinationLabel.text = [NSString stringWithFormat:@"到货地址：%@", model.arrival_address];
    cell.OrderDestinationLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

@end
