//
//  BaseCollectionView.h
//  GoHiking_app
//
//  Created by qf on 15/10/17.
//  Copyright (c) 2015年 qf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>
#import <AFNetworking/AFHTTPSessionManager.h>
@protocol CollectionViewEventDelegate <NSObject>
@optional
//下拖
- (void)pullDownCollectionView:(UICollectionView *)collectionView;
//上拉
- (void)pullUpCollectionView:(UICollectionView *)collectionView;
//选中
- (void)didSelectCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;
@end

@interface BaseCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)NSArray *data;

@property (nonatomic,assign)BOOL isDrag; //是否可拖拽
@property (nonatomic,assign)BOOL noTip;

@property (nonatomic,weak)id<CollectionViewEventDelegate> eventDelegate;

- (void)_initCon;

@end
