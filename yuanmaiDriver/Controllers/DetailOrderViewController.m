//
//  DetailOrderViewController.m
//  yuanmaiDriver
//
//  Created by 姜宁桃 on 2017/2/1.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "DetailOrderViewController.h"
#import "SignOrderViewController.h"

@interface DetailOrderViewController ()<UIWebViewDelegate>
{
    UIButton * _actionButton;   // 操作按钮
    NSMutableDictionary * _params;   // 参数字典
    NSString * _orderId;
    NSString * _state;
    
    UIButton * _deleteButton;   // 删除按钮
}
@property (nonatomic, strong) UIWebView * webView;

@end

@implementation DetailOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"运单详情";
    [self showBackBtn];
    
    if ([self.upVCTitle isEqualToString:@"订单扫描"]) {
        _params = [[NSMutableDictionary alloc] initWithDictionary:@{@"longitude":GetLongitude,@"latitude":GetLatitude,@"driver_id":GETDriver_ID,@"gid":self.scanModel.gid}];
        _orderId = self.scanModel.gid;
        _state = self.scanModel.state;
    }else if([self.upVCTitle isEqualToString:@"订单详情"])
    {
        NSLog(@"经纬度：%@ %@", GetLongitude, GetLatitude);
        if (GetLongitude) {
            _params = [[NSMutableDictionary alloc] initWithDictionary:@{@"longitude":GetLongitude,@"latitude":GetLatitude,@"driver_id":GETDriver_ID,@"gid":self.orderModel.gid}];
        }else
        {
            _params = [[NSMutableDictionary alloc] initWithDictionary:@{@"driver_id":GETDriver_ID,@"gid":self.orderModel.gid}];
        }
        _orderId = self.orderModel.gid;
        _state = self.orderModel.state;
    }
    [self configUI];
}

- (void)configUI
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height - 110)];
    self.webView.delegate = self;
    self.webView.userInteractionEnabled = YES;
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_OrderDetailWith(_orderId)]];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    [self showHUD:@"数据加载中，请稍候。。。" isDim:YES];

    _actionButton = [UIButton buttonWithFrame:CGRectMake(screen_width/2 - 60, screen_height - 42, 120, 40) title:@"" image:@"" target:self action:@selector(actionButtonEvent:)];
    _actionButton.backgroundColor = red_color;
    _actionButton.layer.cornerRadius = 10;
    _actionButton.clipsToBounds = YES;
    [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_actionButton];
    
    _deleteButton = [UIButton buttonWithFrame:CGRectMake(screen_width/2 - 60, screen_height - 42, 120, 40) title:@"删除订单" image:@"" target:self action:@selector(deleteButtonEvent)];
    _deleteButton.backgroundColor = [UIColor redColor];
    _deleteButton.layer.cornerRadius = 10;
    _deleteButton.clipsToBounds = YES;
    [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _deleteButton.hidden = YES;
    [self.view addSubview:_deleteButton];
    
    if ([self.upVCTitle isEqualToString:@"订单详情"]) {
        if ([self.orderModel.state isEqualToString:@"已回单"]) {
            _actionButton.hidden = YES;
            _deleteButton.hidden = NO;
        }else{
            _deleteButton.hidden = YES;
            _actionButton.hidden = NO;
            if ([_state isEqualToString:@"已完成"]){
                if ([self.orderModel.cooperation_company isEqualToString:@"3"]) {
                    _actionButton.hidden = YES;
                    _deleteButton.hidden = NO;
                }else
                {
                    [_actionButton setTitle:@"客户签收" forState:UIControlStateNormal];
                    [_params setObject:@"4" forKey:@"state"];
                }
            }else if ([_state isEqualToString:@"运输中"]){
                [_actionButton setTitle:@"确认到达" forState:UIControlStateNormal];
                [_params setObject:@"3" forKey:@"state"];
            }else if ([_state isEqualToString:@"待运输"]){
                [_actionButton setTitle:@"开始运输" forState:UIControlStateNormal];
                [_params setObject:@"2" forKey:@"state"];
            }
        }
    }else
    {
        _actionButton.hidden = YES;
        _deleteButton.hidden = YES;
    }
    
}

