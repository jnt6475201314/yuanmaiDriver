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
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 150*heightScale)];
    view.backgroundColor = [UIColor whiteColor];
    view.alpha = 0.8;
    self.tableHeaderView = view;
    
    UIImageView * headImgView = [UIImageView imageViewWithFrame:CGRectMake(20, 0, 136*widthScale*0.618*widthScale, 96*heightScale*0.618*widthScale) image:@"yuanmaiLogo"];
    headImgView.center = CGPointMake(view.center.x, view.center.y-20*heightScale);
    [view addSubview:headImgView];
    
    NSDictionary * data = [UserDefaults objectForKey:@"data"];
    NSLog(@"%@", data);
    UILabel * nameLabel = [UILabel labelWithFrame:CGRectMake(view.width/2-100, headImgView.bottom + 10, 200, 40) text:data[@"user_name"] font:20 textColor:[UIColor darkTextColor]];
    nameLabel.textAlignment = NSTextAlignmentCenter;
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
