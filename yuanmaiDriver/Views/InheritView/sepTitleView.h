//
//  sepTitleView.h
//  CarSpider
//
//  Created by fwios001 on 15/12/18.
//  Copyright © 2015年 fwios001. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, NSSepTitlePlacement) {
    NSSepTitlePlacementLeft      = 0,    // Visually left aligned
    NSSepTitlePlacementCenter    = 1,    // Visually centered
    NSSepTitlePlacementRight     = 2,    // Visually right aligned
} NS_ENUM_AVAILABLE_IOS(6_0);
@interface sepTitleView : UIView

@property (nonatomic)NSSepTitlePlacement sepPlacement;

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title withImage:(NSString *)imageName;
//标题颜色
- (void)setTitleColor:(UIColor *)titleColor withTitleFont:(UIFont *)font;
//设置分割线
- (void)setSepColor:(UIColor *)sepColor withSepHeight:(float)height;

@end