#pragma mark - Event Hander
- (void)actionButtonEvent:(UIButton *)actionBtn
{
//    if ([actionBtn.currentTitle isEqualToString:@"回单上传"]) {
//        
//        [self showCanEdit:YES photo:^(UIImage *photo) {
//            NSData * imgData = UIImageJPEGRepresentation(photo, 0.5f);
//            NSString * image64 = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//            [self showHUD:@"正在上传回单，请稍候。。。" isDim:YES];
//            NSDictionary * params = @{@"driver_id":GETDriver_ID, @"gid":self.orderModel.uid, @"receipt":image64, @"state":@"4", @"autograph":image64};
//            [NetRequest postDataWithUrlString:API_OrderAction_URL withParams:params success:^(id data) {
//                NSLog(@"%@", data);
//                [self hideHUD];
//                if ([data[@"code"] isEqualToString:@"1"]) {
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [self showTipView:@"回单上传成功！"];
//                    });
//                }else{
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [self showTipView:data[@"message"]];
//                    });
//                }
//            } fail:^(NSString *errorDes) {
//                [self hideHUD];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self showTipView:@"上传回单失败！请检查当前网络状态或稍后重试！"];
//                });
//            }];
//        }];
//
//    }else
    if ([actionBtn.currentTitle isEqualToString:@"客户签收"]) {
        SignOrderViewController * signOrderVC = [[SignOrderViewController alloc] init];
        signOrderVC.orderModel = self.orderModel;
        NSLog(@"%@", signOrderVC.orderModel);
        [self presentViewController:signOrderVC animated:YES completion:nil];
    }
    else{
        [self showHUD:@"正在操作，请稍候。。。" isDim:YES];
        NSLog(@"%@?%@", API_OrderAction_URL, _params);
        [NetRequest postDataWithUrlString:API_OrderAction_URL withParams:_params success:^(id data) {
            
            [self hideHUD];
            if ([data[@"code"] isEqualToString:@"1"]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showTipView:@"操作成功！"];
                    _actionButton.backgroundColor = [UIColor lightGrayColor];
                    _actionButton.enabled = NO;
                });
            }else{
                NSLog(@"操作失败！%@", data[@"message"]);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showTipView:data[@"message"]];
                });
            }
            
        } fail:^(NSString *errorDes) {
            
            NSLog(@"操作失败！原因：%@", errorDes);
            [self hideHUD];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showTipView:@"操作失败！请检查网络状态或稍候重试。"];
            });
        }];
    }
}

- (void)deleteButtonEvent
{
    [self showHUD:@"正在操作，请稍候。。。" isDim:YES];
    NSLog(@"%@?%@", API_OrderDelete_URL, @{@"driver_id":GETDriver_ID, @"gid":self.orderModel.gid});
    [NetRequest postDataWithUrlString:API_OrderDelete_URL withParams:@{@"driver_id":GETDriver_ID, @"gid":self.orderModel.gid} success:^(id data) {
        
        [self hideHUD];
        if ([data[@"code"] isEqualToString:@"1"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showTipView:@"删除成功！"];
                _actionButton.backgroundColor = [UIColor lightGrayColor];
                _actionButton.enabled = NO;
            });
        }else{
            NSLog(@"删除失败！%@", data[@"message"]);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showTipView:data[@"message"]];
            });
        }
        
    } fail:^(NSString *errorDes) {
        
        NSLog(@"删除失败！原因：%@", errorDes);
        [self hideHUD];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showTipView:@"删除失败！请检查网络状态或稍候重试。"];
        });
    }];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showTipView:[NSString stringWithFormat:@"数据请求出错，错误信息：%@", error]];
    });
}

-(void)backClick:(UIButton *)button
{
    if ([self.upVCTitle isEqualToString:@"订单扫描"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if([self.upVCTitle isEqualToString:@"订单详情"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
