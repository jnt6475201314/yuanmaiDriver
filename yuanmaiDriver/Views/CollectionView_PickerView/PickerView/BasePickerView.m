//
//  BasePickerView.m
//  BIZCarSpider
//
//  Created by fwios001 on 15/12/29.
//  Copyright © 2015年 feiwei. All rights reserved.
//

#import "BasePickerView.h"

@implementation BasePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)_initView {
    self.showsSelectionIndicator=YES;
    self.dataSource = self;
    self.delegate = self;
}

// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.data.count;
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return screen_width;
}
// 每行宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}
// 选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([self.pickerEventDelegate respondsToSelector:@selector(didSelectPickerView:forSelectRow:inComponent:)]) {
        [self.pickerEventDelegate didSelectPickerView:pickerView forSelectRow:row inComponent:component];
    }
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.data objectAtIndex:row];
}

@end
