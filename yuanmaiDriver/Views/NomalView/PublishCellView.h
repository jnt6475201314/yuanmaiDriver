//
//  PublishCellView.h
//  BIZCarSpider
//
//  Created by fwios001 on 15/12/24.
//  Copyright © 2015年 feiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^tapGestureBlock)(void);
@interface PublishCellView : UIView

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *detailLabel;
@property (nonatomic,strong)UIImageView *rightImage;

@property (nonatomic,strong)tapGestureBlock tapBlock;

@end
