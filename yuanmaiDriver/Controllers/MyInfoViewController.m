//
//  MyInfoViewController.m
//  yuanmaiDriver
//
//  Created by 姜宁桃 on 2017/3/9.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "MyInfoViewController.h"

@interface MyInfoViewController ()
{
    UIImageView * _logoImgView;
    UILabel * _nameLabel;
    UILabel * _telLabel;
    UILabel * _plateLabel;//    车牌号
}

@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"我的信息";
    [self showBackBtn];
    
    [self configUI];
}

- (void)configUI
{
    _logoImgView = [UIImageView imageViewWithFrame:CGRectMake(screen_width/2-68*widthScale*0.618, 80*heightScale, 136*widthScale*0.618, 96*heightScale*0.618) image:@"yuanmaiLogo"];
    [self.view addSubview:_logoImgView];
    
    [self showHUD:@"加载中，请稍候。。。" isDim:YES];
    [NetRequest postDataWithUrlString:API_GETDriverInfo_URL withParams:@{@"driver_id":GETDriver_ID} success:^(id data) {
        NSLog(@"%@", data);
        [self hideHUD];
        if ([data[@"code"] isEqualToString:@"1"]) {
            NSDictionary * userData = data[@"data"];
            _nameLabel = [UILabel labelWithFrame:CGRectMake(screen_width/2-120*widthScale, _logoImgView.bottom +30*heightScale, 240*widthScale, 35*heightScale) text:[NSString stringWithFormat:@"姓名：%@", userData[@"name"]] font:16 textColor:[UIColor darkTextColor]];
            _nameLabel.textAlignment = NSTextAlignmentCenter;
            _nameLabel.backgroundColor = [UIColor lightGrayColor];
            [self.view addSubview:_nameLabel];
            
            _telLabel = [UILabel labelWithFrame:CGRectMake(screen_width/2-120*widthScale, _nameLabel.bottom +20*heightScale, 240*widthScale, 35*heightScale) text:[NSString stringWithFormat:@"手机号：%@", userData[@"tel"]] font:16 textColor:[UIColor darkTextColor]];
            _telLabel.textAlignment = NSTextAlignmentCenter;
            _telLabel.backgroundColor = [UIColor lightGrayColor];
            [self.view addSubview:_telLabel];
            
            _plateLabel = [UILabel labelWithFrame:CGRectMake(screen_width/2-120*widthScale, _telLabel.bottom +20*heightScale, 240*widthScale, 35*heightScale) text:[NSString stringWithFormat:@"车牌号：%@", userData[@"vehicle_id"]] font:16 textColor:[UIColor darkTextColor]];
            _plateLabel.textAlignment = NSTextAlignmentCenter;
            _plateLabel.backgroundColor = [UIColor lightGrayColor];
            [self.view addSubview:_plateLabel];
        }
        
    } fail:^(NSString *errorDes) {
        [self showTipView:@"获取信息失败！请检查当前网络状态或稍后再试。"];
        NSLog(@"errorDes: %@", errorDes);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
