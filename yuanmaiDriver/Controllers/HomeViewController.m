//
//  HomeViewController.m
//  yuanmaiDriver
//
//  Created by 姜宁桃 on 2017/1/26.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "HomeViewController.h"
#import "SelectedView.h"
#import "OrderTableViewCell.h"
#import "OrderListModel.h"
#import "OrderTableView.h"
#import "DetailOrderViewController.h"
#import "TransportTableView.h"
#import "SignOrderViewController.h"

@interface HomeViewController ()<selectedBtnDelegate, UIScrollViewDelegate, TableViewSelectedEvent, OrderDelegate>
{
    SelectedView * _selectedView;
    UIScrollView * _scrollView;
    NSInteger _page;
    NSMutableDictionary * params;
    NSString * p;
    
    UIView * view;
    TransportTableView * _tableView0;
    OrderTableView * _tableView1;
    OrderTableView * _tableView2;
    OrderTableView * _tableView3;
    
    BOOL isFinsh;
    int index;
}
@property (nonatomic) NSArray * titles;
@property (nonatomic, strong) OrderTableView * tableView;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray * sectionArray;
@end

@implementation HomeViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString * isrefresh = [UserDefaults objectForKey:@"refresh"];
    if ([isrefresh isEqualToString:@"1"]) {
        [self.tableView.mj_header beginRefreshing];
    }
    
}

-(NSMutableArray *)sectionArray{
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _sectionArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"我的货单";
    index = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteSection:) name:@"deleteSection" object:nil];
    [self uploadPushInfoToServer];
    
    [self configUI];
}
- (void)deleteSection:(NSNotification *)not{
    NSNumber * number = not.userInfo[@"sectionNumber"];
    NSInteger section = [number integerValue];
    
    [self.sectionArray removeObjectAtIndex:section];
    [self.tableView removeData];
    for (NSDictionary * dic in self.sectionArray) {
        [self addToDataSourceWithDict:dic];
    }
    [_tableView0 reloadData];
    if (self.sectionArray.count<1) {
        [_selectedView changeFristBtnTitle:@"运输中"];
    }else{
        [_selectedView changeFristBtnTitle:[NSString stringWithFormat:@"运输中(%d)",self.sectionArray.count]];
    }
    
}
- (void)uploadPushInfoToServer
{
    NSString * registrationID = [JPUSHService registrationID];
    NSLog(@"registrationID:%@", registrationID);
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        
        NSLog(@"resCode:%d, registrationID:%@", resCode, registrationID);
    }];
    if (registrationID != NULL) {
        NSDictionary * pushParams= @{@"driver_id":GETDriver_ID, @"device_token":GETDeviceToken, @"type":@"siji", @"registrationID":registrationID};
        NSLog(@"%@?%@", API_uploadPushStr_URL, pushParams);
        [NetRequest postDataWithUrlString:API_uploadPushStr_URL withParams:pushParams success:^(id data) {
            
            NSLog(@"uploadPushInfoToServer data : %@", data);
        } fail:^(NSString *errorDes) {
            
            NSLog(@"设置推送信息失败，原因：%@", errorDes);
        }];
    }else
    {
        NSLog(@"没有获取到 registrationID，无法上传通知数据到服务器");
    }
    
}


- (void)configUI{
    self.titleLabel.text = @"订单中心";
    
    _page = 0;
    p = [NSString stringWithFormat:@"%ld", _page];
    
    params = [NSMutableDictionary dictionaryWithDictionary:@{@"driver_id":GETDriver_ID, @"p":p}];
    //self.titles = @[@"待运输", @"运输中", @"已到达", @"已回单"];
    self.titles = @[@"运输中", @"已完成"];
    [self configHeadSelectedView];
    [self configBottomScrollView];
}

- (void)configHeadSelectedView
{
    _selectedView = [[SelectedView alloc] initWithFrame:CGRectMake(0, 63, screen_width, 50*heightScale) withTitleArray:self.titles];
    [_selectedView setViewWithNomalColor:[UIColor lightGrayColor] withSelectColor:[UIColor redColor] withTitlefont:systemFont(17)];
    [_selectedView setViewSepColor:[UIColor lightGrayColor] sepHeight:_selectedView.height - 14 sepWidth:1];
    _selectedView.backgroundColor = [UIColor whiteColor];
    _selectedView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _selectedView.layer.borderWidth = 0.5f;
    _selectedView.selectDelegate = self;
    [_selectedView setMoveViewHidden:NO];
    [_selectedView setMoveViewAllWidth];
    [self.view addSubview:_selectedView];
    
}

