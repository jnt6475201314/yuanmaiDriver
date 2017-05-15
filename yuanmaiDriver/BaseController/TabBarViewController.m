//
//  TabBarViewController.m
//  YouLX
//
//  Created by king on 15/12/12.
//  Copyright © 2015年 feiwei. All rights reserved.
//

#import "TabBarViewController.h"
#import "HomeViewController.h"
#import "IWViewController.h"
#import "ServiceViewController.h"
#import "MineViewController.h"
#import "ScanOrderViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController
{
    MyPicButton *lastBtn;
}
//
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBar.hidden = NO;
    if (self.viewControllers.count > 0) {
        return;
    }
    
    [self initTabBar];
    [self saveNavCon];

}

- (void)saveNavCon{
    HomeViewController *homeVC = [[HomeViewController alloc] init];
//    LatestViewController *itemVC = [[LatestViewController alloc] init];
//    DiscoveryViewController *investVC = [[DiscoveryViewController alloc] init];
//    BuycarViewController *buycarVC = [[BuycarViewController alloc] init];
    IWViewController * iwVC = [[IWViewController alloc]init];
    ServiceViewController * serviceVC = [[ServiceViewController alloc]init];
    MineViewController *mineVC = [[MineViewController alloc] init];
    
    //用户默认信息
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *userId = [defaults objectForKey:@"userId"];
    NSArray *viewArr = [[NSArray alloc] initWithObjects:homeVC,iwVC,serviceVC,mineVC, nil];
    NSMutableArray *mArray = [[NSMutableArray alloc] initWithCapacity:viewArr.count];
    for (UIViewController *vc in viewArr) {
        UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:vc];
        navCon.delegate = self;
        [mArray addObject:navCon];
    }
    self.viewControllers = mArray;
    self.selectedIndex = 0;
}

- (void)initTabBar{
    _tabView = [[UIView alloc] initWithFrame:CGRectMake(0, screen_height-49, screen_height, 49)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 49)];
    imageView.backgroundColor = tabBar_color;
    [_tabView addSubview:imageView];
    //细线
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, screen_width, 0.5)];
    sepLine.backgroundColor = background_color;
    [_tabView addSubview:sepLine];
    NSArray *titleArray = @[@"我的货单", @"即时运单", @"服务", @"个人中心"];
    NSArray *picArray = @[@"货单",@"即时运单", @"sevice_no_select", @"个人中心"];
    NSArray *highArray = @[@"货单_h",@"即时运单_h",@"sevice_select", @"个人中心_h"];
    for (int i=0; i<titleArray.count; i++) {
        MyPicButton *button = [MyPicButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(screen_width/titleArray.count*i, 0, screen_width/titleArray.count, 49);
        [button setBtnViewWithImage:[picArray objectAtIndex:i] withImageWidth:25 withTitle:[titleArray objectAtIndex:i] withTitleColor:default_text_color withFont:systemFont(15.0f)];
        button.picPlacement = 1;
        button.imageDistant = 5;
        [button setBtnselectImage:[highArray objectAtIndex:i]withselectTitleColor:red_color];
        button.tag = 100+i;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_tabView addSubview:button];
        if (i == 0) {
            button.myBtnSelected = YES;
            lastBtn = button;
        }
        
//        UIButton * scanBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width/2 - 25, -20, 50, 50)];
//        [scanBtn setImage:[UIImage imageNamed:@"扫描"] forState:UIControlStateNormal];
//        scanBtn.backgroundColor = [UIColor whiteColor];
//        scanBtn.layer.cornerRadius = 25;
//        scanBtn.clipsToBounds = YES;
//        scanBtn.layer.borderColor = background_color.CGColor;
//        scanBtn.layer.borderWidth = 0.5;
//        [scanBtn addTarget:self action:@selector(scanBtnClickEvnet) forControlEvents:UIControlEventTouchUpInside];
//        [_tabView addSubview:scanBtn];
    }
    [self.view addSubview:_tabView];
}

#pragma 标签栏按钮
- (void)btnClick:(MyPicButton *)button{
    if (button != lastBtn) {
        button.myBtnSelected = !button.myBtnSelected;
        lastBtn.myBtnSelected = NO;
        lastBtn = button;
    }
    //计算按钮间隔
    self.selectedIndex = button.tag - 100;
}

- (void)scanBtnClickEvnet
{
    ScanOrderViewController * scanOrderVC = [[ScanOrderViewController alloc] init];
    scanOrderVC.vcTitle = @"订单扫描";
    [self presentViewController:scanOrderVC animated:YES completion:nil];
}

#pragma UINavigationDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //计算导航栏控制器子控制器个数
    int count = (int)navigationController.viewControllers.count;
    if (count == 2) {
        [self showTabbar:NO];
    }else if(count == 1) {
        [self showTabbar:YES];
    }
}

//是否隐藏tabbar
- (void)showTabbar:(BOOL)show
{
    [UIView animateWithDuration:0.2 animations:^{
        if (show) {
            _tabView.frame = CGRectMake(0, screen_height - 49 , screen_width, 49);
        }else{
            _tabView.frame = CGRectMake(0, screen_height+20 , screen_width, 49);
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
