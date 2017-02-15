//
//  PublishCellView.m
//  BIZCarSpider
//
//  Created by fwios001 on 15/12/24.
//  Copyright © 2015年 feiwei. All rights reserved.
//

#import "PublishCellView.h"

@implementation PublishCellView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        [self _initView];
    }
    return self;
}

- (void)_initView {
    //默认
    _titleLabel = [UILabel labelWithFrame:CGRectMake(10, (self.height-20)/2, 160, 20) text:@"服务描述" font:14.0f textColor:[UIColor grayColor]];
    [self addSubview:_titleLabel];
    //详情
    _detailLabel = [UILabel labelWithFrame:CGRectMake(screen_width-180, 0, 150, self.height) text:@"" font:14.0f textColor:[UIColor grayColor]];
    _detailLabel.numberOfLines = 0;
    _detailLabel.textAlignment = 2;
    [self addSubview:_detailLabel];
    _rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width-20, (self.height-13)/2, 10, 13)];
    _rightImage.userInteractionEnabled = YES;
    _rightImage.image = [UIImage imageNamed:@"more"];
    [self addSubview:_rightImage];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tapGesture];
}

#pragma UITapGestureRecognizer
- (void)tapGesture:(UITapGestureRecognizer *)tapGesture {
    if (self.tapBlock) {
        self.tapBlock();
    }
}

@end