- (void)configBottomScrollView{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _selectedView.bottom, screen_width, screen_height - 153)];
    _scrollView.contentSize = CGSizeMake(screen_width*(int)self.titles.count, screen_height - 153);
    _scrollView.delegate = self;
    _scrollView.bounces = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = NO;
    for (int i=0; i<(int)self.titles.count; i++) {
        
        view = [[UIView alloc] initWithFrame:CGRectMake(screen_width*i, 0, screen_width, _scrollView.height)];
        [_scrollView addSubview:view];
        
        
        
        if (i == 0) {
            TransportTableView * tableView = [[TransportTableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, self.view.height - 140) style:UITableViewStyleGrouped cellHeight:160];
            tableView.tableViewEventDelegate = self;
            [tableView registerNib:[UINib nibWithNibName:@"TransportTableViewCell" bundle:nil] forCellReuseIdentifier:@"TransportTableViewCell"];
            _tableView0 = tableView;
            [view addSubview:_tableView0];
        }else if (i == 1){
            OrderTableView * tableView = [[OrderTableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, self.view.height - 140) style:UITableViewStyleGrouped cellHeight:160];
            tableView.tableViewEventDelegate = self;
            tableView.Btndelegate = self;
            [tableView registerNib:[UINib nibWithNibName:@"OrderTableViewCell" bundle:nil] forCellReuseIdentifier:baseTableViewIdentifier];
            _tableView1 = tableView;
            [view addSubview:_tableView1];
        }
//        else if (i == 2){
//            _tableView2 = tableView;
//            [view addSubview:_tableView2];
//        }else if (i == 3){
//            _tableView3 = tableView;
//            [view addSubview:_tableView3];
//        }
    }
    
    self.tableView = _tableView0;
    //添加视图
    [self.view addSubview:_scrollView];
    
}

#pragma mark - selectedBtnDelegate -
-(void)selectedBtnSendSelectIndex:(int)selectedIndex
{
    if (selectedIndex != index) {
        isFinsh = !isFinsh;
    }
    
    [UserDefaults setObject:@"1" forKey:@"refresh"];
    _scrollView.contentOffset = CGPointMake(screen_width*selectedIndex, 0);
    
    [self updateTableViewDataWithIndex:selectedIndex];
    
    index = selectedIndex;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.currentIndex = scrollView.contentOffset.x/screen_width;
    NSLog(@"old index  =  %ld", self.currentIndex);
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSInteger end_dragging = scrollView.contentOffset.x/screen_width;
    NSLog(@"end_dragging %ld", end_dragging);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger  currentPage = scrollView.contentOffset.x/screen_width;  // 当前页面
    NSLog(@"current page = %ld", currentPage);
    UIButton * button = [_selectedView viewWithTag:100 + currentPage];
    [_selectedView selectBtnClick:button];
    
}


- (void)updateTableViewDataWithIndex:(NSInteger)index{
    p = [NSString stringWithFormat:@"%ld", _page];
//    switch (index) {
//        case 0:
//        {
//            // 待接单
//            self.tableView = _tableView0;
//            params = [NSMutableDictionary dictionaryWithDictionary:@{@"driver_id":GETDriver_ID, @"p":p}];
//        }
//            break;
//        case 1:
//        {
////            运输中
//            self.tableView = _tableView1;
//            params = [NSMutableDictionary dictionaryWithDictionary:@{@"driver_id":GETDriver_ID, @"p":p, @"state":@"2"}];
//            break;
//        }
//        case 2:
//        {
////            已到达
//            self.tableView = _tableView2;
//            params = [NSMutableDictionary dictionaryWithDictionary:@{@"driver_id":GETDriver_ID, @"p":p, @"state":@"3"}];
//        }
//            break;
//        case 3:
//        {
////            已回单
//            self.tableView = _tableView3;
//            params = [NSMutableDictionary dictionaryWithDictionary:@{@"driver_id":GETDriver_ID, @"p":p, @"state":@"4"}];
//        }
//            break;
//        default:
//            break;
//    }
    switch (index) {
        case 0:
        {
            //            运输中
            self.tableView = _tableView0;
            params = [NSMutableDictionary dictionaryWithDictionary:@{@"driver_id":GETDriver_ID, @"p":p}];
        }
            break;
        case 1:
        {
            //            已完成
            self.tableView = _tableView1;
            params = [NSMutableDictionary dictionaryWithDictionary:@{@"driver_id":GETDriver_ID, @"p":p, @"state":@"2"}];
            break;
        }
    }

    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - TableViewSelectedEvent
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView == _tableView1) {
        [UserDefaults setObject:@"0" forKey:@"refresh"];
    }
    
    DetailOrderViewController * detailOrderVC = [[DetailOrderViewController alloc] init];
    detailOrderVC.upVCTitle = @"订单详情";
    detailOrderVC.sectionNumber = indexPath.section;
    detailOrderVC.orderModel = self.tableView.tabViewDataSource[indexPath.section];
    
    [self.navigationController pushViewController:detailOrderVC animated:YES];

}

