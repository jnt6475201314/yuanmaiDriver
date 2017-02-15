//
//  ProvincePickView.h
//  ProvinceSelectView
//
//  Created by 李挺哲 on 2016/11/25.
//  Copyright © 2016年 李挺哲. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProvinceView.h"

@protocol ProvincePickViewDelegate <NSObject>

-(void)provincePickViewDidPick:(NSInteger)index;

-(void)provincePickViewDisMissed;


@end


@interface ProvincePickView : UIView


@property (strong, nonatomic) UIButton *bgButton;
@property (strong, nonatomic) ProvinceView *pickerView;
@property (strong,nonatomic)NSMutableArray * provinceArray;
@property(weak,nonatomic) id<ProvincePickViewDelegate>delegate;

- (void)dismissPicker;
- (void)showPicker;

-(void)reLoadData;
@end
