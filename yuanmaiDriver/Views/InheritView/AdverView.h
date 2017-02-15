//
//  AdverView.h
//  CarSpider
//
//  Created by fwios001 on 15/11/24.
//  Copyright © 2015年 fwios001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageViewEventDelegate <NSObject>

- (void)imageWithTagGesture:(int)imageViewTag;

@end

@interface AdverView : UIView<UIScrollViewDelegate>

@property (nonatomic,strong)NSArray *picArray;
@property (nonatomic,assign)float picHeight;
@property (nonatomic,strong)NSArray *textArray;

@property (nonatomic,strong)id<ImageViewEventDelegate> imageDelegate;

- (instancetype)initWithFrame:(CGRect)frame withPicHeight:(float)picHeight;

@end
