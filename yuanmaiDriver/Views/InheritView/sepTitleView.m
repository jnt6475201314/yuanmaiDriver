//
//  sepTitleView.m
//  CarSpider
//
//  Created by fwios001 on 15/12/18.
//  Copyright © 2015年 fwios001. All rights reserved.
//

#import "sepTitleView.h"
#import "MyPicButton.h"

#define view_width self.frame.size.width
#define view_height self.frame.size.height

#define NOMAL_IMGWIDTH 25

@implementation sepTitleView
{
    NSString *btnTitle;
    NSString *btnImage;
    UIFont *nomalFont;
    MyPicButton *_picBtn;
    //分割线
    UIView *sepView1;
    UIView *sepView2;
}

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title withImage:(NSString *)imageName{
    self = [super initWithFrame:frame];
    if (self) {
        nomalFont = [UIFont systemFontOfSize:17.0f];
        btnTitle = title;
        btnImage = imageName;
        [self _initView];
    }
    return self;
}

- (void)_initView {
    _picBtn = [MyPicButton buttonWithType:UIButtonTypeCustom];
    _picBtn.imageDistant = 0;
    _picBtn.frame = CGRectMake(0, 0, view_width, view_height);
    if (btnImage == nil) {
        [_picBtn setBtnViewWithTitle:btnTitle withTitleColor:[UIColor blackColor] withFont:nil];
    }else {
        [_picBtn setBtnViewWithImage:btnImage withImageWidth:NOMAL_IMGWIDTH withTitle:btnTitle withTitleColor:[UIColor blackColor] withFont:nil];
    }
    [self addSubview:_picBtn];
    sepView1 = [[UIView alloc] initWithFrame:CGRectZero];
    sepView1.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [self addSubview:sepView1];
    sepView2 = [[UIView alloc] initWithFrame:CGRectZero];
    sepView2.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [self addSubview:sepView2];
    //计算宽度，调整位置
    [self refreshSubviewsFrame];
}
//标题颜色
- (void)setTitleColor:(UIColor *)titleColor withTitleFont:(UIFont *)font {
    nomalFont = font;
    if (btnImage == nil) {
        [_picBtn setTitleColor:titleColor forState:UIControlStateNormal];
        _picBtn.titleLabel.font = font;
    }else {
        _picBtn.nomalTitleColor = titleColor;
        [_picBtn setBtnFont:font];
    }
    [self refreshSubviewsFrame];
}
//分割线设置
- (void)setSepColor:(UIColor *)sepColor withSepHeight:(float)height {
    sepView1.backgroundColor = sepColor;
    sepView1.height = height;
    sepView1.top = (view_height-height)/2;
    sepView2.backgroundColor = sepColor;
    sepView2.height = height;
    sepView2.top = (view_height-height)/2;
}
//图片位置设置
- (void)setSepPlacement:(NSSepTitlePlacement)sepPlacement {
    if (_sepPlacement != sepPlacement) {
        _sepPlacement = sepPlacement;
    }
    if (sepPlacement == 0) {
        _picBtn.picPlacement = 0;
    }else if(sepPlacement == 1) {
        _picBtn.picPlacement = 1;
    }else if(sepPlacement == 2) {
        _picBtn.picPlacement = 2;
    }
}

- (void)refreshSubviewsFrame {
    CGRect frame = [btnTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:nomalFont} context:nil];
    float width;
    if (btnImage == nil) {
        width = frame.size.width+10;
    }else {
        width = NOMAL_IMGWIDTH+_picBtn.txtImgDistant+frame.size.width;
    }
    _picBtn.frame = CGRectMake((view_width-width-10)/2, 0, width+10, view_height);
    [_picBtn setContentCenter];
    sepView1.frame = CGRectMake(0, view_height/2-0.5, (view_width-width-10)/2, 1);
    sepView2.frame = CGRectMake(view_width-(view_width-width-10)/2, view_height/2-0.5, (view_width-width-10)/2, 1);
}

@end
