//
//  navigationController.m
//  Salary_firm
//
//  Created by fw on 16/3/21.
//  Copyright © 2016年 feiwei. All rights reserved.
//

#import "navigationController.h"
#import "Constants.h"

@interface navigationController ()

@end

@implementation navigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 决定导航栏是否是半透明的
    self.navigationBar.translucent = NO;
    self.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    
    // 设置导航条的颜色
//    self.navigationBar.barTintColor = [UIColor redColor];
    self.navigationBar.barTintColor = [UIColor colorWithRed:226/255.0f green:4/255.0f blue:15/255.0f alpha:1.0f];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSForegroundColorAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
