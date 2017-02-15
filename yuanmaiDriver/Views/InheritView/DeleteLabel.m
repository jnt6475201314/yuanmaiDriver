//
//  DeleteLabel.m
//  CarSpider
//
//  Created by fwios001 on 15/11/30.
//  Copyright © 2015年 fwios001. All rights reserved.
//

#import "DeleteLabel.h"

@implementation DeleteLabel
{
    UIView *_deleteLine;
}

- (instancetype)initWithFrame:(CGRect)frame withFontSize:(CGFloat)fontSize{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
        self.textColor = [UIColor grayColor];
        self.font = [UIFont systemFontOfSize:fontSize];
        self.fontSize = fontSize;
    }
    return self;
}

- (void)_initView {
    //删除线
    _deleteLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height/2, self.width, 1)];
    _deleteLine.backgroundColor = [UIColor grayColor];
    [self addSubview:_deleteLine];
}

//重写text赋值，计算宽度
- (void)setText:(NSString *)text {
    [super setText:text];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_fontSize]} context:nil];
    _deleteLine.width = rect.size.width;
}

- (void)setFontSize:(CGFloat)fontSize {
    if (_fontSize != fontSize) {
        _fontSize = fontSize;
    }
    self.font = [UIFont systemFontOfSize:_fontSize];
}

@end
