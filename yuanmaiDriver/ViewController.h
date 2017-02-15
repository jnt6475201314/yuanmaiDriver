//
//  ViewController.h
//  yuanmaiDriver
//
//  Created by 姜宁桃 on 2017/1/26.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol btnClickDelegate <NSObject>

- (void)btnhaveClicked;

@end

@interface ViewController : UIViewController

@property (nonatomic,weak)id<btnClickDelegate> clickDelegate;

@end

