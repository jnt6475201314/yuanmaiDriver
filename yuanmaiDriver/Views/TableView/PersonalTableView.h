//
//  PersonalTableView.h
//  yuanmaiDriver
//
//  Created by 姜宁桃 on 2017/2/2.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TableViewSelectedEvent <NSObject>

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface PersonalTableView : UITableView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, weak) id<TableViewSelectedEvent>tableViewEventDelegate;

-(instancetype)initWithFrame:(CGRect)frame tableViewStyle:(UITableViewStyle)style;


@end
