//
//  SelectedView.h
//  DigWork
//
//  Created by fwios001 on 15/12/17.
//  Copyright © 2015年 feiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectedBtnDelegate <NSObject>

- (void)selectedBtnSendSelectIndex:(int)selectedIndex;

@end

@interface SelectedView : UIView

@property (nonatomic,assign)int firstSelect;
@property (nonatomic,weak)id<selectedBtnDelegate>selectDelegate;
@property (nonatomic,strong)NSArray *titleArray;

- (instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)titleArr;
- (void)setViewWithNomalColor:(UIColor *)nomalColor withSelectColor:(UIColor *)selectColor withTitlefont:(UIFont *)font;
//设置边框属性
- (void)setViewBorderColor:(UIColor *)color borderWidth:(float)width;
//设置主流分割线
- (void)setViewSepColor:(UIColor *)color sepHeight:(float)height sepWidth:(float)width;
//设置滑动条高度
- (void)setMoveViewHeight:(float)height;
- (void)setMoveViewAllWidth;
//设置滑动条隐藏
- (void)setMoveViewHidden:(BOOL)hidden;

//按钮选择
- (void)selectBtnClick:(UIButton *)button;

- (void)changeFristBtnTitle:(NSString *)string;

- (void)changeSecoundBtnTitle:(NSString *)string;

@end
