//
//  AdverView.m
//  CarSpider
//
//  Created by fwios001 on 15/11/24.
//  Copyright © 2015年 fwios001. All rights reserved.
//

#import "AdverView.h"
#import "SMPageControl.h"

@implementation AdverView

{
    UIScrollView *_picScrollView;
    UIPageControl *_pageCtrl;
//    UILabel *_titleLabel;
    NSTimer *_timer;
    BOOL haveLoad;
}

- (instancetype)initWithFrame:(CGRect)frame withPicHeight:(float)picHeight{
    self = [super initWithFrame:frame];
    if (self) {
        self.picHeight = picHeight;
        [self _initView];
    }
    return self;
}

- (void)_initView{
    //    self.userInteractionEnabled = YES;
    self.clipsToBounds = YES;
    //定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(changeScrollView:) userInfo:nil repeats:YES];
    //滚动视图
    _picScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screen_width, self.picHeight)];
    _picScrollView.delegate = self;
    //初始设置
    _picScrollView.showsHorizontalScrollIndicator = NO;
    _picScrollView.showsVerticalScrollIndicator = NO;
    _picScrollView.pagingEnabled = YES;
    [self addSubview:_picScrollView];
    //分页视图
    _pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(screen_width-70, _picScrollView.bottom-30, 70, 30)];
//    _pageCtrl.pageIndicatorTintColor = color(0, 0, 0, 0.2);
    _pageCtrl.currentPageIndicatorTintColor = color(183, 183, 173, 1);
    _pageCtrl.pageIndicatorTintColor = color(245, 245, 242, 1);
    [self addSubview:_pageCtrl];
    //标题视图
//    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, _picScrollView.bottom, screen_width, 30)];
//    titleView.tag = 2015;
//    titleView.backgroundColor = color(191, 198, 205, 1);
//    
//    _titleLabel = [UILabel labelWithFrame:CGRectMake(0, 0, screen_width-70, 30) text:@"" font:13.0f textColor:[UIColor whiteColor]];
//    [titleView addSubview:_titleLabel];
//    [self addSubview:titleView];
}

#pragma imageView--点击手势
- (void)imageTag:(UITapGestureRecognizer *)tapGesture{
    UIImageView *imageView = (UIImageView *)[tapGesture view];
    if ([self.imageDelegate respondsToSelector:@selector(imageWithTagGesture:)]) {
        [self.imageDelegate imageWithTagGesture:(int)imageView.tag-100];
    }
}

- (void)setPicArray:(NSArray *)picArray {
    if (_picArray != picArray) {
        _picArray = picArray;
    }
    //创建图片视图
    if (!haveLoad) {
        for (int i=0; i<_picArray.count+2; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width*i, 0, screen_width, self.picHeight)];
            imageView.tag = 100+i;
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTag:)];
            [imageView addGestureRecognizer:tapGesture];
            [_picScrollView addSubview:imageView];
            haveLoad = YES;
        }
    }
    
    for (int i=0; i<_picArray.count+2; i++) {
        UIImageView *imageView = (UIImageView *)[self viewWithTag:100+i];
        if (_picArray.count > 0) {
            NSString *imageStr;
            if (i==0) {
                imageStr = [_picArray objectAtIndex:i];
            }else if (i>0 && i<_picArray.count+1) {
                imageStr = [_picArray objectAtIndex:i-1];
            }else {
                imageStr = [_picArray objectAtIndex:i-2];
            }
//            imageView.image = [UIImage imageNamed:imageStr];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,imageStr]] placeholderImage:[UIImage imageNamed:@"moren"]];
        }
    }
    _pageCtrl.numberOfPages = _picArray.count;
    _picScrollView.contentOffset = CGPointMake(screen_width, 0);
    _picScrollView.contentSize = CGSizeMake(screen_width*(_picArray.count+2), self.picHeight);
}

#pragma mark---timerAction
- (void)changeScrollView:(NSTimer *)timer{
    if (_textArray.count != 0) {
        _picScrollView.contentOffset = CGPointMake(_picScrollView.contentOffset.x+20, 0);
        return;
    }
    _picScrollView.contentOffset = CGPointMake(_picScrollView.contentOffset.x+screen_width, 0);
    if (_picScrollView.contentOffset.x == _picScrollView.contentSize.width-screen_width) {
        _picScrollView.contentOffset = CGPointMake(screen_width, 0);
    }
    _pageCtrl.currentPage = _picScrollView.contentOffset.x/screen_width - 1;
}

#pragma mark---UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    //    [_timer setFireDate:[NSDate distantFuture]];
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(changeScrollView:) userInfo:nil repeats:YES];
    int page = scrollView.contentOffset.x/screen_width;
    _pageCtrl.currentPage = page-1;
    if (page == 0) {
        scrollView.contentOffset = CGPointMake(scrollView.contentSize.width-2*screen_width, 0);
        _pageCtrl.currentPage = scrollView.contentSize.width/screen_width-2;
    }else if (page == scrollView.contentSize.width/screen_width-1) {
        scrollView.contentOffset = CGPointMake(screen_width, 0);
        _pageCtrl.currentPage = 0;
    }
}

#pragma mark - text点击手势 1000+i
- (void)textTag:(UITapGestureRecognizer *)tap{
    
}

//滚动文本
- (void)setTextArray:(NSArray *)textArray{
    if (_textArray != textArray) {
        _textArray = textArray;
    }
    //创建Label视图
    if (!haveLoad) {
        for (int i=0; i<_textArray.count+2; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(screen_width*i, 0, screen_width, 30)];
            label.textColor = [UIColor redColor];
            label.font = [UIFont systemFontOfSize:12];
            label.tag = 1000+i;
            label.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textTag:)];
            [label addGestureRecognizer:tapGesture];
            [_picScrollView addSubview:label];
            haveLoad = YES;
        }
    }
    
    for (int i=0; i<_textArray.count+2; i++) {
        UILabel *label = (UILabel *)[self viewWithTag:1000+i];
        if (_textArray.count > 0) {
            NSString *textStr = nil;
            if (i==0) {
                textStr = [_textArray objectAtIndex:i];
            }else if (i>0 && i<_textArray.count+1) {
                textStr = [_textArray objectAtIndex:i-1];
            }else {
                textStr = [_textArray objectAtIndex:i-2];
            }
            label.text = textStr;
        }
    }
//    _pageCtrl.numberOfPages = _picArray.count;
    _picScrollView.pagingEnabled = YES;
    _picScrollView.contentOffset = CGPointMake(screen_width, 0);
    _picScrollView.contentSize = CGSizeMake(screen_width*(_textArray.count+2), 30);
}



@end
