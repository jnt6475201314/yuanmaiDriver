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
    
    if (model.contract_num == NULL) {
        cell.OrderNumberLabel.text = [NSString stringWithFormat:@"订单号：%@", model.order_number];
    }else{
        cell.OrderNumberLabel.text = [NSString stringWithFormat:@"合同号：%@", model.contract_num];
    }
    cell.OrderStateLabel.text= model.state;
    cell.OrderStartingLabel.text = [NSString stringWithFormat:@"发货地址：%@", model.send];
    cell.OrderDestinationLabel.text = [NSString stringWithFormat:@"到货地址：%@", model.arrival_address];
    //cell.OrderDestinationLabel.adjustsFontSizeToFitWidth = YES;
    cell.OrderBtn.alpha = 1;
    cell.OrderBtn.userInteractionEnabled = YES;
    if (![model.receipt isEqualToString:@"1"]) {
//        [cell.OrderBtn removeFromSuperview];
        cell.OrderBtn.alpha = 0;
        cell.OrderBtn.userInteractionEnabled = NO;
    }
    cell.OrderBtn.tag = indexPath.section;
    [cell.OrderBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)btnClick:(UIButton *)btn{
    [self.Btndelegate OrderBtnClick:self.tabViewDataSource[btn.tag]];
}

@end
