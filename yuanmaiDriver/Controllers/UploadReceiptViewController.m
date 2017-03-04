//
//  UploadReceiptViewController.m
//  yuanmaiDriver
//
//  Created by 姜宁桃 on 2017/3/4.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "UploadReceiptViewController.h"

@interface UploadReceiptViewController ()
{
    UIImageView * imageView;
}
@end

@implementation UploadReceiptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showBackBtn];
    self.titleLabel.text = @"上传签名";
    [self showRightBtn:CGRectMake(screen_width-75, 24, 70, 36) withFont:systemFont(16) withTitle:@"上传回单" withTitleColor:[UIColor whiteColor]];
    
    UIImage * finalImg = [self addImage:self.receiptImage toImage:self.signImage];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height-120)];
    imageView.image = finalImg;
    [self.view addSubview:imageView];
    
    UIButton *getBtn = [[UIButton alloc]initWithFrame:CGRectMake(screen_width - 170*widthScale, screen_height-50, 150*widthScale, 40)];
    [getBtn setTitle:@"上传回单签名" forState:UIControlStateNormal];
    getBtn.backgroundColor = [UIColor purpleColor];
    [getBtn addTarget:self action:@selector(uploadPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getBtn];
    
    UIButton *clearnBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, screen_height-50, 120*widthScale, 40)];
    [clearnBtn setTitle:@"保存到相册" forState:UIControlStateNormal];
    clearnBtn.backgroundColor = [UIColor brownColor];
    [clearnBtn addTarget:self action:@selector(savePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearnBtn];
}

- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    NSLog(@"image1 width:%f height:%f", image1.size.width, image1.size.height);
    NSLog(@"image2 width:%f height:%f", image2.size.width, image2.size.height);
    UIGraphicsBeginImageContext(image1.size);
    
    // Draw image1
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    // Draw image2
    [image2 drawInRect:CGRectMake(image1.size.width-540*0.6, image1.size.height-490*0.5, image2.size.width*0.8, image2.size.height*0.4)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

- (void)uploadPhoto
{
    NSData * imgData = UIImageJPEGRepresentation(imageView.image, 1.0f);
    NSString * image64 = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [self showHUD:@"正在上传回单，请稍候。。。" isDim:YES];
    NSDictionary * params = @{@"driver_id":GETDriver_ID, @"gid":self.orderModel.gid, @"receipt":image64, @"state":@"4"};
    [NetRequest postDataWithUrlString:API_OrderAction_URL withParams:params success:^(id data) {
        NSLog(@"%@", data);
        [self hideHUD];
        if ([data[@"code"] isEqualToString:@"1"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showTipView:@"回单上传成功！"];
            });
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showTipView:data[@"message"]];
            });
        }
    } fail:^(NSString *errorDes) {
        [self hideHUD];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showTipView:@"上传回单失败！请检查当前网络状态或稍后重试！"];
        });
    }];
}

- (void)savePhoto
{
    if (imageView.image) {
        [self loadImageFinished:imageView.image];
    }else
    {
        [self showTipView:@"你还没有生成客户签名，请先生成后再保存！"];
    }
}

- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [self showTipView:[NSString stringWithFormat:@"保存图片失败！error：%@", error]];
        NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    }else
    {
        [self showTipView:@"签名已成功保存至相册!"];
    }
}



-(void)backClick:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)navRightBtnClick:(UIButton *)button
{
    [self uploadPhoto];
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
