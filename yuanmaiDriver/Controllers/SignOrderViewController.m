//
//  SignOrderViewController.m
//  yuanmaiDriver
//
//  Created by 姜宁桃 on 2017/2/1.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "SignOrderViewController.h"
#import "PJRSignatureView.h"
#import "UploadReceiptViewController.h"

@interface SignOrderViewController ()
{
    UIImageView * bgImageView;
    PJRSignatureView *signatureView;
}

@end

@implementation SignOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"订单签收";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backHomeVC:) name:@"backHomeVC" object:nil];
    [self showBackBtn];
    [self showRightBtn:CGRectMake(screen_width-75, 24, 70, 36) withFont:systemFont(16) withTitle:@"选择回单" withTitleColor:[UIColor whiteColor]];
    
    [self configUI];
}
-(void)backHomeVC:(NSNotification *)not{
    NSLog(@"not.user==%@",not.userInfo);
    if ([not.userInfo[@"key"] isEqualToString:@"1"]) {
        [self backClick:nil];
    }
}
- (void)configUI
{
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height)];
    [self.view addSubview:bgImageView];
    
    NSLog(@"%@", self.orderModel);
    signatureView = [[PJRSignatureView alloc]initWithFrame:CGRectMake(0, 64, screen_width, screen_height - 130) contract_num:self.orderModel.contract_num];
    [self.view addSubview:signatureView];
    
    UIButton *getBtn = [[UIButton alloc]initWithFrame:CGRectMake(screen_width - 200*widthScale, screen_height-50, 170*widthScale, 40)];
    [getBtn setTitle:@"获取签名并上传" forState:UIControlStateNormal];
    getBtn.backgroundColor = [UIColor purpleColor];
    [getBtn addTarget:self action:@selector(getword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getBtn];
    
    UIButton *clearnBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, screen_height-50, 80*widthScale, 40)];
    [clearnBtn setTitle:@"清除" forState:UIControlStateNormal];
    clearnBtn.backgroundColor = [UIColor brownColor];
    [clearnBtn addTarget:self action:@selector(clearWord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearnBtn];
    
    [self showTipView:@"请选择或拍摄要上传的回单！"];
    [self showCanEdit:YES photo:^(UIImage *photo) {
        
        bgImageView.image = photo;
    }];
}


-(void)clearWord
{
    [signatureView clearSignature];
}
-(void)getword
{
    UploadReceiptViewController *UploadReceiptVC = [[UploadReceiptViewController alloc]init];
    UploadReceiptVC.signImage = [signatureView getSignatureImage];
    UploadReceiptVC.receiptImage = bgImageView.image;
    UploadReceiptVC.orderModel = self.orderModel;
    if (UploadReceiptVC.receiptImage && UploadReceiptVC.signImage) {
        [self presentViewController:UploadReceiptVC animated:YES completion:nil];
    }else{
        [self showTipView:@"回单或签名不能为空，请确认后再上传"];
    }
    
    
}

- (void)navRightBtnClick:(UIButton *)button
{
    [self showCanEdit:YES photo:^(UIImage *photo) {
        
        bgImageView.image = photo;
    }];
}

-(void)backClick:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
