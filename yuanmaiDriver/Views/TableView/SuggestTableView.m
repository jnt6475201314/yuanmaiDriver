//
//  SuggestTableView.m
//  SpecialLine
//
//  Created by 姜宁桃 on 2017/1/7.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "SuggestTableView.h"
#import "SuggestionTableViewCell.h"

@implementation SuggestTableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SuggestionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"suggestionCell"];
    cell.suggestionTitleLabel.text = self.tabViewDataSource[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}

@end
