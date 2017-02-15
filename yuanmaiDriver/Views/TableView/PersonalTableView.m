//
//  PersonalTableView.m
//  yuanmaiDriver
//
//  Created by 姜宁桃 on 2017/2/2.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "PersonalTableView.h"
#import "PersonalTableViewCell.h"
#import "PersonalModel.h"

@implementation PersonalTableView
-(instancetype)initWithFrame:(CGRect)frame tableViewStyle:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        
        [self configHeadView];
    }
    return self;
}

- (void)configHeadView{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 180)];
    view.backgroundColor = red_color;
    view.alpha = 0.8;
    self.tableHeaderView = view;
    
    UIImageView * headImgView = [UIImageView imageViewWithFrame:CGRectMake(20, 0, 100, 100) image:@"per_headimg"];
    headImgView.center = CGPointMake(20+headImgView.width/2, view.center.y);
    [view addSubview:headImgView];
    
    NSDictionary * data = [UserDefaults objectForKey:@"data"];
    NSLog(@"%@", data);
    UILabel * nameLabel = [UILabel labelWithFrame:CGRectMake(headImgView.right+10, view.height/2 - 20, 120, 40) text:data[@"user_name"] font:16 textColor:[UIColor darkTextColor]];
    [view addSubview:nameLabel];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PersonalTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"personalCell" forIndexPath:indexPath];
    
    PersonalModel * model = self.dataArray[indexPath.row];
    cell.personalImageView.image = [UIImage imageNamed:model.perheadimg];
    cell.personalTitleLabel.text = model.pertitle;
    
    return cell;
}

#pragma mark - TableViewSelectedEvent
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.tableViewEventDelegate respondsToSelector:@selector(didSelectRowAtIndexPath:)]) {
        [self.tableViewEventDelegate didSelectRowAtIndexPath:indexPath];
    }
}


//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 160)];
//    view.backgroundColor = [UIColor blueColor];
//    
//    return view;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

@end
