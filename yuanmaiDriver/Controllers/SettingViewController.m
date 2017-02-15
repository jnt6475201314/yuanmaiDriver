//
//  SettingViewController.m
//  SpecialLine
//
//  Created by 姜宁桃 on 2017/1/9.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableView.h"
#import "SafeSettingViewController.h"

@interface SettingViewController ()<TableViewSelectedEvent>

@property (nonatomic, strong) SettingTableView * tableView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"设置";
    [self showBackBtn];
    
    [self configUI];
}

- (void)configUI
{
    self.tableView.tabViewDataSource = [[NSMutableArray alloc] initWithArray:@[@"修改密码", @"消息通知", @"异地登录", @"缓存清理", @"分享给好友"]];
    [self.view addSubview:self.tableView];
    
}

#pragma mark - TableViewSelectedEvent
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellTitle = self.tableView.tabViewDataSource[indexPath.section];
    if ([cellTitle isEqualToString:@"分享给好友"]) {
        [self shareAppToGoodFriends];
    }else if ([cellTitle isEqualToString:@"缓存清理"])
    {
        [MYFactoryManager clearCache:[self applicationDocumentsDirectoryFile]];
        [self showTipView:@"清理成功！"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }else if ([cellTitle isEqualToString:@"修改密码"]){
        SafeSettingViewController * safeSettingVC = [[SafeSettingViewController alloc] init];
        [self.navigationController pushViewController:safeSettingVC animated:YES];
    }
}

- (NSString *)applicationDocumentsDirectoryFile{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [paths firstObject];
    NSString * filePath = [documentDirectory stringByAppendingPathComponent:@"/Caches/default/com.hackemist.SDWebImageCache.default"];
    NSLog(@"%@", filePath);
    return filePath;
}

- (void)shareAppToGoodFriends
{
    [self shareQQAndWechat:SHAREAPP_URL];
    [self shareSheetView:@"远迈物流 司机版 App下载" withImage:@"shareAppIcon"];
}


#pragma mark - Getter
-(SettingTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[SettingTableView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height - 64) style:UITableViewStyleGrouped cellHeight:44];
        _tableView.tableViewEventDelegate = self;
        [_tableView.mj_header removeFromSuperview];
        [_tableView.mj_footer removeFromSuperview];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIde"];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backClick:(UIButton *)button
{
    [self addAnimationWithType:TAnimationSuckEffect Derection:FAnimationFromTop];
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
