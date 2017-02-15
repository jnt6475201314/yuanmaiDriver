//
//  AddressChoicePickerView.m
//  BIZCarSpider
//
//  Created by fwios001 on 15/12/29.
//  Copyright © 2015年 feiwei. All rights reserved.
//

#import "AddressChoicePickerView.h"

@interface AddressChoicePickerView()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHegithCons;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (strong, nonatomic) AreaObject *locate;

//城市 数组
@property (strong, nonatomic) NSArray *cityArr;
//区县 数组
@property (strong, nonatomic) NSArray *areaArr;

@end
@implementation AddressChoicePickerView

- (instancetype)init{
    
    if (self = [super init]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"AddressChoicePickerView" owner:nil options:nil]firstObject];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesuture:)];
        [self addGestureRecognizer:tapGesture];
        self.userInteractionEnabled = YES;
        self.frame = [UIScreen mainScreen].bounds;
        self.pickView.delegate = self;
        self.pickView.dataSource = self;
        [self customView];
    }
    return self;
}

- (void)reloadPickerView {
    self.cityArr = self.provinceArr[0][@"cities"];
    self.areaArr = self.cityArr[0][@"counties"];
    self.locate.province = self.provinceArr[0][@"name"];
    self.locate.city = self.cityArr[0][@"name"];
    self.locate.provinceId = self.provinceArr[0][@"id"];
    self.locate.cityId = self.cityArr[0][@"id"];
    if (self.areaArr.count) {
        self.locate.area = self.areaArr[0][@"name"];
        self.locate.areaId = self.areaArr[0][@"id"];
    }else{
        self.locate.area = @"";
    }
}

- (void)tapGesuture:(UITapGestureRecognizer *)tapGesture {
    [self hide];
}

- (void)customView{
    self.contentViewHegithCons.constant = 0;
    [self layoutIfNeeded];
}

#pragma mark - setter && getter

- (AreaObject *)locate{
    if (!_locate) {
        _locate = [[AreaObject alloc]init];
    }
    return _locate;
}

#pragma mark - action

//选择完成
- (IBAction)finishBtnPress:(UIButton *)sender {
    if (self.block) {
        self.block(self,sender,self.locate);
    }
    [self hide];
}

//隐藏
- (IBAction)dissmissBtnPress:(UIButton *)sender {
    
    [self hide];
}

#pragma  mark - function

- (void)show{
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = [win.subviews firstObject];
    [topView addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentViewHegithCons.constant = 250;
        [self layoutIfNeeded];
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self.contentViewHegithCons.constant = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return self.provinceArr.count;
            break;
        case 1:
            return self.cityArr.count;
            break;
        case 2:
            if (self.areaArr.count) {
                return self.areaArr.count;
                break;
            }
        default:
            return 0;
            break;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return [[self.provinceArr objectAtIndex:row] objectForKey:@"name"];
            break;
        case 1:
            return [[self.cityArr objectAtIndex:row] objectForKey:@"name"];
            break;
        case 2:
            if (self.areaArr.count) {
                return [[self.areaArr objectAtIndex:row] objectForKey:@"name"];
                break;
            }
        default:
            return  @"";
            break;
    }
}
#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumScaleFactor = 8.0;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
        {
            self.cityArr = [[self.provinceArr objectAtIndex:row] objectForKey:@"cities"];
            [self.pickView reloadComponent:1];
            [self.pickView selectRow:0 inComponent:1 animated:YES];
            
            self.areaArr = [[self.cityArr objectAtIndex:0] objectForKey:@"counties"];
            [self.pickView reloadComponent:2];
            [self.pickView selectRow:0 inComponent:2 animated:YES];
            
            self.locate.province = self.provinceArr[row][@"name"];
            self.locate.provinceId = self.provinceArr[row][@"id"];
            self.locate.city = self.cityArr[0][@"name"];
            self.locate.cityId = self.cityArr[0][@"id"];
            if (self.areaArr.count) {
                self.locate.area = self.areaArr[0][@"name"];
                self.locate.areaId = self.areaArr[0][@"id"];
            }else{
                self.locate.area = @"";
            }
            break;
        }
        case 1:{
            self.areaArr = [[self.cityArr objectAtIndex:row] objectForKey:@"counties"];
            [self.pickView reloadComponent:2];
            [self.pickView selectRow:0 inComponent:2 animated:YES];
            
            self.locate.city = self.cityArr[row][@"name"];
            self.locate.cityId = self.cityArr[row][@"id"];
            if (self.areaArr.count) {
                self.locate.area = self.areaArr[0][@"name"];
                self.locate.areaId = self.areaArr[0][@"id"];
            }else{
                self.locate.area = @"";
            }

            break;
        }
        case 2:{
            if (self.areaArr.count) {
                self.locate.area = self.areaArr[row][@"name"];
                self.locate.areaId = self.areaArr[row][@"id"];
            }else{
                self.locate.area = @"";
            }
            
            break;
        }
        default:
            break;
    }
    if (self.block) {
        self.block(self,nil,self.locate);
    }
}


@end
