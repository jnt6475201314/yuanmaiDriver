//
//  ServiceViewController.m
//  yuanmaiDriver
//
//  Created by 姜宁桃 on 2017/5/15.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "ServiceViewController.h"
#import "ServiceCollectionView.h"

@interface ServiceViewController ()

@property (nonatomic, strong)ServiceCollectionView * serviceCV;

@end

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"服务";
    //self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
}

- (void)configUI{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(30, 30);
    // 设置最小行间距
    layout.minimumLineSpacing = 2;
    // 设置垂直间距
    layout.minimumInteritemSpacing = 2;
    // 设置滚动方向（默认垂直滚动）
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.serviceCV = [[ServiceCollectionView alloc]initWithFrame:CGRectMake(0, 63, screen_width, screen_height-112) collectionViewLayout:layout];
    self.serviceCV.data = @[
                                @{@"image":@"navigation",@"lab":@"导航"},
                                @{@"image":@"nearby",@"lab":@"附近服务"},
                                @{@"image":@"traffic_violation",@"lab":@"查询违章"},
                                ];
    [self.view addSubview:self.serviceCV];
    
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
