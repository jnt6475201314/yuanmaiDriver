//
//  BaseCollectionView.m
//  GoHiking_app
//
//  Created by qf on 15/10/17.
//  Copyright (c) 2015年 qf. All rights reserved.
//

#import "BaseCollectionView.h"
#import <MJRefresh/MJRefresh.h>


@implementation BaseCollectionView
{
    UIView *_tipView;
}

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self _initCon];
    }
    return self;
}

- (void)_initCon{
    self.delegate = self;
    self.dataSource = self;
    
//    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"identify"];
//    // -- header view --
//    [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];

}

- (void)setData:(NSArray *)data {
    if (_data != data) {
        _data = data;
    }
    if (!self.noTip) {
        if (self.data.count == 0) {
            if (_tipView == nil) {
                _tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
                UILabel *tipLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
                tipLable.center = CGPointMake(_tipView.width/2, _tipView.height/2);
                tipLable.textColor = [UIColor grayColor];
                tipLable.font = [UIFont boldSystemFontOfSize:16.0f];
                tipLable.text = @"暂无数据";
                [_tipView addSubview:tipLable];
            }
            if (![_tipView superview]) {
                [self addSubview:_tipView];
            }
        }else {
            if ([_tipView superview]) {
                [_tipView removeFromSuperview];
            }
        }

    }
}

- (void)setIsDrag:(BOOL)isDrag {
    if (_isDrag != isDrag) {
        _isDrag = isDrag;
    }
    //是否可拖拽，如果可以才在此处创建刷新视图
    if (_isDrag) {
        [self createRefreshView];
    }
}

- (void)createRefreshView{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"下拉刷新");
        if ([self.eventDelegate respondsToSelector:@selector(pullDownCollectionView:)]) {
            [self.eventDelegate pullDownCollectionView:self];
        }
    }];
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if ([self.eventDelegate respondsToSelector:@selector(pullUpCollectionView:)]) {
            [self.eventDelegate pullUpCollectionView:self];
        }
        NSLog(@"上拉刷新");
    }];
}

- (void)reloadData {
    [super reloadData];
    if (self.isDrag) {
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
    }
}

#pragma mark UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//头视图的视图设置
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    UICollectionReusableView *reusableview = nil;
//    if (kind == UICollectionElementKindSectionHeader){
//        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
//    }
//    return reusableview;
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"identify";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    return cell;
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //返回item大小
    return CGSizeMake((screen_width-40)/3, 120);
}

////返回头视图高度
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    return CGSizeMake(screen_width, 40);
//}

//item的偏移和压缩
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark UICollectionDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.eventDelegate respondsToSelector:@selector(didSelectCollectionView:forIndexPath:)]) {
        [self.eventDelegate didSelectCollectionView:collectionView forIndexPath:indexPath];
    }
    [self deselectItemAtIndexPath:indexPath animated:YES];
}



@end
