//
//  MineViewController.m
//  Working
//
//  Created by 姜宁桃 on 16/7/8.
//  Copyright © 2016年 小浩. All rights reserved.
//

#import "MineViewController.h"
#import "PersonalModel.h"
#import "PersonalTableView.h"
#import "PersonalTableViewCell.h"
#import "LoginViewController.h"
#import "SuggestionViewController.h"
#import "SettingViewController.h"


@interface MineViewController ()<TableViewSelectedEvent>

@property (nonatomic, strong) UIAlertController * alertController;
@property (nonatomic, strong) PersonalTableView * tableView;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"个人中心";
    [self configUI];
}

- (void)configUI
{
    [self configDataSource];
    [self.view addSubview:self.tableView];
}

- (void)configDataSource
{
    NSArray * dataArray = @[@{@"pertitle":@"联系客服", @"perheadimg":@"p_service"}, @{@"pertitle":@"意见反馈", @"perheadimg":@"p_advice"}, @{@"pertitle":@"系统设置", @"perheadimg":@"p_set"}, @{@"pertitle":@"退出登录", @"perheadimg":@"p_logout"}];
    NSMutableArray * dataSource = [[NSMutableArray alloc] init];
    for (NSDictionary * dict in dataArray) {
        PersonalModel * model = [[PersonalModel alloc] initWithDictionary:dict error:nil];
        [dataSource addObject:model];
    }
    self.tableView.dataArray = [NSMutableArray arrayWithArray:dataSource];
    NSLog(@"%@", self.tableView.dataArray);
    [self.tableView reloadData];
}

#pragma mark -TableViewSelectedEvent
-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", indexPath.row);
    if (indexPath.row == 0) {
        [self telephoBtnEvent];
    }else if (indexPath.row == 3){
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        loginVC.logOut = @"YES";
        AppDelegateInstance.window.rootViewController = loginVC;
    }else if (indexPath.row == 1){
        SuggestionViewController * suggestionVC = [[SuggestionViewController alloc] init];
        [self presentViewController:suggestionVC animated:YES completion:nil];
    }else if (indexPath.row == 2){
        SettingViewController * safeSettingVC = [[SettingViewController alloc] init];
        [self.navigationController pushViewController:safeSettingVC animated:YES];
    }
}

#pragma mark - － 打电话给远迈 － －
- (void)telephoBtnEvent
{
    NSLog(@"tel");
    _alertController = [UIAlertController alertControllerWithTitle:@"远迈客服💁" message:@"☎️：0571-28973920" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:self.alertController animated:YES completion:nil];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [_alertController addAction:cancelAction];
    UIAlertAction * callAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self callServer];
    }];
    [self.alertController addAction:callAction];
}

- (void)callServer
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://057128973920"]];
}

#pragma mark - Getter
-(PersonalTableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[PersonalTableView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height - 100) tableViewStyle:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"PersonalTableViewCell" bundle:nil] forCellReuseIdentifier:@"personalCell"];
        _tableView.tableViewEventDelegate = self;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
