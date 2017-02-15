//
//  BasePickerView.h
//  BIZCarSpider
//
//  Created by fwios001 on 15/12/29.
//  Copyright © 2015年 feiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PickerViewEventDelegate <NSObject>
//选中
- (void)didSelectPickerView:(UIPickerView *)pickerView forSelectRow:(NSInteger)row inComponent:(NSInteger)component;
@end
@interface BasePickerView : UIPickerView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong)NSArray *data;

@property (nonatomic,assign)id<PickerViewEventDelegate> pickerEventDelegate;

- (void)_initView;

@end
