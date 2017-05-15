//
//  OrderTableViewCell.h
//  CommoFramework
//
//  Created by 姜宁桃 on 2016/10/20.
//  Copyright © 2016年 姜宁桃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *OrderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *OrderStateLabel;
@property (weak, nonatomic) IBOutlet UIView *OrderSpaceLine;
@property (weak, nonatomic) IBOutlet UILabel *OrderStartingLabel;
@property (weak, nonatomic) IBOutlet UILabel *OrderDestinationLabel;

@property (weak, nonatomic) IBOutlet UIButton *OrderBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *OrderDestinationLabel_bottom;
@end
