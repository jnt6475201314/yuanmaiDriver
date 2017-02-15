//
//  SettingTableView.m
//  SpecialLine
//
//  Created by 姜宁桃 on 2017/1/10.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "SettingTableView.h"

@implementation SettingTableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellIde"];
    
    cell.textLabel.text = self.tabViewDataSource[indexPath.section];
    
    if ([cell.textLabel.text isEqualToString:@"消息通知"]) {
        
        UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(screen_width - 70, 8.0f, 60.0f, 28.0f)];
        if ([MYFactoryManager isAllowedNotification]) {
            NSLog(@"允许通知");
            [switchButton setOn:YES];
        }else
        {
            NSLog(@"不允许通知");
            [switchButton setOn:NO];
        }
        [switchButton addTarget:self action:@selector(notificationSwitchAction:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:switchButton];
    }else if ([cell.textLabel.text isEqualToString:@"异地登录"]) {
        
        UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(screen_width - 70, 8.0f, 60.0f, 28.0f)];
        if ([GetRELOGINStatus isEqualToString:@"YES"]) {
            NSLog(@"允许检测");
            [switchButton setOn:YES];
        }else
        {
            NSLog(@"不允许检测");
            [switchButton setOn:NO];
        }
        [switchButton addTarget:self action:@selector(reloginSwitchAction:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:switchButton];
    }else if ([cell.textLabel.text isEqualToString:@"缓存清理"])
    {
        NSString * cacheSize = [NSString stringWithFormat:@"%.2f MB", [MYFactoryManager folderSizeAtPath:[self applicationDocumentsDirectoryFile]]];
        NSLog(@"%@", cacheSize);
        UILabel * lab = [UILabel labelWithFrame:CGRectMake(screen_width - 100, 8.0, 90, 28) text:cacheSize font:15 textColor:[UIColor darkGrayColor]];
        lab.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:lab];
    }else if ([cell.textLabel.text isEqualToString:@"分享给好友"])
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if ([cell.textLabel.text isEqualToString:@"修改密码"]){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (NSString *)applicationDocumentsDirectoryFile{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [paths firstObject];
    NSString * filePath = [documentDirectory stringByAppendingPathComponent:@"/Caches/default/com.hackemist.SDWebImageCache.default"];
    NSLog(@"%@", filePath);
    return filePath;
}

- (void)notificationSwitchAction:(UISwitch *)switchButton
{
    if (switchButton.on) {
        NSLog(@"打开了");
        if ([MYFactoryManager isAllowedNotification]) {
            NSLog(@"允许通知");
        }else
        {
            NSLog(@"不允许通知， 去设置打开通知");
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
        
        [UserDefaults setObject:@"YES" forKey:NOTIFICATION];
        [UserDefaults synchronize];
    }else
    {
        NSLog(@"关闭了");
        [UserDefaults setObject:@"NO" forKey:NOTIFICATION];
        [UserDefaults synchronize];
    }
}

- (void)reloginSwitchAction:(UISwitch *)switchButton{
    if (switchButton.on) {
        // 打开了
        [UserDefaults setObject:@"YES" forKey:RELOGIN];
        [UserDefaults synchronize];
    }else
    {
        // 关闭了
        [UserDefaults setObject:@"NO" forKey:RELOGIN];
        [UserDefaults synchronize];
    }
}

@end