- (void)headerRefreshingEvent
{
    [self showHUD:@"数据加载中，请稍候。。" isDim:YES];
    _page = 1;
    [params setObject:[NSString stringWithFormat:@"%ld", _page] forKey:@"p"];
    NSLog(@"%@?%@", API_ResourceOfOrders_URL, params);
    [NetRequest postDataWithUrlString:API_ResourceOfOrders_URL withParams:params success:^(id data) {
        [self.tableView.tabViewDataSource removeAllObjects];
        NSLog(@"%@", data);
        if ([data[@"code"] isEqualToString:@"1"]) {
            
            if (!isFinsh) {
                
                int number = [data[@"aa"] intValue];
                
                NSString * numString = [NSString stringWithFormat:@"运输中(%d)",number];
                [_selectedView changeFristBtnTitle:numString];
                
            }else{
                NSString * numString = [NSString stringWithFormat:@"已完成(%@)",data[@"aa"]];
                [_selectedView changeSecoundBtnTitle:numString];
                
            }
            for (NSDictionary * dict in data[@"data"]) {
                [self.sectionArray addObject:dict];
                // 区分放入数组
                [self addToDataSourceWithDict:dict];
                
            }
        }else if ([data[@"code"] isEqualToString:@"2"]){
            if (!isFinsh) {
                //运输中
                [_selectedView changeFristBtnTitle:@"运输中"];
                
            }else{
                [_selectedView changeSecoundBtnTitle:@"已完成"];
                
            }
            [self showTipView:data[@"message"]];
        }else
        {
            [self showTipView:data[@"message"]];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        [self hideHUD];
    } fail:^(id errorDes) {
        
        [self hideHUD];
        [self.tableView.mj_header endRefreshing];
        NSLog(@"%@", errorDes);
    }];

}

- (void)addToDataSourceWithDict:(NSDictionary *)dict{
    if (self.tableView == _tableView0) {
        OrderListModel * model = [[OrderListModel alloc] initWithDictionary:dict error:nil];

        [self.tableView.tabViewDataSource addObject:model];
    }else if (self.tableView == _tableView1){
        
        OrderListModel * model = [[OrderListModel alloc] initWithDictionary:dict error:nil];
        if ([model.state isEqualToString:@"已完成"]) {
            [self.tableView.tabViewDataSource addObject:model];
        }
    }
//    else if (self.tableView == _tableView2){
//        OrderListModel * model = [[OrderListModel alloc] initWithDictionary:dict error:nil];
//        if ([model.state isEqualToString:@"已完成"]) {
//            [self.tableView.tabViewDataSource addObject:model];
//        }
//    }else if (self.tableView == _tableView3){
//        OrderListModel * model = [[OrderListModel alloc] initWithDictionary:dict error:nil];
//        if ([model.state isEqualToString:@"已回单"]) {
//            [self.tableView.tabViewDataSource addObject:model];
//        }
//    }
}

- (void)footerRefreshingEvent
{
    _page++;
    [params setObject:[NSString stringWithFormat:@"%ld", _page] forKey:@"p"];
    NSLog(@"%@?%@", API_ResourceOfOrders_URL, params);
    [NetRequest postDataWithUrlString:API_ResourceOfOrders_URL withParams:params success:^(id data) {
        
        NSLog(@"%@", data);
        if ([data[@"code"] isEqualToString:@"1"]) {
            for (NSDictionary * dict in data[@"data"]) {
                
                [self addToDataSourceWithDict:dict];
            }
        }else if ([data[@"code"] isEqualToString:@"2"]){
            if ([data[@"message"] isEqualToString:@"暂无订单信息"]) {
                [self showTipView:@"暂无更多订单信息"];
            }else
            {
                [self showTipView:data[@"message"]];
            }
        }
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } fail:^(id errorDes) {
        
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"%@", errorDes);
    }];
}

#pragma mark - OrderBtnDelegate
-(void)OrderBtnClick:(id)model{
    SignOrderViewController * signOrderVC = [[SignOrderViewController alloc] init];
    signOrderVC.orderModel = model;
    NSLog(@"%@", signOrderVC.orderModel);
    [self presentViewController:signOrderVC animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)backClick:(UIButton *)button
//{
//    NSLog(@"扫描");
//    ScanOrderViewController * scanOrderVC = [[ScanOrderViewController alloc] init];
//    scanOrderVC.vcTitle = @"订单扫描";
//    [self addAnimationWithType:TAnimationCameraIrisHollowOpen Derection:FAnimationFromLeft];
//    [self.navigationController pushViewController:scanOrderVC animated:YES];
//}
@end
