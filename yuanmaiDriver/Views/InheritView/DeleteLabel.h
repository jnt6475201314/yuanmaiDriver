//
//  DeleteLabel.h
//  CarSpider
//
//  Created by fwios001 on 15/11/30.
//  Copyright © 2015年 fwios001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeleteLabel : UILabel

- (instancetype)initWithFrame:(CGRect)frame withFontSize:(CGFloat)fontSize;

//设置字体;
@property (nonatomic,assign)CGFloat fontSize;

@end
