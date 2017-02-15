//
//  TrailDetailBtn.m
//  GoHiking_app
//
//  Created by qf on 15/11/1.
//  Copyright (c) 2015年 qf. All rights reserved.
//

#import "TrailDetailBtn.h"

@implementation TrailDetailBtn

- (instancetype)initWithFrame:(CGRect)frame initWithTitle:(NSString *)title withImage:(NSString *)imageName{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        self.titleLabel.textAlignment = 1;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.backgroundColor = color(0, 0, 0, 0.5);
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateNormal];
        self.layer.borderColor = [UIColor grayColor].CGColor;
    }
    return self;
}

//设置图片显示位置
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(contentRect.origin.x, contentRect.origin.y, 20, 20);
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:nil];
}


@end
