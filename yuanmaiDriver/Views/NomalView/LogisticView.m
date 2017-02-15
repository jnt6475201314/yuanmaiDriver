//
//  LogisticView.m
//  One_Snatch
//
//  Created by 小浩 on 16/5/30.
//  Copyright © 2016年 feiwei. All rights reserved.
//

#import "LogisticView.h"

@implementation LogisticView
{
    NSDictionary *style;
    UIImageView *_leftView;
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UILabel *_titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)_initView {
    style = @{@"red":red_color};
    //图片
    _leftView = [MYFactoryManager createNomalImageViewWithFrame:CGRectZero];
    _leftView.layer.cornerRadius = 25;
    _leftView.image = [UIImage imageNamed:@"order_image"];
    [self addSubview:_leftView];
    [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).with.offset(10);
        make.top.equalTo(self).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];

    //名字
    _nameLabel = [UILabel labelWithFrame:CGRectZero text:@"快递公司：申通快递" font:13.0f textColor:color(0, 0, 0, 0.9)];
    [self addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_leftView.mas_trailing).with.offset(20);
        make.top.equalTo(self).with.offset(15);
        make.height.mas_equalTo(20);
    }];
    //时间
    _timeLabel = [UILabel labelWithFrame:CGRectZero text:@"订单号：2012312312322" font:13.0f textColor:[UIColor grayColor]];
    [self addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_leftView.mas_trailing).with.offset(20);
        make.top.equalTo(_nameLabel.mas_bottom).with.offset(10);
        make.height.mas_equalTo(20);
    }];
    UIView *sepView = [[UIView alloc] init];
    sepView.backgroundColor = sepline_color;
    [self addSubview:sepView];
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).with.offset(0);
        make.trailing.equalTo(self).with.offset(0);
        make.top.equalTo(_leftView.mas_bottom).with.offset(9);
        make.height.mas_equalTo(1);
    }];
    //标题
    _titleLabel = [UILabel labelWithFrame:CGRectZero text:@"" font:14.0f textColor:color(0,0,0,0.9)];
    _titleLabel.attributedText = [@"您的宝贝已在路上了，快递单号为<red>12345678</red>" attributedStringWithStyleBook:style];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).with.offset(10);
        make.top.equalTo(sepView.mas_bottom).with.offset(25);
        make.height.mas_equalTo(20);
    }];

}

@end
