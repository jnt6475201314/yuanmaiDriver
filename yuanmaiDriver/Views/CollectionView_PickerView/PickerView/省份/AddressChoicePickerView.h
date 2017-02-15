//
//  AddressChoicePickerView.h
//  BIZCarSpider
//
//  Created by fwios001 on 15/12/29.
//  Copyright © 2015年 feiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaObject.h"
@class AddressChoicePickerView;
typedef void (^AddressChoicePickerViewBlock)(AddressChoicePickerView *view,UIButton *btn,AreaObject *locate);
@interface AddressChoicePickerView : UIView

@property (copy, nonatomic)AddressChoicePickerViewBlock block;
//省 数组
@property (strong, nonatomic) NSArray *provinceArr;

- (void)reloadPickerView;
- (void)show;
@end
