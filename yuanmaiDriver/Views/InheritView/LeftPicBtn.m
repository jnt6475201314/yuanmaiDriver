//
//  LeftPicBtn.m
//  CarSpider
//
//  Created by fwios001 on 15/12/3.
//  Copyright © 2015年 fwios001. All rights reserved.
//

#import "LeftPicBtn.h"

@implementation LeftPicBtn

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        self.titleLabel.textAlignment = 1;
        [self setTitleColor:color(0, 0, 0, 0.8) forState:UIControlStateNormal];
    }
    return self;
}

//设置图片显示位置
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, (contentRect.size.height-25)/2, 25, 25);
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:nil];
}

//设置标题位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(40, (contentRect.size.height-25)/2, contentRect.size.width-40, 25);
}

@end
